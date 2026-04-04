package ru.artwell.contractor.service;

import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.core.io.Resource;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ru.artwell.contractor.config.AppTimeConfiguration;
import ru.artwell.contractor.persistence.entity.XsdDefinitionEntity;
import ru.artwell.contractor.persistence.repository.XsdDefinitionRepository;
import org.w3c.dom.ls.LSInput;
import org.w3c.dom.ls.LSResourceResolver;
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
import java.nio.charset.StandardCharsets;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Service
public class XsdCatalogService {

    private final ZoneId applicationZoneId;
    private final XsdDefinitionRepository xsdDefinitionRepository;
    private final Map<String, DocumentTypeMapping> mappingByQName = new ConcurrentHashMap<>();
    private final Map<String, String> xsdContentByNamespace = new ConcurrentHashMap<>();
    private final Map<String, String> xsdContentByFilename = new ConcurrentHashMap<>();
    private final Map<String, Schema> schemaCache = new ConcurrentHashMap<>();

    public XsdCatalogService(XsdDefinitionRepository xsdDefinitionRepository,
                             @Qualifier(AppTimeConfiguration.APPLICATION_ZONE_ID) ZoneId applicationZoneId) {
        this.xsdDefinitionRepository = xsdDefinitionRepository;
        this.applicationZoneId = applicationZoneId;
    }

    /**
     * Вызывается из {@link ru.artwell.contractor.config.XsdCatalogBootstrap} (раньше {@code @PostConstruct}),
     * чтобы транзакция Spring точно применялась и данные попадали в БД до обработки HTTP-запросов.
     */
    @Transactional
    public void bootstrapCatalog() throws IOException {
        syncXsdDefinitionsFromClasspath();
        reloadFromDbIntoMemory();
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

    /**
     * Если в БД/памяти нет записи (например, устаревшая {@code xsd_definitions}), ищем среди
     * {@code validation-files/**/idActs/*.xsd} на classpath файл с тем же targetNamespace и корневым элементом.
     */
    private DocumentTypeMapping resolveByScanningIdActsSchemas(XmlMetadataExtractor.RootQName rootQName) throws IOException {
        PathMatchingResourcePatternResolver resolver = new PathMatchingResourcePatternResolver();
        Resource[] resources = resolver.getResources("classpath*:/validation-files/**/idActs/*.xsd");
        for (Resource resource : resources) {
            String path = toClasspathResourcePath(resource);
            if (path == null) {
                continue;
            }
            byte[] bytes;
            try (InputStream is = resource.getInputStream()) {
                bytes = is.readAllBytes();
            }
            String content = new String(bytes, StandardCharsets.UTF_8);
            String ns = extractTargetNamespace(content);
            String root = extractRootElementLocalNameForIdActsEntry(content);
            if (root == null || ns == null || ns.isBlank()) {
                continue;
            }
            if (!Objects.equals(ns, rootQName.namespaceUri()) || !Objects.equals(root, rootQName.localName())) {
                continue;
            }
            String docType = extractDocumentTypeFromPath(path);
            if (docType == null || docType.isBlank()) {
                continue;
            }
            String filename = path.substring(path.lastIndexOf('/') + 1);
            xsdContentByFilename.putIfAbsent(filename, content);
            xsdContentByNamespace.putIfAbsent(ns, content);
            return new DocumentTypeMapping(docType, ns, root, content, path);
        }
        return null;
    }

    public Schema getSchema(DocumentTypeMapping mapping) {
        return schemaCache.computeIfAbsent(mapping.xsdResourcePath(), rp -> compileSchema(mapping));
    }

    private Schema compileSchema(DocumentTypeMapping mapping) {
        try {
            SchemaFactory factory = SchemaFactory.newInstance(XMLConstants.W3C_XML_SCHEMA_NS_URI);
            factory.setResourceResolver(new NamespaceAwareResourceResolver(xsdContentByNamespace, xsdContentByFilename));

            StreamSource source = new StreamSource(new StringReader(mapping.xsdContent()));
            source.setSystemId("classpath:/" + mapping.xsdResourcePath());
            return factory.newSchema(source);
        } catch (SAXException e) {
            throw new IllegalStateException("Не удалось собрать XSD schema для типа '" + mapping.documentType() + "': " + e.getMessage(), e);
        }
    }

    private void reloadFromDbIntoMemory() {
        mappingByQName.clear();
        xsdContentByNamespace.clear();
        xsdContentByFilename.clear();
        schemaCache.clear();

        List<XsdDefinitionEntity> all = xsdDefinitionRepository.findAll();
        for (XsdDefinitionEntity e : all) {
            if (e.getNamespaceUri() != null && !e.getNamespaceUri().isBlank() && e.getXsdContent() != null) {
                xsdContentByNamespace.putIfAbsent(e.getNamespaceUri(), e.getXsdContent());
            }
            if (e.getXsdResourcePath() != null) {
                String filename = e.getXsdResourcePath().substring(e.getXsdResourcePath().lastIndexOf('/') + 1);
                xsdContentByFilename.putIfAbsent(filename, e.getXsdContent());
            }

            if (e.getRootElementLocalName() != null && e.getNamespaceUri() != null) {
                // Only xsd that define a root element are usable for type detection
                if (e.getDocumentType() != null && !e.getDocumentType().isBlank()) {
                    String key = qNameKey(e.getNamespaceUri(), e.getRootElementLocalName());
                    mappingByQName.putIfAbsent(key, new DocumentTypeMapping(
                            e.getDocumentType(),
                            e.getNamespaceUri(),
                            e.getRootElementLocalName(),
                            e.getXsdContent(),
                            e.getXsdResourcePath()
                    ));
                }
            }
        }
    }

    private void syncXsdDefinitionsFromClasspath() throws IOException {
        PathMatchingResourcePatternResolver resolver = new PathMatchingResourcePatternResolver();
        Resource[] resources = resolver.getResources("classpath*:/validation-files/**/*.xsd");

        List<XsdDefinitionEntity> newEntities = new ArrayList<>();
        LocalDateTime now = LocalDateTime.now(applicationZoneId);

        for (Resource resource : resources) {
            String classpathPath = toClasspathResourcePath(resource);
            if (classpathPath == null) {
                continue;
            }

            byte[] bytes;
            try (InputStream is = resource.getInputStream()) {
                bytes = is.readAllBytes();
            }
            String content = new String(bytes, StandardCharsets.UTF_8);

            String namespaceUri = extractTargetNamespace(content);
            String rootElementLocalName = isIdActsEntryPath(classpathPath)
                    ? extractRootElementLocalNameForIdActsEntry(content)
                    : extractRootElementLocalName(content);
            String documentType = extractDocumentTypeFromPath(classpathPath);

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
    }

    private static String toClasspathResourcePath(Resource resource) throws IOException {
        // Example in jar: jar:file:/.../app.jar!/validation-files/AOGROOKS/idActs/AOGROOKS.xsd
        String uri = resource.getURI().toString();
        int idx = uri.indexOf("!/");
        String pathPart = idx >= 0 ? uri.substring(idx + 2) : uri;
        if (pathPart.startsWith("/")) {
            pathPart = pathPart.substring(1);
        }
        if (!pathPart.startsWith("validation-files/")) {
            return null;
        }
        return pathPart;
    }

    private static String extractTargetNamespace(String xsdContent) {
        Matcher m = Pattern.compile("targetNamespace\\s*=\\s*\"([^\"]+)\"").matcher(xsdContent);
        return m.find() ? m.group(1) : null;
    }

    private static String extractRootElementLocalName(String xsdContent) {
        // Most of our schemas define root element as: <xs:element name="xyz" type="cf:xyz" />
        Matcher m = Pattern.compile("<xs:element[^>]*name\\s*=\\s*\"([^\"]+)\"[^>]*type\\s*=\\s*\"cf:").matcher(xsdContent);
        return m.find() ? m.group(1) : null;
    }

    private static boolean isIdActsEntryPath(String classpathPath) {
        if (classpathPath == null) {
            return false;
        }
        return classpathPath.replace('\\', '/').contains("/idActs/");
    }

    /**
     * Для входных схем в {@code idActs} глобальный корень обычно объявлен в конце файла; берём последнее совпадение.
     */
    private static String extractRootElementLocalNameForIdActsEntry(String xsdContent) {
        Pattern p = Pattern.compile("<xs:element[^>]*name\\s*=\\s*\"([^\"]+)\"[^>]*type\\s*=\\s*\"cf:");
        Matcher m = p.matcher(xsdContent);
        String last = null;
        while (m.find()) {
            last = m.group(1);
        }
        return last;
    }

    private static String extractDocumentTypeFromPath(String classpathPath) {
        // validation-files/<docType>/...
        if (classpathPath == null) return null;
        if (!classpathPath.startsWith("validation-files/")) return null;
        String rest = classpathPath.substring("validation-files/".length());
        String docType = rest.split("/", 2)[0];
        return docType != null && !docType.isBlank() ? docType : null;
    }

    private static String qNameKey(String namespaceUri, String localName) {
        return (namespaceUri == null ? "" : namespaceUri) + "|" + (localName == null ? "" : localName);
    }

    public record DocumentTypeMapping(
            String documentType,
            String namespaceUri,
            String rootElementLocalName,
            String xsdContent,
            String xsdResourcePath
    ) {
    }

    public static class UnknownDocumentTypeException extends RuntimeException {
        public UnknownDocumentTypeException(String message) {
            super(message);
        }
    }

    private static class NamespaceAwareResourceResolver implements LSResourceResolver {
        private final Map<String, String> contentByNamespace;
        private final Map<String, String> contentByFilename;

        NamespaceAwareResourceResolver(Map<String, String> contentByNamespace, Map<String, String> contentByFilename) {
            this.contentByNamespace = contentByNamespace;
            this.contentByFilename = contentByFilename;
        }

        
        public LSInput resolveResource(String type, String namespaceURI, String publicId, String systemId, String baseURI) {
            String content = null;

            if (namespaceURI != null) {
                content = contentByNamespace.get(namespaceURI);
            }

            if (content == null && systemId != null) {
                // systemId may be like "../types/CommonTypes.xsd"
                String filename = systemId.substring(systemId.lastIndexOf('/') + 1);
                content = contentByFilename.get(filename);
            }

            if (content == null) {
                return null;
            }

            return new StringLSInput(publicId, systemId, content);
        }
    }

    private static class StringLSInput implements LSInput {
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
}

