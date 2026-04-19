package ru.artwell.contractor.service;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.mockito.junit.jupiter.MockitoSettings;
import org.mockito.quality.Strictness;
import org.w3c.dom.Document;
import ru.artwell.contractor.config.ReferenceDataInitializer;
import ru.artwell.contractor.dto.UploadDocumentResponse;
import ru.artwell.contractor.mapper.AuditLogMapper;
import ru.artwell.contractor.mapper.DocumentCardAssembler;
import ru.artwell.contractor.mapper.DocumentListItemMapper;
import ru.artwell.contractor.mapper.ParticipantMapper;
import ru.artwell.contractor.mapper.UploadDocumentMapper;
import ru.artwell.contractor.mapper.VersionInfoMapper;
import ru.artwell.contractor.mapper.WorkVolumeMapper;
import ru.artwell.contractor.persistence.entity.*;
import ru.artwell.contractor.persistence.repository.*;

import javax.xml.validation.Schema;
import java.time.ZoneId;
import java.util.Collections;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@MockitoSettings(strictness = Strictness.LENIENT)
class DocumentServiceTest {

    @Mock XmlMetadataExtractor xmlMetadataExtractor;
    @Mock XsdCatalogService xsdCatalogService;
    @Mock XmlValidator xmlValidator;
    @Mock ConstructionObjectRepository constructionObjectRepository;
    @Mock DocumentTypeRepository documentTypeRepository;
    @Mock DocumentRepository documentRepository;
    @Mock DocumentVersionRepository documentVersionRepository;
    @Mock AuditLogRepository auditLogRepository;
    @Mock DocumentParticipantRepository documentParticipantRepository;
    @Mock PermissionService permissionService;
    @Mock WorkVolumeRepository workVolumeRepository;
    @Mock ParticipantPersister participantPersister;
    @Mock DocumentListItemMapper documentListItemMapper;
    @Mock DocumentCardAssembler documentCardAssembler;
    @Mock ParticipantMapper participantMapper;
    @Mock VersionInfoMapper versionInfoMapper;
    @Mock WorkVolumeMapper workVolumeMapper;
    @Mock UploadDocumentMapper uploadDocumentMapper;
    @Mock AuditLogMapper auditLogMapper;
    @Mock Schema schema;
    @Mock Document xmlDocument;

    private DocumentService documentService;
    private UserEntity uploader;

    private static final byte[] XML_BYTES = "<doc/>".getBytes();
    private static final String FILE_NAME = "test.xml";

    @BeforeEach
    void setUp() {
        documentService = new DocumentService(
                ZoneId.of("Europe/Moscow"),
                xmlMetadataExtractor, xsdCatalogService, xmlValidator,
                constructionObjectRepository, documentTypeRepository,
                documentRepository, documentVersionRepository,
                auditLogRepository, documentParticipantRepository,
                permissionService, workVolumeRepository, participantPersister,
                documentListItemMapper, documentCardAssembler, participantMapper,
                versionInfoMapper, workVolumeMapper, uploadDocumentMapper, auditLogMapper
        );

        uploader = mockUser(1L, "CONTRACTOR");
    }

    // ── 1. Загрузка: невалидный XML ─────────────────────────────────────────

    @Test
    void uploadXml_malformedXml_returnsInvalidXmlStatus() {
        when(xmlMetadataExtractor.parseXml(anyString()))
                .thenThrow(new IllegalArgumentException("Не валидный XML"));
        when(permissionService.canUpload(uploader, "UNKNOWN")).thenReturn(true);
        stubObjectAndType("UNKNOWN");
        when(documentRepository.findByDocumentType_TypeCodeAndDocumentNumber(anyString(), anyString()))
                .thenReturn(Optional.empty());
        stubNewDocumentSave();
        stubVersionSave();
        stubMapperResponse(DocumentValidationStatus.INVALID_XML);

        UploadDocumentResponse response = documentService.uploadXml(XML_BYTES, FILE_NAME, uploader);

        assertThat(response.getValidationStatus()).isEqualTo(DocumentValidationStatus.INVALID_XML);
    }

    // ── 1. Загрузка: неизвестный тип документа ──────────────────────────────

    @Test
    void uploadXml_unknownDocumentType_returnsUnknownTypeStatus() {
        when(xmlMetadataExtractor.parseXml(anyString())).thenReturn(xmlDocument);
        XmlMetadataExtractor.RootQName root = new XmlMetadataExtractor.RootQName("urn:test", "unknown");
        when(xmlMetadataExtractor.extractRootQName(xmlDocument)).thenReturn(root);
        doNothing().when(xmlMetadataExtractor).assertBusinessDocumentRoot(any());
        when(xsdCatalogService.detectDocumentType(root))
                .thenThrow(new XsdCatalogService.UnknownDocumentTypeException("Неизвестный тип"));
        when(permissionService.canUpload(uploader, "UNKNOWN")).thenReturn(true);
        stubObjectAndType("UNKNOWN");
        when(documentRepository.findByDocumentType_TypeCodeAndDocumentNumber(anyString(), anyString()))
                .thenReturn(Optional.empty());
        stubNewDocumentSave();
        stubVersionSave();
        stubMapperResponse(DocumentValidationStatus.INVALID_UNKNOWN_DOCUMENT_TYPE);

        UploadDocumentResponse response = documentService.uploadXml(XML_BYTES, FILE_NAME, uploader);

        assertThat(response.getValidationStatus()).isEqualTo(DocumentValidationStatus.INVALID_UNKNOWN_DOCUMENT_TYPE);
    }

    // ── 1. Загрузка: ошибка XSD-валидации ───────────────────────────────────

    @Test
    void uploadXml_failsXsdValidation_returnsInvalidSchemaStatus() {
        stubParsing("AOOK", "DOC-001");
        when(xsdCatalogService.getSchema(any())).thenReturn(schema);
        when(xmlValidator.validateXml(anyString(), eq(schema)))
                .thenReturn(List.of(new XmlValidator.ValidationError("Ошибка схемы", 5, 10)));
        when(permissionService.canUpload(uploader, "AOOK")).thenReturn(true);
        stubObjectAndType("AOOK");
        when(documentRepository.findByDocumentType_TypeCodeAndDocumentNumber(anyString(), anyString()))
                .thenReturn(Optional.empty());
        stubNewDocumentSave();
        stubVersionSave();
        stubMapperResponse(DocumentValidationStatus.INVALID_SCHEMA);

        UploadDocumentResponse response = documentService.uploadXml(XML_BYTES, FILE_NAME, uploader);

        assertThat(response.getValidationStatus()).isEqualTo(DocumentValidationStatus.INVALID_SCHEMA);
    }

    // ── 2. Парсинг и сохранение: валидный документ ──────────────────────────

    @Test
    void uploadXml_validXml_savesDocumentAndVersion() {
        stubParsing("AOOK", "DOC-001");
        when(xsdCatalogService.getSchema(any())).thenReturn(schema);
        when(xmlValidator.validateXml(anyString(), eq(schema))).thenReturn(Collections.emptyList());
        when(permissionService.canUpload(uploader, "AOOK")).thenReturn(true);
        stubObjectAndType("AOOK");
        when(documentRepository.findByDocumentType_TypeCodeAndDocumentNumber(anyString(), anyString()))
                .thenReturn(Optional.empty());
        stubNewDocumentSave();
        stubVersionSave();
        stubMapperResponse(DocumentValidationStatus.VALID);

        UploadDocumentResponse response = documentService.uploadXml(XML_BYTES, FILE_NAME, uploader);

        assertThat(response.getValidationStatus()).isEqualTo(DocumentValidationStatus.VALID);
        verify(documentRepository, atLeastOnce()).save(any(DocumentEntity.class));
        verify(documentVersionRepository).save(any(DocumentVersionEntity.class));
    }

    // ── 4. Версионность: повторная загрузка создаёт новую версию ────────────

    @Test
    void uploadXml_existingDocument_sameOwner_createsVersion2() {
        stubParsing("AOOK", "DOC-001");
        when(xsdCatalogService.getSchema(any())).thenReturn(schema);
        when(xmlValidator.validateXml(anyString(), eq(schema))).thenReturn(Collections.emptyList());
        when(permissionService.canUpload(uploader, "AOOK")).thenReturn(true);
        stubObjectAndType("AOOK");

        DocumentEntity existingDoc = mockDocument("DOC-001", uploader);
        when(documentRepository.findByDocumentType_TypeCodeAndDocumentNumber(anyString(), eq("DOC-001")))
                .thenReturn(Optional.of(existingDoc));
        when(permissionService.canView(uploader, existingDoc)).thenReturn(true);

        DocumentVersionEntity prevVersion = mock(DocumentVersionEntity.class);
        when(prevVersion.getId()).thenReturn(10L);
        when(prevVersion.getVersionNumber()).thenReturn(1);
        when(documentVersionRepository.findTopByDocument_IdOrderByVersionNumberDesc(50L))
                .thenReturn(Optional.of(prevVersion));
        stubVersionSave();
        stubMapperResponse(DocumentValidationStatus.VALID);

        documentService.uploadXml(XML_BYTES, FILE_NAME, uploader);

        verify(documentVersionRepository).save(argThat(v -> v.getVersionNumber() == 2));
    }

    // ── 3. Ролевой доступ: чужой документ блокируется ───────────────────────

    @Test
    void uploadXml_existingDocument_differentOwner_returnsConflict_withoutSaving() {
        stubParsing("AOOK", "DOC-001");
        when(xsdCatalogService.getSchema(any())).thenReturn(schema);
        when(xmlValidator.validateXml(anyString(), eq(schema))).thenReturn(Collections.emptyList());
        when(permissionService.canUpload(uploader, "AOOK")).thenReturn(true);
        stubObjectAndType("AOOK");

        UserEntity otherUser = mockUser(99L, "CONTRACTOR");
        DocumentEntity existingDoc = mockDocument("DOC-001", otherUser);
        when(documentRepository.findByDocumentType_TypeCodeAndDocumentNumber(anyString(), eq("DOC-001")))
                .thenReturn(Optional.of(existingDoc));
        when(permissionService.canView(uploader, existingDoc)).thenReturn(false);

        UploadDocumentResponse response = documentService.uploadXml(XML_BYTES, FILE_NAME, uploader);

        assertThat(response.getValidationStatus()).isEqualTo(DocumentValidationStatus.INVALID_CONFLICT);
        assertThat(response.getValidationErrors()).isNotEmpty();
        assertThat(response.getValidationErrors().get(0).getMessage()).contains("другим пользователем");
        verify(documentVersionRepository, never()).save(any());
    }

    // ── 5. Аудит-лог: запись после успешной загрузки ────────────────────────

    @Test
    void uploadXml_validXml_writesAuditLog() {
        stubParsing("AOOK", "DOC-001");
        when(xsdCatalogService.getSchema(any())).thenReturn(schema);
        when(xmlValidator.validateXml(anyString(), eq(schema))).thenReturn(Collections.emptyList());
        when(permissionService.canUpload(uploader, "AOOK")).thenReturn(true);
        stubObjectAndType("AOOK");
        when(documentRepository.findByDocumentType_TypeCodeAndDocumentNumber(anyString(), anyString()))
                .thenReturn(Optional.empty());
        stubNewDocumentSave();
        stubVersionSave();
        stubMapperResponse(DocumentValidationStatus.VALID);

        documentService.uploadXml(XML_BYTES, FILE_NAME, uploader);

        verify(auditLogRepository).save(any(AuditLogEntity.class));
    }

    // ── helpers ─────────────────────────────────────────────────────────────

    private void stubParsing(String docType, String docNumber) {
        when(xmlMetadataExtractor.parseXml(anyString())).thenReturn(xmlDocument);
        XmlMetadataExtractor.RootQName root = new XmlMetadataExtractor.RootQName("urn:test", docType.toLowerCase());
        when(xmlMetadataExtractor.extractRootQName(xmlDocument)).thenReturn(root);
        doNothing().when(xmlMetadataExtractor).assertBusinessDocumentRoot(any());
        XsdCatalogService.DocumentTypeMapping mapping =
                new XsdCatalogService.DocumentTypeMapping(docType, "urn:test", docType.toLowerCase(), null, null);
        when(xsdCatalogService.detectDocumentType(root)).thenReturn(mapping);
        when(xmlMetadataExtractor.extractDocumentNumber(xmlDocument)).thenReturn(docNumber);
        when(xmlMetadataExtractor.extractDocumentDate(xmlDocument)).thenReturn(Optional.empty());
        when(xmlMetadataExtractor.extractWorkVolumes(xmlDocument)).thenReturn(Collections.emptyList());
        when(xmlMetadataExtractor.extractPermanentObjectName(xmlDocument)).thenReturn(Optional.empty());
        when(xmlMetadataExtractor.extractPermanentObjectAddressStructured(xmlDocument)).thenReturn(Optional.empty());
        when(xmlMetadataExtractor.extractPermanentObjectUUID(xmlDocument)).thenReturn(Optional.empty());
    }

    private void stubObjectAndType(String typeCode) {
        ConstructionObjectEntity object = mock(ConstructionObjectEntity.class);
        when(object.getId()).thenReturn(10L);
        when(constructionObjectRepository.findByObjectCode(ReferenceDataInitializer.DEFAULT_OBJECT_CODE))
                .thenReturn(Optional.of(object));

        DocumentTypeEntity docType = mock(DocumentTypeEntity.class);
        when(docType.getId()).thenReturn(1L);
        when(docType.getTypeCode()).thenReturn(typeCode);
        when(docType.getTypeName()).thenReturn("Тестовый тип");
        when(documentTypeRepository.findByTypeCode(typeCode)).thenReturn(Optional.of(docType));
    }

    private void stubNewDocumentSave() {
        when(documentRepository.save(any(DocumentEntity.class))).thenAnswer(inv -> inv.getArgument(0));
    }

    private void stubVersionSave() {
        when(documentVersionRepository.save(any(DocumentVersionEntity.class))).thenAnswer(inv -> {
            DocumentVersionEntity v = inv.getArgument(0);
            return v;
        });
    }

    private void stubMapperResponse(DocumentValidationStatus status) {
        UploadDocumentResponse response = new UploadDocumentResponse();
        response.setValidationStatus(status);
        if (status == DocumentValidationStatus.INVALID_CONFLICT) {
            response.setValidationErrors(List.of(
                    new ru.artwell.contractor.dto.ValidationErrorDto("Документ загружен другим пользователем", null, null)
            ));
        }
        when(uploadDocumentMapper.toUploadResponse(any(), any(), anyBoolean(), any(), any()))
                .thenReturn(response);
    }

    private static UserEntity mockUser(Long id, String role) {
        UserEntity u = mock(UserEntity.class);
        when(u.getId()).thenReturn(id);
        when(u.getRole()).thenReturn(role);
        return u;
    }

    private DocumentEntity mockDocument(String number, UserEntity owner) {
        ConstructionObjectEntity object = mock(ConstructionObjectEntity.class);
        when(object.getId()).thenReturn(10L);

        DocumentTypeEntity docType = mock(DocumentTypeEntity.class);
        when(docType.getTypeCode()).thenReturn("AOOK");
        when(docType.getTypeName()).thenReturn("Акт освидетельствования скрытых работ");

        DocumentEntity doc = mock(DocumentEntity.class);
        when(doc.getId()).thenReturn(50L);
        when(doc.getDocumentNumber()).thenReturn(number);
        when(doc.getDocumentType()).thenReturn(docType);
        when(doc.getUploadedBy()).thenReturn(owner);
        when(doc.getConstructionObject()).thenReturn(object);
        when(doc.getCurrentVersion()).thenReturn(1);
        return doc;
    }
}
