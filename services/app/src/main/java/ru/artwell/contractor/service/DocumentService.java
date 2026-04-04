package ru.artwell.contractor.service;

import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ru.artwell.contractor.config.AppTimeConfiguration;
import ru.artwell.contractor.config.ReferenceDataInitializer;
import ru.artwell.contractor.dto.DocumentDetailResponse;
import ru.artwell.contractor.dto.DocumentListItemResponse;
import ru.artwell.contractor.dto.DocumentVersionInfoResponse;
import ru.artwell.contractor.dto.UploadDocumentResponse;
import ru.artwell.contractor.dto.ValidationErrorDto;
import ru.artwell.contractor.persistence.entity.*;
import ru.artwell.contractor.persistence.repository.*;

import javax.xml.validation.Schema;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;

@Service
public class DocumentService {
    private static final String FALLBACK_DOC_TYPE = "UNKNOWN";

    private final ZoneId applicationZoneId;
    private final XmlMetadataExtractor xmlMetadataExtractor;
    private final XsdCatalogService xsdCatalogService;
    private final XmlValidator xmlValidator;
    private final XmlFileStorageService xmlFileStorageService;
    private final UserRepository userRepository;
    private final ConstructionObjectRepository constructionObjectRepository;
    private final DocumentTypeRepository documentTypeRepository;
    private final DocumentRepository documentRepository;
    private final DocumentVersionRepository documentVersionRepository;
    private final AuditLogRepository auditLogRepository;
    private final String seedTestUsername;

    public DocumentService(@Qualifier(AppTimeConfiguration.APPLICATION_ZONE_ID) ZoneId applicationZoneId,
                           XmlMetadataExtractor xmlMetadataExtractor,
                           XsdCatalogService xsdCatalogService,
                           XmlValidator xmlValidator,
                           XmlFileStorageService xmlFileStorageService,
                           UserRepository userRepository,
                           ConstructionObjectRepository constructionObjectRepository,
                           DocumentTypeRepository documentTypeRepository,
                           DocumentRepository documentRepository,
                           DocumentVersionRepository documentVersionRepository,
                           AuditLogRepository auditLogRepository,
                           @Value("${app.seed.test-username}") String seedTestUsername) {
        this.applicationZoneId = applicationZoneId;
        this.xmlMetadataExtractor = xmlMetadataExtractor;
        this.xsdCatalogService = xsdCatalogService;
        this.xmlValidator = xmlValidator;
        this.xmlFileStorageService = xmlFileStorageService;
        this.userRepository = userRepository;
        this.constructionObjectRepository = constructionObjectRepository;
        this.documentTypeRepository = documentTypeRepository;
        this.documentRepository = documentRepository;
        this.documentVersionRepository = documentVersionRepository;
        this.auditLogRepository = auditLogRepository;
        this.seedTestUsername = seedTestUsername;
    }

    @Transactional
    public UploadDocumentResponse uploadXml(byte[] xmlBytes, String originalFileName) {
        LocalDateTime now = LocalDateTime.now(applicationZoneId);
        String xml = new String(xmlBytes, StandardCharsets.UTF_8);
        String fileLabel = (originalFileName == null || originalFileName.isBlank()) ? "document.xml" : originalFileName.trim();

        String docTypeCode = FALLBACK_DOC_TYPE;
        String businessNumber = "UNKNOWN-" + UUID.randomUUID();
        DocumentValidationStatus apiStatus = DocumentValidationStatus.INVALID_XML;
        List<ValidationErrorDto> responseErrors = Collections.emptyList();
        String storedErrors = null;
        Optional<LocalDate> documentDate = Optional.empty();

        try {
            XmlMetadataExtractor.RootQName rootQName = xmlMetadataExtractor.extractRootQName(xml);
            try {
                xmlMetadataExtractor.assertBusinessDocumentRoot(rootQName);
            } catch (IllegalArgumentException e) {
                apiStatus = DocumentValidationStatus.INVALID_DOCUMENT_ROOT;
                storedErrors = e.getMessage();
                responseErrors = List.of(new ValidationErrorDto(e.getMessage(), null, null));
                return saveUploaded(now, xmlBytes, fileLabel, docTypeCode, businessNumber, documentDate, apiStatus, storedErrors, responseErrors);
            }

            XsdCatalogService.DocumentTypeMapping mapping;
            try {
                mapping = xsdCatalogService.detectDocumentType(rootQName);
            } catch (XsdCatalogService.UnknownDocumentTypeException e) {
                apiStatus = DocumentValidationStatus.INVALID_UNKNOWN_DOCUMENT_TYPE;
                storedErrors = e.getMessage();
                responseErrors = List.of(new ValidationErrorDto(e.getMessage(), null, null));
                return saveUploaded(now, xmlBytes, fileLabel, docTypeCode, businessNumber, documentDate, apiStatus, storedErrors, responseErrors);
            }

            docTypeCode = mapping.documentType();

            try {
                businessNumber = xmlMetadataExtractor.extractDocumentNumber(xml);
            } catch (IllegalArgumentException e) {
                businessNumber = "UNKNOWN-" + UUID.randomUUID();
            }

            documentDate = xmlMetadataExtractor.extractDocumentDate(xml);

            Schema schema = xsdCatalogService.getSchema(mapping);
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

            return saveUploaded(now, xmlBytes, fileLabel, docTypeCode, businessNumber, documentDate, apiStatus, storedErrors, responseErrors);
        } catch (IllegalArgumentException e) {
            apiStatus = DocumentValidationStatus.INVALID_XML;
            storedErrors = e.getMessage();
            responseErrors = List.of(new ValidationErrorDto(e.getMessage(), null, null));
            return saveUploaded(now, xmlBytes, fileLabel, docTypeCode, businessNumber, documentDate, apiStatus, storedErrors, responseErrors);
        }
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
            List<ValidationErrorDto> responseErrors
    ) {
        UserEntity actor = systemUser();
        ConstructionObjectEntity object = defaultConstructionObject();
        DocumentTypeEntity docType = documentTypeRepository.findByTypeCode(docTypeCode)
                .orElseThrow(() -> new IllegalStateException("Нет записи в document_types для кода: " + docTypeCode));

        DocumentEntity document = documentRepository
                .findByDocumentType_TypeCodeAndDocumentNumber(docTypeCode, businessDocumentNumber)
                .orElse(null);

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
            previousVersion = documentVersionRepository
                    .findTopByDocument_IdOrderByVersionNumberDesc(document.getId())
                    .orElseThrow();
            nextVersion = previousVersion.getVersionNumber() + 1;
        }

        String relativePath;
        try {
            relativePath = xmlFileStorageService.store(document.getId(), nextVersion, xmlBytes);
        } catch (IOException e) {
            throw new IllegalStateException("Не удалось сохранить XML на диск: " + e.getMessage(), e);
        }

        DocumentVersionEntity version = new DocumentVersionEntity(
                document,
                nextVersion,
                relativePath,
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

        audit(actor, "UPLOAD", "VERSION", savedVersion.getId(), "Uploaded XML. apiStatus=" + apiStatus);

        boolean valid = apiStatus == DocumentValidationStatus.VALID;
        return toUploadResponse(savedVersion, document, valid, apiStatus, responseErrors);
    }

    @Transactional
    public UploadDocumentResponse replaceXml(Long id, byte[] xmlBytes, String originalFileName) {
        LocalDateTime now = LocalDateTime.now(applicationZoneId);
        String fileLabel = (originalFileName == null || originalFileName.isBlank()) ? "document.xml" : originalFileName.trim();

        DocumentVersionEntity existing = documentVersionRepository.findById(id)
                .orElseThrow(() -> new NotFoundException("Документ не найден: " + id));

        DocumentEntity doc = existing.getDocument();
        DocumentVersionEntity latest = documentVersionRepository.findTopByDocument_IdOrderByVersionNumberDesc(doc.getId())
                .orElseThrow();

        int nextVersion = latest.getVersionNumber() + 1;
        UserEntity actor = systemUser();

        DocumentValidationStatus apiStatus;
        String storedErrors = null;
        List<ValidationErrorDto> responseErrors = Collections.emptyList();
        Optional<LocalDate> documentDate = Optional.empty();

        String xml = new String(xmlBytes, StandardCharsets.UTF_8);
        try {
            XmlMetadataExtractor.RootQName rootQName = xmlMetadataExtractor.extractRootQName(xml);
            xmlMetadataExtractor.assertBusinessDocumentRoot(rootQName);
            XsdCatalogService.DocumentTypeMapping mapping = xsdCatalogService.detectDocumentType(rootQName);
            String newDocumentNumber = xmlMetadataExtractor.extractDocumentNumber(xml);
            documentDate = xmlMetadataExtractor.extractDocumentDate(xml);

            if (!doc.getDocumentType().getTypeCode().equals(mapping.documentType())) {
                apiStatus = DocumentValidationStatus.INVALID_CONFLICT;
                storedErrors = "Новый XML имеет другой тип документа. Текущий: " + doc.getDocumentType().getTypeCode() + ", новый: " + mapping.documentType();
                responseErrors = List.of(new ValidationErrorDto(storedErrors, null, null));
            } else if (!doc.getDocumentNumber().equals(newDocumentNumber)) {
                apiStatus = DocumentValidationStatus.INVALID_CONFLICT;
                storedErrors = "Новый XML имеет другой номер документа. Текущий: " + doc.getDocumentNumber() + ", новый: " + newDocumentNumber;
                responseErrors = List.of(new ValidationErrorDto(storedErrors, null, null));
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

        String relativePath;
        try {
            relativePath = xmlFileStorageService.store(doc.getId(), nextVersion, xmlBytes);
        } catch (IOException e) {
            throw new IllegalStateException("Не удалось сохранить XML на диск: " + e.getMessage(), e);
        }

        DocumentVersionEntity entity = new DocumentVersionEntity(
                doc,
                nextVersion,
                relativePath,
                fileLabel,
                xmlBytes.length,
                toVersionValidationStatus(apiStatus),
                storedErrors,
                actor,
                now,
                latest
        );
        DocumentVersionEntity saved = documentVersionRepository.save(entity);

        doc.setCurrentVersion(nextVersion);
        doc.setUploadedAt(now);
        doc.setUploadedBy(actor);
        documentDate.ifPresent(doc::setDocumentDate);
        documentRepository.save(doc);

        audit(actor, "REPLACE", "VERSION", saved.getId(), "Replaced XML. apiStatus=" + apiStatus);

        boolean valid = apiStatus == DocumentValidationStatus.VALID;
        return toUploadResponse(saved, doc, valid, apiStatus, responseErrors);
    }

    private static String buildTitle(String originalFileName, String businessNumber) {
        return "Документ № " + businessNumber + " (" + originalFileName + ")";
    }

    private UserEntity systemUser() {
        return userRepository.findByUsername(seedTestUsername)
                .orElseThrow(() -> new IllegalStateException("Тестовый пользователь не найден: " + seedTestUsername));
    }

    private ConstructionObjectEntity defaultConstructionObject() {
        return constructionObjectRepository.findByObjectCode(ReferenceDataInitializer.DEFAULT_OBJECT_CODE)
                .orElseThrow(() -> new IllegalStateException("Объект по умолчанию не найден: " + ReferenceDataInitializer.DEFAULT_OBJECT_CODE));
    }

    private void audit(UserEntity user, String actionType, String entityType, Long entityId, String message) {
        auditLogRepository.save(new AuditLogEntity(
                user,
                user.getUsername(),
                actionType,
                entityType,
                entityId,
                Map.of("message", message),
                null,
                LocalDateTime.now(applicationZoneId)
        ));
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

    @Transactional(readOnly = true)
    public List<DocumentListItemResponse> listLatestVersions(String docType, String documentNumber) {
        String typeCode = docType != null && !docType.isBlank() ? docType.trim() : null;
        String docNum = documentNumber != null && !documentNumber.isBlank() ? documentNumber.trim() : null;

        List<DocumentListItemResponse> result = documentVersionRepository.findCurrentVersions(typeCode, docNum).stream()
                .map(d -> new DocumentListItemResponse(
                        d.getId(),
                        d.getDocument().getDocumentType().getTypeCode(),
                        d.getDocument().getDocumentNumber(),
                        d.getVersionNumber(),
                        d.getUploadedAt()
                ))
                .toList();

        UserEntity actor = systemUser();
        audit(actor, "VIEW_LIST", "DOCUMENT", null, "Viewed document list");

        return result;
    }

    @Transactional(readOnly = true)
    public DocumentDetailResponse getDetail(Long id) {
        DocumentVersionEntity entity = documentVersionRepository.findByIdWithDocument(id)
                .orElseThrow(() -> new NotFoundException("Документ не найден: " + id));

        List<DocumentVersionEntity> versions = documentVersionRepository.findByDocument_IdOrderByVersionNumberDesc(entity.getDocument().getId());
        UserEntity actor = systemUser();
        audit(actor, "VIEW_DETAIL", "VERSION", entity.getId(), "Viewed document detail");

        List<DocumentVersionInfoResponse> versionInfos = versions.stream()
                .map(v -> new DocumentVersionInfoResponse(
                        v.getId(),
                        v.getVersionNumber(),
                        v.getPreviousVersion() == null ? null : v.getPreviousVersion().getId(),
                        v.getUploadedAt()
                ))
                .toList();

        return new DocumentDetailResponse(
                entity.getId(),
                entity.getDocument().getId(),
                entity.getDocument().getDocumentType().getTypeCode(),
                entity.getDocument().getDocumentNumber(),
                entity.getUploadedAt(),
                versionInfos
        );
    }

    @Transactional(readOnly = true)
    public byte[] downloadXml(Long id) {
        DocumentVersionEntity entity = documentVersionRepository.findById(id)
                .orElseThrow(() -> new NotFoundException("Документ не найден: " + id));

        UserEntity actor = systemUser();
        audit(actor, "DOWNLOAD_XML", "VERSION", entity.getId(), "Downloaded original XML");

        try {
            return xmlFileStorageService.load(entity.getXmlFilePath());
        } catch (IOException e) {
            throw new IllegalStateException("Не удалось прочитать XML с диска: " + e.getMessage(), e);
        }
    }

    private static UploadDocumentResponse toUploadResponse(DocumentVersionEntity saved,
                                                           DocumentEntity document,
                                                           boolean valid,
                                                           DocumentValidationStatus validationStatus,
                                                           List<ValidationErrorDto> errors) {
        return new UploadDocumentResponse(
                saved.getId(),
                document.getId(),
                document.getDocumentType().getTypeCode(),
                document.getDocumentNumber(),
                saved.getVersionNumber(),
                saved.getUploadedAt(),
                valid,
                validationStatus,
                errors
        );
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
}
