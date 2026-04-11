package ru.artwell.contractor.persistence.entity;

import jakarta.persistence.*;

import java.time.LocalDateTime;

@Entity
@Table(
        name = "document_versions",
        uniqueConstraints = @UniqueConstraint(
                name = "uk_document_versions_doc_version",
                columnNames = {"document_id", "version_number"}
        ),
        indexes = {
                @Index(name = "idx_document_versions_document", columnList = "document_id"),
                @Index(name = "idx_document_versions_previous", columnList = "previous_version_id")
        }
)
public class DocumentVersionEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "document_id", nullable = false)
    private DocumentEntity document;

    @Column(name = "version_number", nullable = false)
    private int versionNumber;

    /**
     * Устарело: относительный путь к файлу на диске. В старых БД колонка {@code xml_file_path} остаётся NOT NULL —
     * при вставке пишем пустую строку. После {@code ALTER TABLE ... DROP COLUMN xml_file_path} поле удалить.
     */
    @Column(name = "xml_file_path", nullable = false, length = 2048)
    private String xmlFilePath = "";

    @Column(name = "xml_content", columnDefinition = "bytea")
    private byte[] xmlContent;

    @Column(name = "xml_file_name", nullable = false, length = 512)
    private String xmlFileName;

    @Column(name = "xml_file_size", nullable = false)
    private long xmlFileSize;

    @Column(name = "validation_status", nullable = false, length = 32)
    private VersionValidationStatus validationStatus;

    @Column(name = "validation_errors", columnDefinition = "text")
    private String validationErrors;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "uploaded_by", nullable = false)
    private UserEntity uploadedBy;

    @Column(name = "uploaded_at", nullable = false)
    private LocalDateTime uploadedAt;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "previous_version_id")
    private DocumentVersionEntity previousVersion;

    protected DocumentVersionEntity() {
    }

    public DocumentVersionEntity(DocumentEntity document,
                               int versionNumber,
                               byte[] xmlContent,
                               String xmlFileName,
                               long xmlFileSize,
                               VersionValidationStatus validationStatus,
                               String validationErrors,
                               UserEntity uploadedBy,
                               LocalDateTime uploadedAt,
                               DocumentVersionEntity previousVersion) {
        this.document = document;
        this.versionNumber = versionNumber;
        this.xmlFilePath = "";
        this.xmlContent = xmlContent;
        this.xmlFileName = xmlFileName;
        this.xmlFileSize = xmlFileSize;
        this.validationStatus = validationStatus;
        this.validationErrors = validationErrors;
        this.uploadedBy = uploadedBy;
        this.uploadedAt = uploadedAt;
        this.previousVersion = previousVersion;
    }

    public Long getId() {
        return id;
    }

    public DocumentEntity getDocument() {
        return document;
    }

    public int getVersionNumber() {
        return versionNumber;
    }

    public byte[] getXmlContent() {
        return xmlContent;
    }

    public String getXmlFileName() {
        return xmlFileName;
    }

    public long getXmlFileSize() {
        return xmlFileSize;
    }

    public VersionValidationStatus getValidationStatus() {
        return validationStatus;
    }

    public String getValidationErrors() {
        return validationErrors;
    }

    public LocalDateTime getUploadedAt() {
        return uploadedAt;
    }

    public DocumentVersionEntity getPreviousVersion() {
        return previousVersion;
    }
}
