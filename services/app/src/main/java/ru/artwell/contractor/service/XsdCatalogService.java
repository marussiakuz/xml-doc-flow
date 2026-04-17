package ru.artwell.contractor.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.annotation.Lazy;
import org.springframework.core.io.Resource;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ru.artwell.contractor.config.AppTimeConfiguration;
import ru.artwell.contractor.persistence.entity.XsdDefinitionEntity;
import ru.artwell.contractor.persistence.repository.XsdDefinitionRepository;
import org.w3c.dom.ls.LSInput;
import org.xml.sax.SAXException;

import javax.xml.XMLConstants;
import javax.xml.transform.stream.StreamSource;
import javax.xml.validation.Schema;
import javax.xml.validation.SchemaFactory;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.Reader;
import java.io.StringReader;
import java.net.URI;
import java.net.URL;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Service
public class XsdCatalogService {

    private static final Logger log = LoggerFactory.getLogger(XsdCatalogService.class);

    private static final Pattern XS_ELEMENT_OPEN_TAG = Pattern.compile(
            "<xs:element\\s+((?:[^/>]|/(?!>))*)\\s*/\\s*>",
            Pattern.DOTALL | Pattern.CASE_INSENSITIVE);

    private final ZoneId applicationZoneId;
    private final XsdDefinitionRepository xsdDefinitionRepository;
    private final XsdCatalogService self;

    private final Map<String, DocumentTypeMapping> mappingByQName = new ConcurrentHashMap<>();
    private final Map<String, String> xsdContentByNamespace = new ConcurrentHashMap<>();
    private final Map<String, String> xsdContentByFilename = new ConcurrentHashMap<>();
    private final Map<String, String> xsdContentByResourcePath = new ConcurrentHashMap<>();
    private final Map<String, Schema> schemaCache = new ConcurrentHashMap<>();

    public XsdCatalogService(XsdDefinitionRepository xsdDefinitionRepository,
                             @Qualifier(AppTimeConfiguration.APPLICATION_ZONE_ID) ZoneId applicationZoneId,
                             @Lazy XsdCatalogService self) {
        this.xsdDefinitionRepository = xsdDefinitionRepository;
        this.applicationZoneId = applicationZoneId;
        this.self = self;
    }

    /**
     * Полная загрузка каталога.
     */
    public void bootstrapCatalog() throws IOException {
        self.syncClasspathToDatabase();
        self.reloadCatalogFromDatabase();
        self.applyClasspathIdActsFallback();
    }

    /**
     * Сканирует все {@code .xsd} под {@code validation-files} на classpath (полный обход дерева) и upsert в {@code xsd_definitions}.
     */
    @Transactional
    public void syncClasspathToDatabase() throws IOException {
        PathMatchingResourcePatternResolver resolver = new PathMatchingResourcePatternResolver();
        Resource[] resources = resolver.getResources("classpath*:/validation-files/**/*.xsd");
        log.info("XSD sync: found {} resource(s) matching classpath*:/validation-files/**/*.xsd", resources.length);

        List<XsdDefinitionEntity> newEntities = new ArrayList<>();
        LocalDateTime now = LocalDateTime.now(applicationZoneId);
        int skippedPath = 0;
        int updated = 0;

        for (Resource resource : resources) {
            String classpathPath = toClasspathResourcePath(resource);
            if (classpathPath == null) {
                skippedPath++;
                log.debug("XSD sync: skip resource (path unresolved): {}", safeResourceId(resource));
                continue;
            }

            byte[] bytes;
            try (InputStream is = resource.getInputStream()) {
                bytes = is.readAllBytes();
            }
            String content = new String(bytes, StandardCharsets.UTF_8);

            String namespaceUri = extractTargetNamespace(content);
            String rootElementLocalName = isIdActsEntryNamespace(namespaceUri)
                    ? extractRootElementLocalNameForIdActsEntry(content)
                    : extractRootElementLocalName(content);
            String documentType = extractDocumentTypeFromPath(classpathPath);

            if (namespaceUri == null || namespaceUri.isBlank()) {
                log.warn("XSD sync: no targetNamespace in {}, skipping DB row", classpathPath);
                continue;
            }

            if (log.isDebugEnabled()) {
                log.debug("XSD sync: path={} namespace={} root={} documentType={}",
                        classpathPath, namespaceUri, rootElementLocalName, documentType);
            }

            Optional<XsdDefinitionEntity> existing = xsdDefinitionRepository.findByXsdResourcePath(classpathPath);
            if (existing.isPresent()) {
                XsdDefinitionEntity e = existing.get();
                boolean contentChanged = !Objects.equals(content, e.getXsdContent());
                boolean metaChanged = !Objects.equals(namespaceUri, e.getNamespaceUri())
                        || !Objects.equals(rootElementLocalName, e.getRootElementLocalName())
                        || !Objects.equals(documentType, e.getDocumentType());
                boolean repairMissingRoot = rootElementLocalName != null
                        && (e.getRootElementLocalName() == null || e.getRootElementLocalName().isBlank());
                if (contentChanged || metaChanged || repairMissingRoot) {
                    e.syncFromClasspath(namespaceUri, rootElementLocalName, documentType, content, now);
                    xsdDefinitionRepository.save(e);
                    updated++;
                }
                continue;
            }

            newEntities.add(new XsdDefinitionEntity(
                    namespaceUri,
                    rootElementLocalName,
                    documentType,
                    classpathPath,
                    content,
                    now
            ));
        }

        if (!newEntities.isEmpty()) {
            xsdDefinitionRepository.saveAll(newEntities);
        }

        log.info("XSD sync: skipped (unresolved path)={}, updated existing={}, inserted new={}, total scanned={}",
                skippedPath, updated, newEntities.size(), resources.length);
    }

    /**
     * Перечитывает {@code xsd_definitions} в кэш namespace/filename и маппинг корневых QNames.
     */
    @Transactional(readOnly = true)
    public void reloadCatalogFromDatabase() {
        mappingByQName.clear();
        xsdContentByNamespace.clear();
        xsdContentByFilename.clear();
        xsdContentByResourcePath.clear();
        schemaCache.clear();

        List<XsdDefinitionEntity> all = xsdDefinitionRepository.findAll();
        int mappingCount = 0;
        for (XsdDefinitionEntity e : all) {
            if (e.getNamespaceUri() != null && !e.getNamespaceUri().isBlank() && e.getXsdContent() != null) {
                xsdContentByNamespace.putIfAbsent(e.getNamespaceUri(), e.getXsdContent());
            }
            if (e.getXsdResourcePath() != null && e.getXsdContent() != null) {
                String filename = e.getXsdResourcePath().substring(e.getXsdResourcePath().lastIndexOf('/') + 1);
                xsdContentByFilename.putIfAbsent(filename, e.getXsdContent());
                xsdContentByResourcePath.put(e.getXsdResourcePath(), e.getXsdContent());
            }

            if (e.getRootElementLocalName() != null && e.getNamespaceUri() != null
                    && e.getDocumentType() != null && !e.getDocumentType().isBlank()) {
                String key = qNameKey(e.getNamespaceUri(), e.getRootElementLocalName());
                mappingByQName.putIfAbsent(key, new DocumentTypeMapping(
                        e.getDocumentType(),
                        e.getNamespaceUri(),
                        e.getRootElementLocalName(),
                        e.getXsdContent(),
                        e.getXsdResourcePath()
                ));
                mappingCount++;
                if (isIdActsEntryNamespace(e.getNamespaceUri())) {
                    log.info("Adding mapping: {} -> {}", key, e.getDocumentType());
                } else {
                    log.debug("Catalog memory: mapping {} -> {}", key, e.getDocumentType());
                }
            }
        }
        log.info("reloadFromDb: loaded {} xsd_definitions row(s), {} QName mapping(s)", all.size(), mappingCount);
    }

    /**
     * Если после БД не хватает маппингов (пустая БД, старые строки без root), добираем входные схемы
     * {@code http://idActs/…} с classpath без записи в БД.
     */
    public void applyClasspathIdActsFallback() throws IOException {
        int added = 0;
        for (IdActsEntryScan hit : scanIdActsEntrySchemasFromClasspath()) {
            String key = qNameKey(hit.namespaceUri(), hit.rootElementLocalName());
            if (mappingByQName.containsKey(key)) {
                continue;
            }
            xsdContentByFilename.putIfAbsent(hit.filename(), hit.content());
            xsdContentByNamespace.putIfAbsent(hit.namespaceUri(), hit.content());
            xsdContentByResourcePath.putIfAbsent(hit.classpathPath(), hit.content());
            mappingByQName.put(key, new DocumentTypeMapping(
                    hit.documentType(),
                    hit.namespaceUri(),
                    hit.rootElementLocalName(),
                    hit.content(),
                    hit.classpathPath()
            ));
            added++;
            log.info("Classpath fallback: adding mapping {} -> {}", key, hit.documentType());
        }
        log.info("Classpath idActs fallback: added {} mapping(s)", added);
    }

    public DocumentTypeMapping detectDocumentType(XmlMetadataExtractor.RootQName rootQName) {
        String key = qNameKey(rootQName.namespaceUri(), rootQName.localName());
        DocumentTypeMapping mapping = mappingByQName.get(key);
        if (mapping != null) {
            return mapping;
        }
        try {
            mapping = resolveByScanningIdActsSchemas(rootQName);
        } catch (IOException e) {
            throw new IllegalStateException("Ошибка чтения XSD при определении типа документа: " + e.getMessage(), e);
        }
        if (mapping == null) {
            throw new UnknownDocumentTypeException("Не удалось определить тип документа по корню XML: {" +
                    rootQName.namespaceUri() + "}" + rootQName.localName());
        }
        mappingByQName.put(key, mapping);
        return mapping;
    }

    public Schema getSchema(DocumentTypeMapping mapping) {
        return schemaCache.computeIfAbsent(mapping.xsdResourcePath(), rp -> compileSchema(mapping));
    }

    private Schema compileSchema(DocumentTypeMapping mapping) {
        try {
            String rootPath = mapping.xsdResourcePath();
            String content = loadXsdContentForResourcePath(rootPath);
            if (content == null) {
                throw new IllegalStateException("Нет текста XSD для " + rootPath);
            }
            PathMatchingResourcePatternResolver pmr = new PathMatchingResourcePatternResolver();
            Resource rootResource = pmr.getResource("classpath:/" + rootPath);
            if (!rootResource.exists()) {
                throw new IllegalStateException("Ресурс не найден: classpath:/" + rootPath);
            }
            URL rootUrl = rootResource.getURL();

            SchemaFactory factory = SchemaFactory.newInstance(XMLConstants.W3C_XML_SCHEMA_NS_URI);
            factory.setResourceResolver(this::resolveSchemaResource);

            StreamSource rootSource = new StreamSource(new StringReader(content));
            rootSource.setSystemId(rootUrl.toString());
            return factory.newSchema(rootSource);
        } catch (SAXException | IOException e) {
            throw new IllegalStateException("Не удалось собрать XSD schema для типа '" + mapping.documentType() + "': " + e.getMessage(), e);
        }
    }

    /**
     * Резолвер импортов: {@code systemId} разрешается относительно {@code baseURI} (как в спецификации XSD),
     * затем по пути {@code validation-files/…} подгружается тот же текст, что в БД/classpath.
     */
    private LSInput resolveSchemaResource(String type, String namespaceURI, String publicId, String systemId, String baseURI) {
        try {
            if (systemId == null || systemId.isBlank()) {
                return null;
            }
            String sid = systemId.trim();
            if (sid.startsWith("http://www.w3.org") || sid.startsWith("https://www.w3.org")) {
                return resolveLocalW3cXmldsig(publicId, sid, baseURI);
            }

            URI base = (baseURI != null && !baseURI.isBlank()) ? URI.create(baseURI.trim()) : null;
            URI sys = URI.create(encodeUriSpaces(sid));
            URI absolute = sys.isAbsolute() ? sys : (base != null ? base.resolve(sys) : null);
            if (absolute == null) {
                return null;
            }

            String classpathPath = classpathRelativePathFromUri(absolute.toString());
            if (classpathPath == null && base != null) {
                String basePath = classpathRelativePathFromUri(base.toString());
                if (basePath != null) {
                    String dir = basePath.contains("/") ? basePath.substring(0, basePath.lastIndexOf('/') + 1) : "";
                    classpathPath = resolveRelativeImportPath(dir, sid);
                }
            }
            if (classpathPath == null) {
                log.debug("XSD resolver: не удалось сопоставить путь для systemId={} baseURI={}", systemId, baseURI);
                return null;
            }
            String text = loadXsdContentForResourcePath(classpathPath);
            if (text == null) {
                log.warn("XSD resolver: нет контента для {}", classpathPath);
                return null;
            }
            return new StringLSInput(publicId, absolute.toString(), text);
        } catch (Exception e) {
            log.warn("XSD resolver: {}", e.getMessage());
            return null;
        }
    }

    private LSInput resolveLocalW3cXmldsig(String publicId, String systemId, String baseURI) throws IOException {
        if (baseURI == null || baseURI.isBlank()) {
            return null;
        }
        String basePath = classpathRelativePathFromUri(baseURI.trim());
        if (basePath == null) {
            return null;
        }
        String dir = basePath.contains("/") ? basePath.substring(0, basePath.lastIndexOf('/') + 1) : "";
        for (String name : new String[]{"Xmldsig.xsd", "xmldsig.xsd"}) {
            String p = dir + name;
            String text = loadXsdContentForResourcePath(p);
            if (text != null) {
                return new StringLSInput(publicId, systemId, text);
            }
        }
        return null;
    }

    private static String encodeUriSpaces(String s) {
        return s.contains(" ") ? s.replace(" ", "%20") : s;
    }

    /**
     * Достаёт путь вида {@code validation-files/…} из {@code file:}, {@code jar:} и т.д.
     */
    static String classpathRelativePathFromUri(String uri) {
        if (uri == null || uri.isBlank()) {
            return null;
        }
        String decoded;
        try {
            decoded = URLDecoder.decode(uri, StandardCharsets.UTF_8);
        } catch (Exception e) {
            decoded = uri;
        }
        decoded = decoded.replace('\\', '/');
        int v = decoded.indexOf("validation-files/");
        if (v >= 0) {
            return decoded.substring(v);
        }
        int classes = decoded.lastIndexOf("/classes/");
        if (classes >= 0) {
            String tail = decoded.substring(classes + "/classes/".length());
            if (tail.startsWith("validation-files/")) {
                return tail;
            }
        }
        int bang = decoded.lastIndexOf("!/");
        if (bang >= 0) {
            String after = decoded.substring(bang + 2);
            int v2 = after.indexOf("validation-files/");
            if (v2 >= 0) {
                return after.substring(v2);
            }
        }
        return null;
    }

    private static String resolveRelativeImportPath(String baseDir, String schemaLocation) {
        if (schemaLocation == null || schemaLocation.isBlank()) {
            return null;
        }
        String s = schemaLocation.trim();
        if (s.startsWith("http://") || s.startsWith("https://")) {
            return null;
        }
        int q = s.indexOf('?');
        if (q >= 0) {
            s = s.substring(0, q);
        }
        Path base = Paths.get(baseDir);
        Path resolved = base.resolve(s).normalize();
        return resolved.toString().replace('\\', '/');
    }

    /**
     * Текст XSD по classpath-пути: кэш в памяти → БД → classpath.
     */
    private String loadXsdContentForResourcePath(String classpathRelativePath) throws IOException {
        String cached = xsdContentByResourcePath.get(classpathRelativePath);
        if (cached != null) {
            return cached;
        }
        Optional<XsdDefinitionEntity> fromDb = xsdDefinitionRepository.findByXsdResourcePath(classpathRelativePath);
        if (fromDb.isPresent() && fromDb.get().getXsdContent() != null) {
            String c = fromDb.get().getXsdContent();
            xsdContentByResourcePath.putIfAbsent(classpathRelativePath, c);
            return c;
        }
        PathMatchingResourcePatternResolver resolver = new PathMatchingResourcePatternResolver();
        Resource resource = resolver.getResource("classpath:/" + classpathRelativePath);
        if (resource.exists()) {
            try (InputStream is = resource.getInputStream()) {
                String c = new String(is.readAllBytes(), StandardCharsets.UTF_8);
                xsdContentByResourcePath.putIfAbsent(classpathRelativePath, c);
                return c;
            }
        }
        return null;
    }

    /**
     * Ищет XSD с {@code targetNamespace} вида {@code http://idActs/…} среди файлов «папка типа документа → xsd» (шаблон в коде метода).
     */
    private DocumentTypeMapping resolveByScanningIdActsSchemas(XmlMetadataExtractor.RootQName rootQName) throws IOException {
        for (IdActsEntryScan hit : scanIdActsEntrySchemasFromClasspath()) {
            if (!Objects.equals(hit.namespaceUri(), rootQName.namespaceUri())
                    || !Objects.equals(hit.rootElementLocalName(), rootQName.localName())) {
                continue;
            }
            xsdContentByFilename.putIfAbsent(hit.filename(), hit.content());
            xsdContentByNamespace.putIfAbsent(hit.namespaceUri(), hit.content());
            xsdContentByResourcePath.putIfAbsent(hit.classpathPath(), hit.content());
            log.debug("resolveByScanning: matched {} for root {}", hit.classpathPath(), rootQName);
            return new DocumentTypeMapping(
                    hit.documentType(),
                    hit.namespaceUri(),
                    hit.rootElementLocalName(),
                    hit.content(),
                    hit.classpathPath());
        }
        log.warn("resolveByScanning: no idActs schema for namespace={} localName={}",
                rootQName.namespaceUri(), rootQName.localName());
        return null;
    }

    private List<IdActsEntryScan> scanIdActsEntrySchemasFromClasspath() throws IOException {
        PathMatchingResourcePatternResolver resolver = new PathMatchingResourcePatternResolver();
        Resource[] resources = resolver.getResources("classpath*:/validation-files/*/*.xsd");
        List<IdActsEntryScan> out = new ArrayList<>();
        for (Resource resource : resources) {
            String path = toClasspathResourcePath(resource);
            if (path == null) {
                log.debug("scanIdActs: skip (path null) {}", safeResourceId(resource));
                continue;
            }
            byte[] bytes;
            try (InputStream is = resource.getInputStream()) {
                bytes = is.readAllBytes();
            }
            String content = new String(bytes, StandardCharsets.UTF_8);
            String ns = extractTargetNamespace(content);
            if (!isIdActsEntryNamespace(ns)) {
                continue;
            }
            String root = extractRootElementLocalNameForIdActsEntry(content);
            if (root == null || ns.isBlank()) {
                log.debug("scanIdActs: skip idActs file without root: {}", path);
                continue;
            }
            String docType = extractDocumentTypeFromPath(path);
            if (docType == null || docType.isBlank()) {
                continue;
            }
            String filename = path.substring(path.lastIndexOf('/') + 1);
            out.add(new IdActsEntryScan(path, filename, content, ns, root, docType));
        }
        log.debug("scanIdActs: {} candidate(s) from classpath*:/validation-files/*/*.xsd", out.size());
        return out;
    }

    private static String safeResourceId(Resource resource) {
        try {
            return resource.getURI() != null ? resource.getURI().toString() : String.valueOf(resource);
        } catch (IOException e) {
            return String.valueOf(resource);
        }
    }

    /**
     * Извлекает {@code validation-files/...} из URI ресурса (IDE, fat JAR, Spring Boot nested JAR).
     */
    static String toClasspathResourcePath(Resource resource) throws IOException {
        String uri = resource.getURI().toString();
        String decoded;
        try {
            decoded = URLDecoder.decode(uri, StandardCharsets.UTF_8);
        } catch (Exception e) {
            decoded = uri;
        }
        decoded = decoded.replace('\\', '/');

        int v = decoded.indexOf("validation-files/");
        if (v >= 0) {
            return decoded.substring(v);
        }

        // file:/.../build/classes/java/main/validation-files/... или target/classes/
        int classes = decoded.lastIndexOf("/classes/");
        if (classes >= 0) {
            String tail = decoded.substring(classes + "/classes/".length());
            if (tail.startsWith("validation-files/")) {
                return tail;
            }
        }

        // jar:file:...!/... — иногда validation-files без nested префикса в хвосте
        int bang = decoded.lastIndexOf("!/");
        if (bang >= 0) {
            String afterBang = decoded.substring(bang + 2);
            int v2 = afterBang.indexOf("validation-files/");
            if (v2 >= 0) {
                return afterBang.substring(v2);
            }
        }

        log.warn("toClasspathResourcePath: could not derive validation-files path from: {}", decoded);
        return null;
    }

    private static String extractTargetNamespace(String xsdContent) {
        Matcher m = Pattern.compile("targetNamespace\\s*=\\s*\"([^\"]+)\"").matcher(xsdContent);
        return m.find() ? m.group(1) : null;
    }

    /** Первое объявление корня {@code type="cf:…"} (как в исходной логике). */
    private static String extractRootElementLocalName(String xsdContent) {
        Matcher m = XS_ELEMENT_OPEN_TAG.matcher(xsdContent);
        while (m.find()) {
            String attrs = m.group(1);
            if (!containsCfType(attrs)) {
                continue;
            }
            String name = extractAttribute(attrs, "name");
            if (name != null && !name.isBlank()) {
                return name;
            }
        }
        return null;
    }

    /** Входные акты Минстроя: {@code targetNamespace} вида {@code http://idActs/Имя.xsd}. */
    private static boolean isIdActsEntryNamespace(String namespaceUri) {
        return namespaceUri != null && namespaceUri.startsWith("http://idActs/");
    }

    /**
     * Глобальный корень объявлен в конце файла; среди {@code <xs:element … type="cf:…"/>} берём последнее,
     * порядок атрибутов {@code name} и {@code type} любой.
     */
    private static String extractRootElementLocalNameForIdActsEntry(String xsdContent) {
        return findLastCfRootElementName(xsdContent);
    }

    /**
     * Ищет самозакрывающиеся {@code xs:element} с {@code type="cf:…"}; возвращает последний {@code name}.
     */
    private static String findLastCfRootElementName(String xsdContent) {
        Matcher m = XS_ELEMENT_OPEN_TAG.matcher(xsdContent);
        String last = null;
        while (m.find()) {
            String attrs = m.group(1);
            if (!containsCfType(attrs)) {
                continue;
            }
            String name = extractAttribute(attrs, "name");
            if (name != null && !name.isBlank()) {
                last = name;
            }
        }
        return last;
    }

    private static boolean containsCfType(String attrsFragment) {
        Matcher tm = Pattern.compile("type\\s*=\\s*\"(cf:[^\"]+)\"").matcher(attrsFragment);
        return tm.find();
    }

    private static String extractAttribute(String attrsFragment, String attrName) {
        Matcher m = Pattern.compile("\\b" + Pattern.quote(attrName) + "\\s*=\\s*\"([^\"]*)\"").matcher(attrsFragment);
        return m.find() ? m.group(1) : null;
    }

    private static String extractDocumentTypeFromPath(String classpathPath) {
        if (classpathPath == null) {
            return null;
        }
        if (!classpathPath.startsWith("validation-files/")) {
            return null;
        }
        String rest = classpathPath.substring("validation-files/".length());
        String docType = rest.split("/", 2)[0];
        return docType != null && !docType.isBlank() ? docType : null;
    }

    private static String qNameKey(String namespaceUri, String localName) {
        return (namespaceUri == null ? "" : namespaceUri) + "|" + (localName == null ? "" : localName);
    }

    private record IdActsEntryScan(
            String classpathPath,
            String filename,
            String content,
            String namespaceUri,
            String rootElementLocalName,
            String documentType
    ) {
    }

    public record DocumentTypeMapping(
            String documentType,
            String namespaceUri,
            String rootElementLocalName,
            String xsdContent,
            String xsdResourcePath
    ) {
    }

    private static final class StringLSInput implements LSInput {
        private final String publicId;
        private final String systemId;
        private final String content;
        private String baseURI;

        StringLSInput(String publicId, String systemId, String content) {
            this.publicId = publicId;
            this.systemId = systemId;
            this.content = content;
        }

        public Reader getCharacterStream() {
            return new StringReader(content);
        }

        public void setCharacterStream(Reader characterStream) {
            throw new UnsupportedOperationException();
        }

        public InputStream getByteStream() {
            return new ByteArrayInputStream(content.getBytes(StandardCharsets.UTF_8));
        }

        public void setByteStream(InputStream byteStream) {
            throw new UnsupportedOperationException();
        }

        public String getStringData() {
            return content;
        }

        public void setStringData(String stringData) {
            throw new UnsupportedOperationException();
        }

        public String getSystemId() {
            return systemId;
        }

        public void setSystemId(String systemId) {
            throw new UnsupportedOperationException();
        }

        public String getPublicId() {
            return publicId;
        }

        public void setPublicId(String publicId) {
            throw new UnsupportedOperationException();
        }

        public String getBaseURI() {
            return baseURI;
        }

        public void setBaseURI(String baseURI) {
            this.baseURI = baseURI;
        }

        public String getEncoding() {
            return null;
        }

        public void setEncoding(String encoding) {
            throw new UnsupportedOperationException();
        }

        public boolean getCertifiedText() {
            return false;
        }

        public void setCertifiedText(boolean certifiedText) {
            throw new UnsupportedOperationException();
        }
    }

    public static class UnknownDocumentTypeException extends RuntimeException {
        public UnknownDocumentTypeException(String message) {
            super(message);
        }
    }
}
