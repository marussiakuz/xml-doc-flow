package ru.artwell.contractor.persistence.entity;

import jakarta.persistence.*;

import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(
        name = "xml_documents",
        uniqueConstraints = {
                @UniqueConstraint(name = "uk_document_group_version", columnNames = {"group_id", "version"})
        },
        indexes = {
                @Index(name = "idx_document_group", columnList = "group_id"),
                @Index(name = "idx_document_type_number", columnList = "doc_type,document_number")
        }
)
public class XmlDocumentEntity {

    @Id
    @GeneratedValue
    private UUID id;

    @Column(name = "group_id", nullable = false)
    private UUID groupId;

    @Column(name = "doc_type", nullable = false, length = 256)
    private String docType;

    @Column(name = "document_number", nullable = false, length = 256)
    private String documentNumber;

    @Column(name = "version", nullable = false)
    private int version;

    @Lob
    @Column(name = "xml_content", nullable = false)
    private byte[] xmlContent;

    @Column(name = "uploaded_at", nullable = false)
    private LocalDateTime uploadedAt;

    @Column(name = "previous_version_id")
    private UUID previousVersionId;

    protected XmlDocumentEntity() {
    }

    public XmlDocumentEntity(UUID groupId,
                               String docType,
                               String documentNumber,
                               int version,
                               byte[] xmlContent,
                               LocalDateTime uploadedAt,
                               UUID previousVersionId) {
        this.groupId = groupId;
        this.docType = docType;
        this.documentNumber = documentNumber;
        this.version = version;
        this.xmlContent = xmlContent;
        this.uploadedAt = uploadedAt;
        this.previousVersionId = previousVersionId;
    }

    public UUID getId() {
        return id;
    }

    public UUID getGroupId() {
        return groupId;
    }

    public String getDocType() {
        return docType;
    }

    public String getDocumentNumber() {
        return documentNumber;
    }

    public int getVersion() {
        return version;
    }

    public byte[] getXmlContent() {
        return xmlContent;
    }

    public LocalDateTime getUploadedAt() {
        return uploadedAt;
    }

    public UUID getPreviousVersionId() {
        return previousVersionId;
    }
}

