package ru.artwell.contractor.service;

import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ru.artwell.contractor.config.AppTimeConfiguration;
import ru.artwell.contractor.config.ReferenceDataInitializer;
import ru.artwell.contractor.dto.AuditLogDto;
import ru.artwell.contractor.dto.ConstructionObjectAddressDto;
import ru.artwell.contractor.dto.DocumentCardResponse;
import ru.artwell.contractor.dto.DocumentFilter;
import ru.artwell.contractor.dto.DocumentResponse;
import ru.artwell.contractor.dto.ParticipantDto;
import ru.artwell.contractor.dto.ParticipantInfo;
import ru.artwell.contractor.dto.UploadDocumentResponse;
import ru.artwell.contractor.dto.XmlDownload;
import ru.artwell.contractor.dto.ValidationErrorDto;
import ru.artwell.contractor.dto.VersionInfo;
import ru.artwell.contractor.dto.WorkVolumeDto;
import ru.artwell.contractor.dto.WorkVolumeInfo;
import ru.artwell.contractor.mapper.AuditLogMapper;
import ru.artwell.contractor.mapper.DocumentCardAssembler;
import ru.artwell.contractor.mapper.DocumentListItemMapper;
import ru.artwell.contractor.mapper.ParticipantMapper;
import ru.artwell.contractor.mapper.UploadDocumentMapper;
import ru.artwell.contractor.mapper.VersionInfoMapper;
import ru.artwell.contractor.mapper.WorkVolumeMapper;
import ru.artwell.contractor.persistence.entity.*;
import ru.artwell.contractor.persistence.repository.*;
import ru.artwell.contractor.persistence.spec.DocumentSpecifications;

import jakarta.servlet.http.HttpServletRequest;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import org.w3c.dom.Document;
import javax.xml.validation.Schema;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;

@Service
public class DocumentService {
    private static final String FALLBACK_DOC_TYPE = "UNKNOWN";

    private static final List<String> PARTICIPANT_ROLE_ORDER = List.of(
            ParticipantDto.ROLE_DEVELOPER,
            ParticipantDto.ROLE_BUILDING_CONTRACTOR,
            ParticipantDto.ROLE_PROJECT_DOCUMENTATION_CONTRACTOR,
            ParticipantDto.ROLE_TECHNICAL_CUSTOMER
    );

    private static final String DOCUMENT_ABSENT_MSG = "Документ с id %d отсутствует.";
    private static final String VERSION_ABSENT_MSG = "Версия с id %d не найдена.";
    private static final String VERSION_ABSENT_FOR_DOCUMENT_MSG =
            "У документа с id %d не найдено версии с id %d.";
    private static final String DOCUMENT_HAS_NO_VERSIONS_MSG =
            "Для документа с id %d не найдено ни одной версии.";

    private final ZoneId applicationZoneId;
    private final XmlMetadataExtractor xmlMetadataExtractor;
    private final XsdCatalogService xsdCatalogService;
    private final XmlValidator xmlValidator;
    private final ConstructionObjectRepository constructionObjectRepository;
    private final DocumentTypeRepository documentTypeRepository;
    private final DocumentRepository documentRepository;
    private final DocumentVersionRepository documentVersionRepository;
    private final AuditLogRepository auditLogRepository;
    private final DocumentParticipantRepository documentParticipantRepository;
    private final PermissionService permissionService;
    private final WorkVolumeRepository workVolumeRepository;
    private final ParticipantPersister participantPersister;
    private final DocumentListItemMapper documentListItemMapper;
    private final DocumentCardAssembler documentCardAssembler;
    private final ParticipantMapper participantMapper;
    private final VersionInfoMapper versionInfoMapper;
    private final WorkVolumeMapper workVolumeMapper;
    private final UploadDocumentMapper uploadDocumentMapper;
    private final AuditLogMapper auditLogMapper;

    public DocumentService(@Qualifier(AppTimeConfiguration.APPLICATION_ZONE_ID) ZoneId applicationZoneId,
                           XmlMetadataExtractor xmlMetadataExtractor,
                           XsdCatalogService xsdCatalogService,
                           XmlValidator xmlValidator,
                           ConstructionObjectRepository constructionObjectRepository,
                           DocumentTypeRepository documentTypeRepository,
                           DocumentRepository documentRepository,
                           DocumentVersionRepository documentVersionRepository,
                           AuditLogRepository auditLogRepository,
                           DocumentParticipantRepository documentParticipantRepository,
                           PermissionService permissionService,
                           WorkVolumeRepository workVolumeRepository,
                           ParticipantPersister participantPersister,
                           DocumentListItemMapper documentListItemMapper,
                           DocumentCardAssembler documentCardAssembler,
                           ParticipantMapper participantMapper,
                           VersionInfoMapper versionInfoMapper,
                           WorkVolumeMapper workVolumeMapper,
                           UploadDocumentMapper uploadDocumentMapper,
                           AuditLogMapper auditLogMapper) {
        this.applicationZoneId = applicationZoneId;
        this.xmlMetadataExtractor = xmlMetadataExtractor;
        this.xsdCatalogService = xsdCatalogService;
        this.xmlValidator = xmlValidator;
        this.constructionObjectRepository = constructionObjectRepository;
        this.documentTypeRepository = documentTypeRepository;
        this.documentRepository = documentRepository;
        this.documentVersionRepository = documentVersionRepository;
        this.auditLogRepository = auditLogRepository;
        this.documentParticipantRepository = documentParticipantRepository;
        this.permissionService = permissionService;
        this.workVolumeRepository = workVolumeRepository;
        this.participantPersister = participantPersister;
        this.documentListItemMapper = documentListItemMapper;
        this.documentCardAssembler = documentCardAssembler;
        this.participantMapper = participantMapper;
        this.versionInfoMapper = versionInfoMapper;
        this.workVolumeMapper = workVolumeMapper;
        this.uploadDocumentMapper = uploadDocumentMapper;
        this.auditLogMapper = auditLogMapper;
    }

    @Transactional
    public UploadDocumentResponse uploadXml(byte[] xmlBytes, String originalFileName, UserEntity uploader) {
        LocalDateTime now = LocalDateTime.now(applicationZoneId);
        String xml = new String(xmlBytes, StandardCharsets.UTF_8);
        String fileLabel = (originalFileName == null || originalFileName.isBlank()) ? "document.xml" : originalFileName.trim();

        String docTypeCode = FALLBACK_DOC_TYPE;
        String businessNumber = "UNKNOWN-" + sha256Prefix(xmlBytes);
        DocumentValidationStatus apiStatus;
        List<ValidationErrorDto> responseErrors;
        String storedErrors = null;
        Optional<LocalDate> documentDate = Optional.empty();

        Document doc;
        try {
            doc = xmlMetadataExtractor.parseXml(xml);
        } catch (IllegalArgumentException e) {
            apiStatus = DocumentValidationStatus.INVALID_XML;
            storedErrors = e.getMessage();
            responseErrors = List.of(new ValidationErrorDto(e.getMessage(), null, null));
            return saveUploaded(now, xmlBytes, fileLabel, docTypeCode, businessNumber, documentDate, apiStatus, storedErrors, responseErrors, null, uploader);
        }

        XmlMetadataExtractor.RootQName rootQName = xmlMetadataExtractor.extractRootQName(doc);
        try {
            xmlMetadataExtractor.assertBusinessDocumentRoot(rootQName);
        } catch (IllegalArgumentException e) {
            apiStatus = DocumentValidationStatus.INVALID_DOCUMENT_ROOT;
            storedErrors = e.getMessage();
            responseErrors = List.of(new ValidationErrorDto(e.getMessage(), null, null));
            return saveUploaded(now, xmlBytes, fileLabel, docTypeCode, businessNumber, documentDate, apiStatus, storedErrors, responseErrors, doc, uploader);
        }

        XsdCatalogService.DocumentTypeMapping mapping;
        try {
            mapping = xsdCatalogService.detectDocumentType(rootQName);
        } catch (XsdCatalogService.UnknownDocumentTypeException e) {
            apiStatus = DocumentValidationStatus.INVALID_UNKNOWN_DOCUMENT_TYPE;
            storedErrors = e.getMessage();
            responseErrors = List.of(new ValidationErrorDto(e.getMessage(), null, null));
            return saveUploaded(now, xmlBytes, fileLabel, docTypeCode, businessNumber, documentDate, apiStatus, storedErrors, responseErrors, doc, uploader);
        }

        docTypeCode = mapping.documentType();

        try {
            businessNumber = xmlMetadataExtractor.extractDocumentNumber(doc);
        } catch (IllegalArgumentException e) {
            businessNumber = "UNKNOWN-" + sha256Prefix(xmlBytes);
        }

        documentDate = xmlMetadataExtractor.extractDocumentDate(doc);

        Schema schema;
        try {
            schema = xsdCatalogService.getSchema(mapping);
        } catch (IllegalStateException e) {
            apiStatus = DocumentValidationStatus.INVALID_SCHEMA;
            storedErrors = "Ошибка компиляции XSD-схемы: " + e.getMessage();
            responseErrors = List.of(new ValidationErrorDto(storedErrors, null, null));
            return saveUploaded(now, xmlBytes, fileLabel, docTypeCode, businessNumber, documentDate, apiStatus, storedErrors, responseErrors, doc, uploader);
        }
        List<XmlValidator.ValidationError> errors = xmlValidator.validateXml(xml, schema);
        boolean valid = errors.isEmpty();
        if (valid) {
            apiStatus = DocumentValidationStatus.VALID;
            responseErrors = Collections.emptyList();
        } else {
            apiStatus = DocumentValidationStatus.INVALID_SCHEMA;
            responseErrors = errors.stream()
                    .map(e -> new ValidationErrorDto(e.message(), e.lineNumber(), e.columnNumber()))
                    .toList();
            storedErrors = errorsToText(errors);
        }

        return saveUploaded(now, xmlBytes, fileLabel, docTypeCode, businessNumber, documentDate, apiStatus, storedErrors, responseErrors, doc, uploader);
    }

    private UploadDocumentResponse saveUploaded(
            LocalDateTime now,
            byte[] xmlBytes,
            String originalFileName,
            String docTypeCode,
            String businessDocumentNumber,
            Optional<LocalDate> documentDate,
            DocumentValidationStatus apiStatus,
            String storedErrors,
            List<ValidationErrorDto> responseErrors,
            Document doc,
            UserEntity actor
    ) {
        checkUploadPermission(actor, docTypeCode);
        ConstructionObjectEntity object = resolveConstructionObject(doc);
        DocumentTypeEntity docType = documentTypeRepository.findByTypeCode(docTypeCode)
                .orElseThrow(UnrecognizedDocumentTypeException::new);

        DocumentEntity document = documentRepository
                .findByDocumentType_TypeCodeAndDocumentNumber(docTypeCode, businessDocumentNumber)
                .orElse(null);

        if (document != null && isDocumentOwnedByAnotherContractor(document, actor)) {
            throw new ConflictException(
                    "Документ с номером «" + businessDocumentNumber + "» уже был загружен другим подрядчиком.");
        }

        DocumentVersionEntity previousVersion = null;
        int nextVersion;
        if (document == null) {
            nextVersion = 1;
            document = documentRepository.save(new DocumentEntity(
                    businessDocumentNumber,
                    documentDate.orElse(null),
                    docType,
                    object,
                    buildTitle(originalFileName, businessDocumentNumber),
                    1,
                    true,
                    actor,
                    now,
                    "active"
            ));
        } else {
            try {
                ensureCanView(actor, document);
            } catch (AccessDeniedException e) {
                String msg = "Документ № " + businessDocumentNumber + " уже загружен другим пользователем.";
                return new UploadDocumentResponse(null, document.getId(),
                        document.getDocumentType().getTypeCode(),
                        document.getDocumentType().getTypeName(),
                        document.getDocumentNumber(), 0, now, false,
                        DocumentValidationStatus.INVALID_CONFLICT,
                        List.of(new ValidationErrorDto(msg, null, null)));
            }
            document.setConstructionObject(object);
            previousVersion = documentVersionRepository
                    .findTopByDocument_IdOrderByVersionNumberDesc(document.getId())
                    .orElseThrow();
            nextVersion = previousVersion.getVersionNumber() + 1;
        }

        DocumentVersionEntity version = new DocumentVersionEntity(
                document,
                nextVersion,
                xmlBytes,
                originalFileName,
                xmlBytes.length,
                toVersionValidationStatus(apiStatus),
                storedErrors,
                actor,
                now,
                previousVersion
        );
        DocumentVersionEntity savedVersion = documentVersionRepository.save(version);

        document.setCurrentVersion(nextVersion);
        document.setUploadedAt(now);
        document.setUploadedBy(actor);
        documentDate.ifPresent(document::setDocumentDate);
        documentRepository.save(document);

        participantPersister.persistParticipants(doc, savedVersion);
        persistWorkVolumes(doc, savedVersion);

        audit(actor, "UPLOAD", "VERSION", savedVersion.getId(), "Uploaded XML. apiStatus=" + apiStatus);

        boolean valid = apiStatus == DocumentValidationStatus.VALID;
        return uploadDocumentMapper.toUploadResponse(savedVersion, document, valid, apiStatus, responseErrors);
    }

    @Transactional
    public UploadDocumentResponse replaceXml(Long id, byte[] xmlBytes, String originalFileName, UserEntity uploader) {
        LocalDateTime now = LocalDateTime.now(applicationZoneId);
        String fileLabel = (originalFileName == null || originalFileName.isBlank()) ? "document.xml" : originalFileName.trim();

        DocumentVersionEntity existing = documentVersionRepository.findById(id)
                .orElseThrow(() -> new NotFoundException(String.format(VERSION_ABSENT_MSG, id)));

        DocumentEntity doc = existing.getDocument();
        ensureCanView(uploader, doc);
        checkUploadPermission(uploader, doc.getDocumentType().getTypeCode());

        DocumentVersionEntity latest = documentVersionRepository.findTopByDocument_IdOrderByVersionNumberDesc(doc.getId())
                .orElseThrow();

        int nextVersion = latest.getVersionNumber() + 1;
        UserEntity actor = uploader;

        DocumentValidationStatus apiStatus;
        String storedErrors = null;
        List<ValidationErrorDto> responseErrors = Collections.emptyList();
        Optional<LocalDate> documentDate = Optional.empty();

        String xml = new String(xmlBytes, StandardCharsets.UTF_8);
        Document xmlDoc = null;
        try {
            xmlDoc = xmlMetadataExtractor.parseXml(xml);
        } catch (IllegalArgumentException ignored) {
        }

        try {
            if (xmlDoc == null) throw new IllegalArgumentException("XML не удалось распарсить");
            XmlMetadataExtractor.RootQName rootQName = xmlMetadataExtractor.extractRootQName(xmlDoc);
            xmlMetadataExtractor.assertBusinessDocumentRoot(rootQName);
            XsdCatalogService.DocumentTypeMapping mapping = xsdCatalogService.detectDocumentType(rootQName);
            String newDocumentNumber = xmlMetadataExtractor.extractDocumentNumber(xmlDoc);
            documentDate = xmlMetadataExtractor.extractDocumentDate(xmlDoc);

            if (!doc.getDocumentType().getTypeCode().equals(mapping.documentType())) {
                String msg = "Нельзя заменить документ типа «" + doc.getDocumentType().getTypeCode()
                        + "» файлом типа «" + mapping.documentType() + "». Загрузите файл того же типа.";
                return new UploadDocumentResponse(null, doc.getId(), doc.getDocumentType().getTypeCode(),
                        doc.getDocumentType().getTypeName(), doc.getDocumentNumber(), latest.getVersionNumber(),
                        now, false, DocumentValidationStatus.INVALID_CONFLICT,
                        List.of(new ValidationErrorDto(msg, null, null)));
            } else if (!doc.getDocumentNumber().equals(newDocumentNumber)) {
                String msg = "Нельзя заменить документ № " + doc.getDocumentNumber()
                        + " файлом с номером № " + newDocumentNumber + ". Номер документа должен совпадать.";
                return new UploadDocumentResponse(null, doc.getId(), doc.getDocumentType().getTypeCode(),
                        doc.getDocumentType().getTypeName(), doc.getDocumentNumber(), latest.getVersionNumber(),
                        now, false, DocumentValidationStatus.INVALID_CONFLICT,
                        List.of(new ValidationErrorDto(msg, null, null)));
            } else {
                Schema schema = xsdCatalogService.getSchema(mapping);
                List<XmlValidator.ValidationError> errors = xmlValidator.validateXml(xml, schema);
                boolean valid = errors.isEmpty();
                if (valid) {
                    apiStatus = DocumentValidationStatus.VALID;
                } else {
                    apiStatus = DocumentValidationStatus.INVALID_SCHEMA;
                    responseErrors = errors.stream()
                            .map(e -> new ValidationErrorDto(e.message(), e.lineNumber(), e.columnNumber()))
                            .toList();
                    storedErrors = errorsToText(errors);
                }
            }
        } catch (XsdCatalogService.UnknownDocumentTypeException e) {
            apiStatus = DocumentValidationStatus.INVALID_UNKNOWN_DOCUMENT_TYPE;
            storedErrors = e.getMessage();
            responseErrors = List.of(new ValidationErrorDto(e.getMessage(), null, null));
        } catch (IllegalArgumentException e) {
            apiStatus = DocumentValidationStatus.INVALID_XML;
            storedErrors = e.getMessage();
            responseErrors = List.of(new ValidationErrorDto(e.getMessage(), null, null));
        }

        DocumentVersionEntity entity = new DocumentVersionEntity(
                doc,
                nextVersion,
                xmlBytes,
                fileLabel,
                xmlBytes.length,
                toVersionValidationStatus(apiStatus),
                storedErrors,
                actor,
                now,
                latest
        );
        DocumentVersionEntity saved = documentVersionRepository.save(entity);

        ConstructionObjectEntity resolvedObject = resolveConstructionObject(xmlDoc);
        doc.setConstructionObject(resolvedObject);
        doc.setCurrentVersion(nextVersion);
        doc.setUploadedAt(now);
        doc.setUploadedBy(actor);
        documentDate.ifPresent(doc::setDocumentDate);
        documentRepository.save(doc);

        participantPersister.persistParticipants(xmlDoc, saved);
        persistWorkVolumes(xmlDoc, saved);

        audit(actor, "REPLACE", "VERSION", saved.getId(), "Replaced XML. apiStatus=" + apiStatus);

        boolean valid = apiStatus == DocumentValidationStatus.VALID;
        return uploadDocumentMapper.toUploadResponse(saved, doc, valid, apiStatus, responseErrors);
    }

    private static String buildTitle(String originalFileName, String businessNumber) {
        return "Документ № " + businessNumber + " (" + originalFileName + ")";
    }

    /**
     * Документ с тем же типом и номером уже есть; изначально загружен пользователем другой организации
     * (подрядчика). Сравнение только если у обоих пользователей задана организация.
     */
    private boolean isDocumentOwnedByAnotherContractor(DocumentEntity document, UserEntity actor) {
        if (actor == null || document == null) {
            return false;
        }
        UserEntity originalUploader = document.getUploadedBy();
        if (originalUploader == null || originalUploader.getId().equals(actor.getId())) {
            return false;
        }
        OrganizationEntity actorOrg = actor.getOrganization();
        OrganizationEntity originalOrg = originalUploader.getOrganization();
        if (actorOrg == null || originalOrg == null) {
            return false;
        }
        return !actorOrg.getId().equals(originalOrg.getId());
    }

    private void checkUploadPermission(UserEntity user, String documentTypeCode) {
        if (!permissionService.canUpload(user, documentTypeCode)) {
            throw new AccessDeniedException("Нет права на загрузку документов типа: " + documentTypeCode);
        }
    }

    private void ensureCanView(UserEntity user, DocumentEntity document) {
        if (!permissionService.canView(user, document)) {
            throw new AccessDeniedException("Нет доступа к документу");
        }
    }

    private ConstructionObjectEntity defaultConstructionObject() {
        return constructionObjectRepository.findByObjectCode(ReferenceDataInitializer.DEFAULT_OBJECT_CODE)
                .orElseThrow(() -> new IllegalStateException("Объект по умолчанию не найден: " + ReferenceDataInitializer.DEFAULT_OBJECT_CODE));
    }

    /**
     * Объект строительства из XML или справочный объект по умолчанию, если в файле нет данных.
     */
    private ConstructionObjectEntity resolveConstructionObject(Document doc) {
        if (doc == null) return defaultConstructionObject();
        try {
            Optional<String> name = xmlMetadataExtractor.extractPermanentObjectName(doc);
            Optional<ConstructionObjectAddressDto> addrStructured =
                    xmlMetadataExtractor.extractPermanentObjectAddressStructured(doc);
            Optional<String> guid = xmlMetadataExtractor.extractPermanentObjectUUID(doc);
            boolean hasAddress = addrStructured.isPresent();
            if (name.isEmpty() && !hasAddress && guid.isEmpty()) {
                return defaultConstructionObject();
            }
            String objectCode = guid.orElseGet(() -> "OBJ-" + UUID.randomUUID());
            Optional<ConstructionObjectEntity> existing = guid.flatMap(constructionObjectRepository::findByPermanentObjectUuid);
            if (existing.isEmpty()) {
                existing = constructionObjectRepository.findByObjectCode(objectCode);
            }
            if (existing.isPresent()) {
                ConstructionObjectEntity e = existing.get();
                name.ifPresent(e::setObjectName);
                guid.ifPresent(e::setPermanentObjectUuid);
                addrStructured.ifPresent(a -> applyStructuredAddress(e, a));
                return constructionObjectRepository.save(e);
            }
            ConstructionObjectEntity created = new ConstructionObjectEntity(
                    objectCode,
                    guid.orElse(null),
                    name.orElse("Объект капитального строительства"),
                    null,
                    null,
                    null,
                    null,
                    null,
                    "active"
            );
            addrStructured.ifPresent(a -> applyStructuredAddress(created, a));
            return constructionObjectRepository.save(created);
        } catch (RuntimeException ex) {
            return defaultConstructionObject();
        }
    }

    private static void applyStructuredAddress(ConstructionObjectEntity e, ConstructionObjectAddressDto a) {
        e.setCountry(blankToNull(a.country()));
        e.setRegion(blankToNull(a.region()));
        e.setDistrict(blankToNull(a.district()));
        e.setLocality(blankToNull(a.locality()));
        e.setStreet(blankToNull(a.street()));
        e.setHouse(blankToNull(a.house()));
        e.setPostalCode(blankToNull(a.postalCode()));
        e.setOktmo(blankToNull(a.oktmo()));
        if (a.fullAddress() != null && !a.fullAddress().isBlank()) {
            e.setAddress(a.fullAddress().trim());
        } else if (a.oktmo() != null && !a.oktmo().isBlank()) {
            e.setAddress(a.oktmo().trim());
        }
    }

    private void persistWorkVolumes(Document doc, DocumentVersionEntity version) {
        if (doc == null) return;
        List<WorkVolumeDto> volumes = xmlMetadataExtractor.extractWorkVolumes(doc);
        for (WorkVolumeDto v : volumes) {
            workVolumeRepository.save(new WorkVolumeEntity(version, v.workType(), v.quantity()));
        }
    }

    private static String blankToNull(String s) {
        if (s == null || s.isBlank()) {
            return null;
        }
        return s.trim();
    }

    private void audit(UserEntity user, String actionType, String entityType, Long entityId, String message) {
        auditLogRepository.save(new AuditLogEntity(
                user,
                user.getUsername(),
                actionType,
                entityType,
                entityId,
                Map.of("message", message),
                getCurrentRequestIp(),
                LocalDateTime.now(applicationZoneId)
        ));
    }

    private static String sha256Prefix(byte[] data) {
        try {
            byte[] digest = MessageDigest.getInstance("SHA-256").digest(data);
            StringBuilder sb = new StringBuilder(16);
            for (int i = 0; i < 8; i++) {
                sb.append(String.format("%02x", digest[i]));
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            return UUID.randomUUID().toString().replace("-", "").substring(0, 16);
        }
    }

    private static String getCurrentRequestIp() {
        try {
            ServletRequestAttributes attrs =
                    (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
            if (attrs == null) return null;
            HttpServletRequest req = attrs.getRequest();
            String forwarded = req.getHeader("X-Forwarded-For");
            String ip = (forwarded != null && !forwarded.isBlank())
                    ? forwarded.split(",")[0].trim()
                    : req.getRemoteAddr();
            if ("0:0:0:0:0:0:0:1".equals(ip) || "::1".equals(ip)) {
                return "127.0.0.1";
            }
            return ip;
        } catch (Exception e) {
            return null;
        }
    }


    private static VersionValidationStatus toVersionValidationStatus(DocumentValidationStatus api) {
        if (api == DocumentValidationStatus.VALID) {
            return VersionValidationStatus.VALID;
        }
        if (api == null) {
            return VersionValidationStatus.ERROR;
        }
        if (api.name().startsWith("INVALID")) {
            return VersionValidationStatus.INVALID;
        }
        return VersionValidationStatus.ERROR;
    }

    private static String errorsToText(List<XmlValidator.ValidationError> errors) {
        if (errors == null || errors.isEmpty()) {
            return null;
        }
        StringBuilder sb = new StringBuilder();
        for (XmlValidator.ValidationError e : errors) {
            if (sb.length() > 0) {
                sb.append('\n');
            }
            sb.append('[')
                    .append(e.lineNumber() == null ? "?" : e.lineNumber())
                    .append(':')
                    .append(e.columnNumber() == null ? "?" : e.columnNumber())
                    .append("] ")
                    .append(e.message());
        }
        return sb.toString();
    }

    @Transactional
    public Page<DocumentResponse> getDocuments(DocumentFilter filter, Pageable pageable, UserEntity currentUser) {
        Specification<DocumentEntity> visibility = permissionService.getVisibilitySpecification(currentUser);

        Specification<DocumentEntity> filters = Specification
                .where(DocumentSpecifications.withListFetches())
                .and(DocumentSpecifications.byDocumentType(filter.documentType()))
                .and(DocumentSpecifications.byDocumentNumberLike(filter.documentNumber()))
                .and(DocumentSpecifications.byConstructionObject(filter.objectId(), filter.objectCode()))
                .and(DocumentSpecifications.byDocumentDateRange(filter.fromDate(), filter.toDate()))
                .and(DocumentSpecifications.byUploadDateRange(filter.uploadedFrom(), filter.uploadedTo()))
                .and(DocumentSpecifications.byStatus(filter.statusOrDefault()))
                .and(DocumentSpecifications.byLatestOnly(filter.latestOnly()));

        if (filter.validationStatus() != null && !filter.validationStatus().isBlank()) {
            filters = filters.and(DocumentSpecifications.byValidationStatusForCurrentVersion(filter.validationStatus()));
        }

        Specification<DocumentEntity> combined = visibility != null ? filters.and(visibility) : filters;

        Page<DocumentEntity> page = documentRepository.findAll(combined, pageable);

        return page.map(doc -> {
            DocumentVersionEntity ver = documentVersionRepository
                    .findByDocument_IdAndVersionNumber(doc.getId(), doc.getCurrentVersion())
                    .orElseThrow(() -> new IllegalStateException(
                            "Нет версии " + doc.getCurrentVersion() + " для документа " + doc.getId()));
            return documentListItemMapper.toDocumentResponse(doc, ver);
        });
    }

    @Transactional
    public DocumentCardResponse getDocumentCard(Long documentId, UserEntity currentUser) {
        DocumentEntity document = documentRepository.findById(documentId)
                .orElseThrow(() -> new NotFoundException(String.format(DOCUMENT_ABSENT_MSG, documentId)));

        ensureCanView(currentUser, document);

        DocumentVersionEntity currentVersion = documentVersionRepository
                .findTopByDocument_IdOrderByVersionNumberDesc(documentId)
                .orElseThrow(() -> new NotFoundException(String.format(DOCUMENT_HAS_NO_VERSIONS_MSG, documentId)));

        List<DocumentParticipantEntity> participantEntities =
                documentParticipantRepository.findByDocumentVersion_Id(currentVersion.getId());
        participantEntities.sort(Comparator.comparingInt(p -> {
            int i = PARTICIPANT_ROLE_ORDER.indexOf(p.getParticipantRole());
            return i < 0 ? Integer.MAX_VALUE : i;
        }));

        List<DocumentVersionEntity> versions =
                documentVersionRepository.findByDocument_IdOrderByVersionNumberDesc(documentId);

        audit(currentUser, "VIEW_DETAIL", "DOCUMENT", documentId, "Viewed document card");

        List<ParticipantInfo> participantInfos = participantEntities.stream()
                .map(participantMapper::toParticipantInfo)
                .toList();

        List<VersionInfo> versionInfos = versions.stream()
                .map(v -> versionInfoMapper.toVersionInfo(v, document.getCurrentVersion(), document.getId()))
                .toList();

        List<WorkVolumeInfo> workVolumeInfos = workVolumeRepository
                .findByDocumentVersion_Id(currentVersion.getId())
                .stream()
                .map(workVolumeMapper::toInfo)
                .toList();

        return documentCardAssembler.toCard(document, currentVersion, participantInfos, versionInfos, workVolumeInfos);
    }

    @Transactional(readOnly = true)
    public List<VersionInfo> listDocumentVersions(Long documentId, UserEntity currentUser) {
        DocumentEntity document = documentRepository.findById(documentId)
                .orElseThrow(() -> new NotFoundException(String.format(DOCUMENT_ABSENT_MSG, documentId)));

        ensureCanView(currentUser, document);

        List<DocumentVersionEntity> versions =
                documentVersionRepository.findByDocument_IdOrderByVersionNumberDesc(documentId);

        return versions.stream()
                .map(v -> versionInfoMapper.toVersionInfo(v, document.getCurrentVersion(), document.getId()))
                .toList();
    }

    @Transactional
    public XmlDownload downloadXml(Long versionId, UserEntity currentUser) {
        DocumentVersionEntity entity = documentVersionRepository.findById(versionId)
                .orElseThrow(() -> new NotFoundException(String.format(VERSION_ABSENT_MSG, versionId)));
        ensureCanView(currentUser, entity.getDocument());
        return xmlDownloadFromVersion(entity, currentUser);
    }

    @Transactional
    public XmlDownload downloadXml(Long documentId, Long versionId, UserEntity currentUser) {
        if (!documentRepository.existsById(documentId)) {
            throw new NotFoundException(String.format(DOCUMENT_ABSENT_MSG, documentId));
        }
        DocumentVersionEntity entity = documentVersionRepository.findById(versionId).orElse(null);
        if (entity == null || !entity.getDocument().getId().equals(documentId)) {
            throw new NotFoundException(String.format(VERSION_ABSENT_FOR_DOCUMENT_MSG, documentId, versionId));
        }
        ensureCanView(currentUser, entity.getDocument());
        return xmlDownloadFromVersion(entity, currentUser);
    }

    @Transactional(readOnly = true)
    public org.springframework.data.domain.Page<AuditLogDto> getDocumentHistory(
            Long documentId,
            org.springframework.data.domain.Pageable pageable,
            UserEntity currentUser) {
        DocumentEntity document = documentRepository.findById(documentId)
                .orElseThrow(() -> new NotFoundException(String.format(DOCUMENT_ABSENT_MSG, documentId)));
        ensureCanView(currentUser, document);
        List<Long> versionIds = documentVersionRepository.findIdsByDocumentId(documentId);
        org.springframework.data.domain.Page<ru.artwell.contractor.persistence.entity.AuditLogEntity> page =
                versionIds.isEmpty()
                        ? auditLogRepository.findByDocumentId(documentId, pageable)
                        : auditLogRepository.findDocumentHistory(documentId, versionIds, pageable);
        return page.map(auditLogMapper::toDto);
    }

    @Transactional
    public XmlDownload downloadLatestXml(Long documentId, UserEntity currentUser) {
        DocumentEntity document = documentRepository.findById(documentId)
                .orElseThrow(() -> new NotFoundException(String.format(DOCUMENT_ABSENT_MSG, documentId)));
        ensureCanView(currentUser, document);
        DocumentVersionEntity entity = documentVersionRepository
                .findTopByDocument_IdOrderByVersionNumberDesc(documentId)
                .orElseThrow(() -> new NotFoundException(String.format(DOCUMENT_HAS_NO_VERSIONS_MSG, documentId)));
        return xmlDownloadFromVersion(entity, currentUser);
    }

    private XmlDownload xmlDownloadFromVersion(DocumentVersionEntity entity, UserEntity actor) {
        audit(actor, "DOWNLOAD_XML", "VERSION", entity.getId(), "Downloaded original XML");

        Long id = entity.getId();
        byte[] content = entity.getXmlContent();
        if (content == null || content.length == 0) {
            throw new IllegalStateException(
                    "XML для версии " + id + " отсутствует в БД");
        }
        String name = entity.getXmlFileName();
        if (name == null || name.isBlank()) {
            name = "document-" + id + ".xml";
        }
        return new XmlDownload(content, name.trim());
    }

    public static class NotFoundException extends RuntimeException {
        public NotFoundException(String message) {
            super(message);
        }
    }

    public static class ConflictException extends RuntimeException {
        public ConflictException(String message) {
            super(message);
        }
    }

    /** Нет строки в {@code document_types} для определённого кода типа (клиентский сценарий → HTTP 400). */
    public static class UnrecognizedDocumentTypeException extends RuntimeException {
        public UnrecognizedDocumentTypeException() {
            super("Тип документа не распознан");
        }
    }
}
