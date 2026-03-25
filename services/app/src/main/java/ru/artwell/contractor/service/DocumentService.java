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

        XmlMetadataExtractor.RootQName rootQName = xmlMetadataExtractor.extractRootQName(xml);
        xmlMetadataExtractor.assertBusinessDocumentRoot(rootQName);
        XsdCatalogService.DocumentTypeMapping mapping = xsdCatalogService.detectDocumentType(rootQName);

        Schema schema = xsdCatalogService.getSchema(mapping);
        List<XmlValidator.ValidationError> errors = xmlValidator.validateXml(xml, schema);
        boolean valid = errors.isEmpty();

        if (!valid) {
            return new UploadDocumentResponse(
                    null,
                    null,
                    mapping.documentType(),
                    null,
                    0,
                    now,
                    false,
                    errors.stream().map(e -> new ValidationErrorDto(e.message(), e.lineNumber(), e.columnNumber())).toList()
            );
        }

        String documentNumber = xmlMetadataExtractor.extractDocumentNumber(xml);

        XmlDocumentEntity previous = xmlDocumentRepository
                .findTopByDocTypeAndDocumentNumberOrderByVersionDesc(mapping.documentType(), documentNumber)
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
                mapping.documentType(),
                documentNumber,
                nextVersion,
                xmlBytes,
                now,
                previousVersionId
        );

        XmlDocumentEntity saved = xmlDocumentRepository.save(entity);
        auditEventRepository.save(new AuditEventEntity(
                now,
                "UPLOAD",
                "anonymous",
                saved.getId(),
                saved.getGroupId(),
                "Uploaded and validated XML"
        ));

        return toUploadResponse(saved, true, Collections.emptyList());
    }

    @Transactional
    public UploadDocumentResponse replaceXml(UUID id, byte[] xmlBytes) {
        LocalDateTime now = LocalDateTime.now(applicationZoneId);
        XmlDocumentEntity existing = xmlDocumentRepository.findById(id)
                .orElseThrow(() -> new NotFoundException("Документ не найден: " + id));

        String xml = new String(xmlBytes, StandardCharsets.UTF_8);
        XmlMetadataExtractor.RootQName rootQName = xmlMetadataExtractor.extractRootQName(xml);
        xmlMetadataExtractor.assertBusinessDocumentRoot(rootQName);
        XsdCatalogService.DocumentTypeMapping mapping = xsdCatalogService.detectDocumentType(rootQName);
        String newDocumentNumber = xmlMetadataExtractor.extractDocumentNumber(xml);

        if (!existing.getDocType().equals(mapping.documentType())) {
            throw new ConflictException("Новый XML имеет другой тип документа. Текущий: " + existing.getDocType() + ", новый: " + mapping.documentType());
        }
        if (!existing.getDocumentNumber().equals(newDocumentNumber)) {
            throw new ConflictException("Новый XML имеет другой номер документа. Текущий: " + existing.getDocumentNumber() + ", новый: " + newDocumentNumber);
        }

        Schema schema = xsdCatalogService.getSchema(mapping);
        List<XmlValidator.ValidationError> errors = xmlValidator.validateXml(xml, schema);
        boolean valid = errors.isEmpty();

        if (!valid) {
            return new UploadDocumentResponse(
                    null,
                    existing.getGroupId(),
                    mapping.documentType(),
                    newDocumentNumber,
                    0,
                    now,
                    false,
                    errors.stream().map(e -> new ValidationErrorDto(e.message(), e.lineNumber(), e.columnNumber())).toList()
            );
        }

        XmlDocumentEntity latest = xmlDocumentRepository.findTopByGroupIdOrderByVersionDesc(existing.getGroupId())
                .orElseThrow();

        int nextVersion = latest.getVersion() + 1;
        XmlDocumentEntity entity = new XmlDocumentEntity(
                existing.getGroupId(),
                existing.getDocType(),
                existing.getDocumentNumber(),
                nextVersion,
                xmlBytes,
                now,
                latest.getId()
        );

        XmlDocumentEntity saved = xmlDocumentRepository.save(entity);
        auditEventRepository.save(new AuditEventEntity(
                now,
                "REPLACE",
                "anonymous",
                saved.getId(),
                saved.getGroupId(),
                "Replaced XML and created new version"
        ));

        return toUploadResponse(saved, true, Collections.emptyList());
    }

    @Transactional(readOnly = true)
    public List<DocumentListItemResponse> listLatestVersions(String docType, String documentNumber) {
        LocalDateTime now = LocalDateTime.now(applicationZoneId);
        List<DocumentListItemResponse> result = xmlDocumentRepository.findLatestVersions(docType, documentNumber).stream()
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
                                                            List<ValidationErrorDto> errors) {
        return new UploadDocumentResponse(
                saved.getId(),
                saved.getGroupId(),
                saved.getDocType(),
                saved.getDocumentNumber(),
                saved.getVersion(),
                saved.getUploadedAt(),
                valid,
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

