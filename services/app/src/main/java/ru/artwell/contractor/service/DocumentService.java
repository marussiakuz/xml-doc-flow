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
import ru.artwell.contractor.dto.ConstructionObjectInfo;
import ru.artwell.contractor.dto.ConstructionObjectDto;
import ru.artwell.contractor.dto.DocumentCardResponse;
import ru.artwell.contractor.dto.DocumentFilter;
import ru.artwell.contractor.dto.DocumentLinks;
import ru.artwell.contractor.dto.DocumentResponse;
import ru.artwell.contractor.dto.DocumentTypeDto;
import ru.artwell.contractor.dto.OrganizationInfo;
import ru.artwell.contractor.dto.UserDto;
import ru.artwell.contractor.dto.ParticipantDto;
import ru.artwell.contractor.dto.ParticipantInfo;
import ru.artwell.contractor.dto.UploadDocumentResponse;
import ru.artwell.contractor.dto.UserInfo;
import ru.artwell.contractor.dto.XmlDownload;
import ru.artwell.contractor.dto.ValidationErrorDto;
import ru.artwell.contractor.dto.VersionInfo;
import ru.artwell.contractor.util.NameFormats;
import ru.artwell.contractor.persistence.entity.*;
import ru.artwell.contractor.persistence.repository.*;
import ru.artwell.contractor.persistence.spec.DocumentSpecifications;

import jakarta.servlet.http.HttpServletRequest;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

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

    private static final Map<String, String> PARTICIPANT_ROLE_LABELS = Map.of(
            ParticipantDto.ROLE_DEVELOPER, "Застройщик",
            ParticipantDto.ROLE_BUILDING_CONTRACTOR, "Лицо, осуществляющее строительство",
            ParticipantDto.ROLE_PROJECT_DOCUMENTATION_CONTRACTOR, "Лицо, осуществляющее подготовку проектной документации",
            ParticipantDto.ROLE_TECHNICAL_CUSTOMER, "Технический заказчик"
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
    private final OrganizationRepository organizationRepository;
    private final DocumentParticipantRepository documentParticipantRepository;
    private final PermissionService permissionService;

    public DocumentService(@Qualifier(AppTimeConfiguration.APPLICATION_ZONE_ID) ZoneId applicationZoneId,
                           XmlMetadataExtractor xmlMetadataExtractor,
                           XsdCatalogService xsdCatalogService,
                           XmlValidator xmlValidator,
                           ConstructionObjectRepository constructionObjectRepository,
                           OrganizationRepository organizationRepository,
                           DocumentTypeRepository documentTypeRepository,
                           DocumentRepository documentRepository,
                           DocumentVersionRepository documentVersionRepository,
                           AuditLogRepository auditLogRepository,
                           DocumentParticipantRepository documentParticipantRepository,
                           PermissionService permissionService) {
        this.applicationZoneId = applicationZoneId;
        this.xmlMetadataExtractor = xmlMetadataExtractor;
        this.xsdCatalogService = xsdCatalogService;
        this.xmlValidator = xmlValidator;
        this.constructionObjectRepository = constructionObjectRepository;
        this.organizationRepository = organizationRepository;
        this.documentTypeRepository = documentTypeRepository;
        this.documentRepository = documentRepository;
        this.documentVersionRepository = documentVersionRepository;
        this.auditLogRepository = auditLogRepository;
        this.documentParticipantRepository = documentParticipantRepository;
        this.permissionService = permissionService;
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

        try {
            XmlMetadataExtractor.RootQName rootQName = xmlMetadataExtractor.extractRootQName(xml);
            try {
                xmlMetadataExtractor.assertBusinessDocumentRoot(rootQName);
            } catch (IllegalArgumentException e) {
                apiStatus = DocumentValidationStatus.INVALID_DOCUMENT_ROOT;
                storedErrors = e.getMessage();
                responseErrors = List.of(new ValidationErrorDto(e.getMessage(), null, null));
                return saveUploaded(now, xmlBytes, fileLabel, docTypeCode, businessNumber, documentDate, apiStatus, storedErrors, responseErrors, xml, uploader);
            }

            XsdCatalogService.DocumentTypeMapping mapping;
            try {
                mapping = xsdCatalogService.detectDocumentType(rootQName);
            } catch (XsdCatalogService.UnknownDocumentTypeException e) {
                apiStatus = DocumentValidationStatus.INVALID_UNKNOWN_DOCUMENT_TYPE;
                storedErrors = e.getMessage();
                responseErrors = List.of(new ValidationErrorDto(e.getMessage(), null, null));
                return saveUploaded(now, xmlBytes, fileLabel, docTypeCode, businessNumber, documentDate, apiStatus, storedErrors, responseErrors, xml, uploader);
            }

            docTypeCode = mapping.documentType();

            try {
                businessNumber = xmlMetadataExtractor.extractDocumentNumber(xml);
            } catch (IllegalArgumentException e) {
                businessNumber = "UNKNOWN-" + sha256Prefix(xmlBytes);
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

            return saveUploaded(now, xmlBytes, fileLabel, docTypeCode, businessNumber, documentDate, apiStatus, storedErrors, responseErrors, xml, uploader);
        } catch (IllegalArgumentException e) {
            apiStatus = DocumentValidationStatus.INVALID_XML;
            storedErrors = e.getMessage();
            responseErrors = List.of(new ValidationErrorDto(e.getMessage(), null, null));
            return saveUploaded(now, xmlBytes, fileLabel, docTypeCode, businessNumber, documentDate, apiStatus, storedErrors, responseErrors, xml, uploader);
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
            List<ValidationErrorDto> responseErrors,
            String xml,
            UserEntity actor
    ) {
        checkUploadPermission(actor, docTypeCode);
        ConstructionObjectEntity object = resolveConstructionObject(xml);
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
            ensureCanView(actor, document);
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

        persistParticipants(xml, savedVersion);

        audit(actor, "UPLOAD", "VERSION", savedVersion.getId(), "Uploaded XML. apiStatus=" + apiStatus);

        boolean valid = apiStatus == DocumentValidationStatus.VALID;
        return toUploadResponse(savedVersion, document, valid, apiStatus, responseErrors);
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

        ConstructionObjectEntity resolvedObject = resolveConstructionObject(xml);
        doc.setConstructionObject(resolvedObject);
        doc.setCurrentVersion(nextVersion);
        doc.setUploadedAt(now);
        doc.setUploadedBy(actor);
        documentDate.ifPresent(doc::setDocumentDate);
        documentRepository.save(doc);

        persistParticipants(xml, saved);

        audit(actor, "REPLACE", "VERSION", saved.getId(), "Replaced XML. apiStatus=" + apiStatus);

        boolean valid = apiStatus == DocumentValidationStatus.VALID;
        return toUploadResponse(saved, doc, valid, apiStatus, responseErrors);
    }

    private static String buildTitle(String originalFileName, String businessNumber) {
        return "Документ № " + businessNumber + " (" + originalFileName + ")";
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
    private ConstructionObjectEntity resolveConstructionObject(String xml) {
        try {
            Optional<String> name = xmlMetadataExtractor.extractPermanentObjectName(xml);
            Optional<ConstructionObjectAddressDto> addrStructured =
                    xmlMetadataExtractor.extractPermanentObjectAddressStructured(xml);
            Optional<String> guid = xmlMetadataExtractor.extractPermanentObjectUUID(xml);
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

    private void persistParticipants(String xml, DocumentVersionEntity version) {
        List<ParticipantDto> participants = xmlMetadataExtractor.extractParticipants(xml);
        for (ParticipantDto p : participants) {
            if (isParticipantEmpty(p)) {
                continue;
            }
            OrganizationEntity org = findOrCreateOrganization(p);
            String participantType = p.inn().isBlank() && !p.name().isBlank() ? "INDIVIDUAL_ENTREPRENEUR" : "LEGAL_ENTITY";
            documentParticipantRepository.save(new DocumentParticipantEntity(
                    version,
                    org,
                    p.role(),
                    participantType,
                    p.name(),
                    blankToNull(p.inn()),
                    null
            ));
        }
    }

    private static boolean isParticipantEmpty(ParticipantDto p) {
        boolean noName = p.name() == null || p.name().isBlank();
        boolean noInn = p.inn() == null || p.inn().isBlank();
        return noName && noInn;
    }

    private OrganizationEntity findOrCreateOrganization(ParticipantDto p) {
        String inn = p.inn() != null ? p.inn().trim() : "";
        if (!inn.isEmpty()) {
            Optional<OrganizationEntity> opt = organizationRepository.findByInn(inn);
            if (opt.isPresent()) {
                OrganizationEntity o = opt.get();
                if (p.name() != null && !p.name().isBlank()) {
                    o.setOrgName(p.name());
                }
                if (p.ogrn() != null && !p.ogrn().isBlank()) {
                    o.setOgrn(p.ogrn().trim());
                }
                if (p.address() != null) {
                    applyOrganizationStructuredAddress(o, p.address());
                }
                return organizationRepository.save(o);
            }
        }
        OrganizationEntity created = new OrganizationEntity(
                blankToDefault(p.name(), "Без наименования"),
                null,
                "UNKNOWN",
                inn.isEmpty() ? null : inn,
                null,
                blankToNull(p.ogrn()),
                null,
                true
        );
        if (p.address() != null) {
            applyOrganizationStructuredAddress(created, p.address());
        }
        return organizationRepository.save(created);
    }

    private static void applyOrganizationStructuredAddress(OrganizationEntity e, ConstructionObjectAddressDto a) {
        e.setCountry(blankToNull(a.country()));
        e.setRegion(blankToNull(a.region()));
        e.setDistrict(blankToNull(a.district()));
        e.setLocality(blankToNull(a.locality()));
        e.setStreet(blankToNull(a.street()));
        e.setHouse(blankToNull(a.house()));
        e.setPostalCode(blankToNull(a.postalCode()));
        e.setOktmo(blankToNull(a.oktmo()));
        if (a.fullAddress() != null && !a.fullAddress().isBlank()) {
            e.setLegalAddress(a.fullAddress().trim());
        } else if (a.oktmo() != null && !a.oktmo().isBlank()) {
            e.setLegalAddress(a.oktmo().trim());
        }
    }

    private static String blankToNull(String s) {
        if (s == null || s.isBlank()) {
            return null;
        }
        return s.trim();
    }

    private static String blankToDefault(String s, String def) {
        if (s == null || s.isBlank()) {
            return def;
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
            // IPv6 loopback → читаемый вид
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

        return page.map(this::toDocumentResponse);
    }

    private DocumentResponse toDocumentResponse(DocumentEntity doc) {
        DocumentVersionEntity ver = documentVersionRepository
                .findByDocument_IdAndVersionNumber(doc.getId(), doc.getCurrentVersion())
                .orElseThrow(() -> new IllegalStateException(
                        "Нет версии " + doc.getCurrentVersion() + " для документа " + doc.getId()));

        DocumentTypeEntity dt = doc.getDocumentType();
        DocumentTypeDto typeDto = new DocumentTypeDto(
                dt.getId(),
                dt.getTypeCode(),
                dt.getTypeName(),
                dt.getCategory()
        );

        ConstructionObjectEntity co = doc.getConstructionObject();
        ConstructionObjectDto objectDto = new ConstructionObjectDto(
                co.getId(),
                co.getObjectCode(),
                co.getObjectName(),
                co.getAddress()
        );

        UserEntity uploader = doc.getUploadedBy();
        UserDto userDto = new UserDto(uploader.getId(), uploader.getUsername(), NameFormats.toLastNameWithInitials(uploader.getFullName()));

        long documentId = doc.getId();
        String base = "/api/documents/" + documentId;
        DocumentLinks links = new DocumentLinks(
                base + "/versions/" + ver.getId() + "/download",
                base + "/versions",
                base
        );

        return new DocumentResponse(
                ver.getId(),
                documentId,
                doc.getDocumentNumber(),
                doc.getDocumentDate(),
                doc.getTitle(),
                typeDto,
                objectDto,
                doc.getCurrentVersion(),
                doc.isLatestVersion(),
                ver.getValidationStatus().name(),
                doc.getStatus(),
                userDto,
                doc.getUploadedAt(),
                ver.getXmlFileName(),
                ver.getXmlFileSize(),
                links
        );
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

        return buildDocumentCardResponse(document, currentVersion, participantEntities, versions);
    }

    private DocumentCardResponse buildDocumentCardResponse(
            DocumentEntity document,
            DocumentVersionEntity currentVersion,
            List<DocumentParticipantEntity> participantEntities,
            List<DocumentVersionEntity> versions
    ) {
        ConstructionObjectEntity co = document.getConstructionObject();
        String objectDisplayCode = co.getPermanentObjectUuid();
        if (objectDisplayCode == null || objectDisplayCode.isBlank()) {
            objectDisplayCode = co.getObjectCode();
        }
        ConstructionObjectInfo constructionObjectInfo = new ConstructionObjectInfo(
                co.getId(),
                co.getObjectName(),
                ConstructionObjectAddressDto.fromEntity(co),
                objectDisplayCode
        );

        List<ParticipantInfo> participantInfos = participantEntities.stream()
                .map(this::toParticipantInfo)
                .toList();

        List<VersionInfo> versionInfos = versions.stream()
                .map(v -> toVersionInfo(v, document.getCurrentVersion(), document.getId()))
                .toList();

        UserEntity uploader = document.getUploadedBy();
        UserInfo userInfo = new UserInfo(uploader.getId(), uploader.getUsername(), NameFormats.toLastNameWithInitials(uploader.getFullName()));

        return new DocumentCardResponse(
                document.getId(),
                document.getDocumentNumber(),
                document.getDocumentDate(),
                document.getDocumentType().getTypeCode(),
                document.getDocumentType().getTypeName(),
                constructionObjectInfo,
                participantInfos,
                document.getCurrentVersion(),
                document.getUploadedAt(),
                userInfo,
                versionInfos,
                document.getStatus(),
                currentVersion.getValidationStatus().name()
        );
    }

    private ParticipantInfo toParticipantInfo(DocumentParticipantEntity p) {
        String role = p.getParticipantRole();
        String roleName = PARTICIPANT_ROLE_LABELS.getOrDefault(role, role);
        OrganizationEntity orgEntity = p.getOrganization();
        ConstructionObjectAddressDto addrDto = orgEntity != null
                ? ConstructionObjectAddressDto.fromOrganizationEntity(orgEntity)
                : null;
        OrganizationInfo orgInfo;
        if (orgEntity != null) {
            orgInfo = new OrganizationInfo(
                    orgEntity.getId(),
                    orgEntity.getOrgName(),
                    orgEntity.getInn(),
                    orgEntity.getOgrn(),
                    addrDto
            );
        } else {
            orgInfo = new OrganizationInfo(
                    null,
                    p.getParticipantName(),
                    p.getParticipantInn(),
                    null,
                    null
            );
        }
        return new ParticipantInfo(role, roleName, orgInfo, addrDto);
    }

    private static VersionInfo toVersionInfo(DocumentVersionEntity v, int documentCurrentVersion, Long documentId) {
        boolean isCurrent = v.getVersionNumber() == documentCurrentVersion;
        return new VersionInfo(
                v.getId(),
                v.getVersionNumber(),
                v.getUploadedAt(),
                v.getValidationStatus().name(),
                isCurrent,
                "/api/documents/" + documentId + "/versions/" + v.getId() + "/download"
        );
    }

    @Transactional(readOnly = true)
    public List<VersionInfo> listDocumentVersions(Long documentId, UserEntity currentUser) {
        DocumentEntity document = documentRepository.findById(documentId)
                .orElseThrow(() -> new NotFoundException(String.format(DOCUMENT_ABSENT_MSG, documentId)));

        ensureCanView(currentUser, document);

        List<DocumentVersionEntity> versions =
                documentVersionRepository.findByDocument_IdOrderByVersionNumberDesc(documentId);

        return versions.stream()
                .map(v -> toVersionInfo(v, document.getCurrentVersion(), document.getId()))
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
        return page.map(AuditLogDto::from);
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

    private static UploadDocumentResponse toUploadResponse(DocumentVersionEntity saved,
                                                           DocumentEntity document,
                                                           boolean valid,
                                                           DocumentValidationStatus validationStatus,
                                                           List<ValidationErrorDto> errors) {
        return new UploadDocumentResponse(
                saved.getId(),
                document.getId(),
                document.getDocumentType().getTypeCode(),
                document.getDocumentType().getTypeName(),
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
