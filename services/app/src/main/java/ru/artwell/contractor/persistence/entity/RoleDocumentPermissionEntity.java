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

    @Column(name = "can_edit", nullable = false)
    private boolean canEdit;

    @Column(name = "can_delete", nullable = false)
    private boolean canDelete;

    @Column(name = "can_approve", nullable = false)
    private boolean canApprove;

    protected RoleDocumentPermissionEntity() {
    }
}
