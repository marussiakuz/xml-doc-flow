package ru.artwell.contractor.persistence.entity;

import jakarta.persistence.*;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(
        name = "documents",
        uniqueConstraints = @UniqueConstraint(
                name = "uk_documents_type_number",
                columnNames = {"document_type_id", "document_number"}
        ),
        indexes = {
                @Index(name = "idx_documents_construction_object", columnList = "construction_object_id"),
                @Index(name = "idx_documents_uploaded_by", columnList = "uploaded_by")
        }
)
public class DocumentEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "document_number", nullable = false, length = 512)
    private String documentNumber;

    @Column(name = "document_date")
    private LocalDate documentDate;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "document_type_id", nullable = false)
    private DocumentTypeEntity documentType;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "construction_object_id", nullable = false)
    private ConstructionObjectEntity constructionObject;

    @Column(name = "title", length = 1024)
    private String title;

    @Column(name = "current_version", nullable = false)
    private int currentVersion;

    @Column(name = "is_latest_version", nullable = false)
    private boolean latestVersion = true;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "uploaded_by", nullable = false)
    private UserEntity uploadedBy;

    @Column(name = "uploaded_at", nullable = false)
    private LocalDateTime uploadedAt;

    @Column(name = "status", nullable = false, length = 32)
    private String status = "active";

    protected DocumentEntity() {
    }

    public DocumentEntity(String documentNumber,
                          LocalDate documentDate,
                          DocumentTypeEntity documentType,
                          ConstructionObjectEntity constructionObject,
                          String title,
                          int currentVersion,
                          boolean latestVersion,
                          UserEntity uploadedBy,
                          LocalDateTime uploadedAt,
                          String status) {
        this.documentNumber = documentNumber;
        this.documentDate = documentDate;
        this.documentType = documentType;
        this.constructionObject = constructionObject;
        this.title = title;
        this.currentVersion = currentVersion;
        this.latestVersion = latestVersion;
        this.uploadedBy = uploadedBy;
        this.uploadedAt = uploadedAt;
        this.status = status;
    }

    public Long getId() {
        return id;
    }

    public String getDocumentNumber() {
        return documentNumber;
    }

    public DocumentTypeEntity getDocumentType() {
        return documentType;
    }

    public int getCurrentVersion() {
        return currentVersion;
    }

    public void setCurrentVersion(int currentVersion) {
        this.currentVersion = currentVersion;
    }

    public void setUploadedAt(LocalDateTime uploadedAt) {
        this.uploadedAt = uploadedAt;
    }

    public void setDocumentDate(LocalDate documentDate) {
        this.documentDate = documentDate;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public void setUploadedBy(UserEntity uploadedBy) {
        this.uploadedBy = uploadedBy;
    }

    public ConstructionObjectEntity getConstructionObject() {
        return constructionObject;
    }

    public LocalDateTime getUploadedAt() {
        return uploadedAt;
    }
}
