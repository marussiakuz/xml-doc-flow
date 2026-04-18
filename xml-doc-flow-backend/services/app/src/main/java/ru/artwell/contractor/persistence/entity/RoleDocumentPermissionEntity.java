package ru.artwell.contractor.persistence.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "role_document_permissions")
public class RoleDocumentPermissionEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "role", nullable = false, length = 64)
    private String role;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "document_type_id", nullable = false)
    private DocumentTypeEntity documentType;

    @Column(name = "can_upload", nullable = false)
    private boolean canUpload;

    @Column(name = "can_view", nullable = false)
    private boolean canView;

    public RoleDocumentPermissionEntity(String role,
                                        DocumentTypeEntity documentType,
                                        boolean canUpload,
                                        boolean canView) {
        this.role = role;
        this.documentType = documentType;
        this.canUpload = canUpload;
        this.canView = canView;
    }

    protected RoleDocumentPermissionEntity() {
    }

    public Long getId() {
        return id;
    }

    public String getRole() {
        return role;
    }

    public DocumentTypeEntity getDocumentType() {
        return documentType;
    }

    public boolean isCanUpload() {
        return canUpload;
    }

    public boolean isCanView() {
        return canView;
    }
}
