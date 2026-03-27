package ru.artwell.contractor.service;

import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ru.artwell.contractor.config.AppTimeConfiguration;
import ru.artwell.contractor.dto.DocumentDetailResponse;
import ru.artwell.contractor.dto.DocumentListItemResponse;
import ru.artwell.contractor.dto.DocumentVersionInfoResponse;
import ru.artwell.contractor.dto.UploadDocumentResponse;
import ru.artwell.contractor.dto.ValidationErrorDto;
import ru.artwell.contractor.persistence.entity.AuditEventEntity;
import ru.artwell.contractor.persistence.entity.DocumentValidationStatus;
import ru.artwell.contractor.persistence.entity.XmlDocumentEntity;
import ru.artwell.contractor.persistence.repository.AuditEventRepository;
import ru.artwell.contractor.persistence.repository.XmlDocumentRepository;

import javax.xml.validation.Schema;
import java.nio.charset.StandardCharsets;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Collections;
import java.util.List;
import java.util.UUID;

@Service
public class DocumentService {
    private static final String FALLBACK_DOC_TYPE = "UNKNOWN";

    private final ZoneId applicationZoneId;
    private final XmlMetadataExtractor xmlMetadataExtractor;
    private final XsdCatalogService xsdCatalogService;
    private final XmlValidator xmlValidator;
    private final XmlDocumentRepository xmlDocumentRepository;
    private final AuditEventRepository auditEventRepository;

    public DocumentService(@Qualifier(AppTimeConfiguration.APPLICATION_ZONE_ID) ZoneId applicationZoneId,
                            XmlMetadataExtractor xmlMetadataExtractor,
                            XsdCatalogService xsdCatalogService,
                            XmlValidator xmlValidator,
                            XmlDocumentRepository xmlDocumentRepository,
                            AuditEventRepository auditEventRepository) {
        this.applicationZoneId = applicationZoneId;
        this.xmlMetadataExtractor = xmlMetadataExtractor;
        this.xsdCatalogService = xsdCatalogService;
        this.xmlValidator = xmlValidator;
        this.xmlDocumentRepository = xmlDocumentRepository;
        this.auditEventRepository = auditEventRepository;
    }

    @Transactional
    public UploadDocumentResponse uploadXml(byte[] xmlBytes) {
        LocalDateTime now = LocalDateTime.now(applicationZoneId);
        String xml = new String(xmlBytes, StandardCharsets.UTF_8);

        String docType = FALLBACK_DOC_TYPE;
        UUID documentNumber = UUID.randomUUID();
        DocumentValidationStatus status = DocumentValidationStatus.INVALID_XML;
        List<ValidationErrorDto> responseErrors = Collections.emptyList();
        String storedErrors = null;

        try {
            XmlMetadataExtractor.RootQName rootQName = xmlMetadataExtractor.extractRootQName(xml);
            try {
                xmlMetadataExtractor.assertBusinessDocumentRoot(rootQName);
            } catch (IllegalArgumentException e) {
                status = DocumentValidationStatus.INVALID_DOCUMENT_ROOT;
                storedErrors = e.getMessage();
                responseErrors = List.of(new ValidationErrorDto(e.getMessage(), null, null));
                return saveUploaded(now, xmlBytes, docType, documentNumber, status, storedErrors, responseErrors);
            }

            XsdCatalogService.DocumentTypeMapping mapping;
            try {
                mapping = xsdCatalogService.detectDocumentType(rootQName);
            } catch (XsdCatalogService.UnknownDocumentTypeException e) {
                status = DocumentValidationStatus.INVALID_UNKNOWN_DOCUMENT_TYPE;
                storedErrors = e.getMessage();
                responseErrors = List.of(new ValidationErrorDto(e.getMessage(), null, null));
                return saveUploaded(now, xmlBytes, docType, documentNumber, status, storedErrors, responseErrors);
            }

            docType = mapping.documentType();

            // Stable UUID "document number" for grouping: docType + extracted business number.
            try {
                String businessNumber = xmlMetadataExtractor.extractDocumentNumber(xml);
                documentNumber = UUID.nameUUIDFromBytes((docType + "|" + businessNumber).getBytes(StandardCharsets.UTF_8));
            } catch (IllegalArgumentException e) {
                documentNumber = UUID.randomUUID();
            }

            Schema schema = xsdCatalogService.getSchema(mapping);
            List<XmlValidator.ValidationError> errors = xmlValidator.validateXml(xml, schema);
            boolean valid = errors.isEmpty();
            if (valid) {
                status = DocumentValidationStatus.VALID;
                responseErrors = Collections.emptyList();
            } else {
                status = DocumentValidationStatus.INVALID_SCHEMA;
                responseErrors = errors.stream()
                        .map(e -> new ValidationErrorDto(e.message(), e.lineNumber(), e.columnNumber()))
                        .toList();
                storedErrors = errorsToText(errors);
            }

            return saveUploaded(now, xmlBytes, docType, documentNumber, status, storedErrors, responseErrors);
        } catch (IllegalArgumentException e) {
            // XML could not be parsed at all
            status = DocumentValidationStatus.INVALID_XML;
            storedErrors = e.getMessage();
            responseErrors = List.of(new ValidationErrorDto(e.getMessage(), null, null));
            return saveUploaded(now, xmlBytes, docType, documentNumber, status, storedErrors, responseErrors);
        }
    }

    private UploadDocumentResponse saveUploaded(
            LocalDateTime now,
            byte[] xmlBytes,
            String docType,
            UUID documentNumber,
            DocumentValidationStatus status,
            String storedErrors,
            List<ValidationErrorDto> responseErrors
    ) {
        XmlDocumentEntity previous = xmlDocumentRepository
                .findTopByDocTypeAndDocumentNumberOrderByVersionDesc(docType, documentNumber)
                .orElse(null);

        UUID groupId;
        int nextVersion;
        UUID previousVersionId;
        if (previous == null) {
            groupId = UUID.randomUUID();
            nextVersion = 1;
            previousVersionId = null;
        } else {
            groupId = previous.getGroupId();
            nextVersion = previous.getVersion() + 1;
            previousVersionId = previous.getId();
        }

        XmlDocumentEntity entity = new XmlDocumentEntity(
                groupId,
                docType,
                documentNumber,
                nextVersion,
                xmlBytes,
                now,
                previousVersionId,
                status,
                storedErrors
        );

        XmlDocumentEntity saved = xmlDocumentRepository.save(entity);
        auditEventRepository.save(new AuditEventEntity(
                now,
                "UPLOAD",
                "anonymous",
                saved.getId(),
                saved.getGroupId(),
                "Uploaded XML. Status=" + status
        ));

        boolean valid = status == DocumentValidationStatus.VALID;
        return toUploadResponse(saved, valid, status, responseErrors);
    }

    @Transactional
    public UploadDocumentResponse replaceXml(UUID id, byte[] xmlBytes) {
        LocalDateTime now = LocalDateTime.now(applicationZoneId);
        XmlDocumentEntity existing = xmlDocumentRepository.findById(id)
                .orElseThrow(() -> new NotFoundException("Документ не найден: " + id));

        String xml = new String(xmlBytes, StandardCharsets.UTF_8);
        XmlDocumentEntity latest = xmlDocumentRepository.findTopByGroupIdOrderByVersionDesc(existing.getGroupId())
                .orElseThrow();

        int nextVersion = latest.getVersion() + 1;

        DocumentValidationStatus status;
        String storedErrors = null;
        List<ValidationErrorDto> responseErrors = Collections.emptyList();

        try {
            XmlMetadataExtractor.RootQName rootQName = xmlMetadataExtractor.extractRootQName(xml);
            xmlMetadataExtractor.assertBusinessDocumentRoot(rootQName);
            XsdCatalogService.DocumentTypeMapping mapping = xsdCatalogService.detectDocumentType(rootQName);
            String newDocumentNumber = xmlMetadataExtractor.extractDocumentNumber(xml);

            if (!existing.getDocType().equals(mapping.documentType())) {
                status = DocumentValidationStatus.INVALID_CONFLICT;
                storedErrors = "Новый XML имеет другой тип документа. Текущий: " + existing.getDocType() + ", новый: " + mapping.documentType();
                responseErrors = List.of(new ValidationErrorDto(storedErrors, null, null));
            } else if (!existing.getDocumentNumber().equals(newDocumentNumber)) {
                status = DocumentValidationStatus.INVALID_CONFLICT;
                storedErrors = "Новый XML имеет другой номер документа. Текущий: " + existing.getDocumentNumber() + ", новый: " + newDocumentNumber;
                responseErrors = List.of(new ValidationErrorDto(storedErrors, null, null));
            } else {
                Schema schema = xsdCatalogService.getSchema(mapping);
                List<XmlValidator.ValidationError> errors = xmlValidator.validateXml(xml, schema);
                boolean valid = errors.isEmpty();
                if (valid) {
                    status = DocumentValidationStatus.VALID;
                } else {
                    status = DocumentValidationStatus.INVALID_SCHEMA;
                    responseErrors = errors.stream()
                            .map(e -> new ValidationErrorDto(e.message(), e.lineNumber(), e.columnNumber()))
                            .toList();
                    storedErrors = errorsToText(errors);
                }
            }
        } catch (XsdCatalogService.UnknownDocumentTypeException e) {
            status = DocumentValidationStatus.INVALID_UNKNOWN_DOCUMENT_TYPE;
            storedErrors = e.getMessage();
            responseErrors = List.of(new ValidationErrorDto(e.getMessage(), null, null));
        } catch (IllegalArgumentException e) {
            status = DocumentValidationStatus.INVALID_XML;
            storedErrors = e.getMessage();
            responseErrors = List.of(new ValidationErrorDto(e.getMessage(), null, null));
        }

        XmlDocumentEntity entity = new XmlDocumentEntity(
                existing.getGroupId(),
                existing.getDocType(),
                existing.getDocumentNumber(),
                nextVersion,
                xmlBytes,
                now,
                latest.getId(),
                status,
                storedErrors
        );

        XmlDocumentEntity saved = xmlDocumentRepository.save(entity);
        auditEventRepository.save(new AuditEventEntity(
                now,
                "REPLACE",
                "anonymous",
                saved.getId(),
                saved.getGroupId(),
                "Replaced XML. Status=" + status
        ));

        boolean valid = status == DocumentValidationStatus.VALID;
        return toUploadResponse(saved, valid, status, responseErrors);
    }

    private static String errorsToText(List<XmlValidator.ValidationError> errors) {
        if (errors == null || errors.isEmpty()) {
            return null;
        }
        StringBuilder sb = new StringBuilder();
        for (XmlValidator.ValidationError e : errors) {
            if (sb.length() > 0) sb.append('\n');
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
        LocalDateTime now = LocalDateTime.now(applicationZoneId);
        UUID documentNumberUuid = null;
        if (documentNumber != null && !documentNumber.isBlank()) {
            try {
                documentNumberUuid = UUID.fromString(documentNumber.trim());
            } catch (IllegalArgumentException ignored) {
                documentNumberUuid = null;
            }
        }

        List<DocumentListItemResponse> result = xmlDocumentRepository.findLatestVersions(docType, documentNumberUuid).stream()
                .map(d -> new DocumentListItemResponse(
                        d.getId(),
                        d.getDocType(),
                        d.getDocumentNumber(),
                        d.getVersion(),
                        d.getUploadedAt()
                ))
                .toList();

        auditEventRepository.save(new AuditEventEntity(
                now,
                "VIEW_LIST",
                "anonymous",
                null,
                null,
                "Viewed document list"
        ));

        return result;
    }

    @Transactional(readOnly = true)
    public DocumentDetailResponse getDetail(UUID id) {
        LocalDateTime now = LocalDateTime.now(applicationZoneId);
        XmlDocumentEntity entity = xmlDocumentRepository.findById(id)
                .orElseThrow(() -> new NotFoundException("Документ не найден: " + id));

        List<XmlDocumentEntity> versions = xmlDocumentRepository.findByGroupIdOrderByVersionDesc(entity.getGroupId());
        auditEventRepository.save(new AuditEventEntity(
                now,
                "VIEW_DETAIL",
                "anonymous",
                entity.getId(),
                entity.getGroupId(),
                "Viewed document detail"
        ));

        List<DocumentVersionInfoResponse> versionInfos = versions.stream()
                .map(v -> new DocumentVersionInfoResponse(
                        v.getId(),
                        v.getVersion(),
                        v.getPreviousVersionId(),
                        v.getUploadedAt()
                ))
                .toList();

        return new DocumentDetailResponse(
                entity.getId(),
                entity.getGroupId(),
                entity.getDocType(),
                entity.getDocumentNumber(),
                entity.getUploadedAt(),
                versionInfos
        );
    }

    @Transactional(readOnly = true)
    public byte[] downloadXml(UUID id) {
        LocalDateTime now = LocalDateTime.now(applicationZoneId);
        XmlDocumentEntity entity = xmlDocumentRepository.findById(id)
                .orElseThrow(() -> new NotFoundException("Документ не найден: " + id));

        auditEventRepository.save(new AuditEventEntity(
                now,
                "DOWNLOAD_XML",
                "anonymous",
                entity.getId(),
                entity.getGroupId(),
                "Downloaded original XML"
        ));

        return entity.getXmlContent();
    }

    private static UploadDocumentResponse toUploadResponse(XmlDocumentEntity saved,
                                                            boolean valid,
                                                            DocumentValidationStatus validationStatus,
                                                            List<ValidationErrorDto> errors) {
        return new UploadDocumentResponse(
                saved.getId(),
                saved.getGroupId(),
                saved.getDocType(),
                saved.getDocumentNumber(),
                saved.getVersion(),
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

