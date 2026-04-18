package ru.artwell.contractor.service;

import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import ru.artwell.contractor.persistence.entity.DocumentEntity;
import ru.artwell.contractor.persistence.entity.UserEntity;
import ru.artwell.contractor.persistence.repository.RoleDocumentPermissionRepository;
import ru.artwell.contractor.persistence.repository.UserObjectAccessRepository;

import java.util.Set;

@Service
public class PermissionService {

    private static final String ROLE_ADMIN = "ADMIN";
    private static final String ROLE_CONTRACTOR = "CONTRACTOR";
    private static final String ROLE_CUSTOMER = "CUSTOMER";

    private final RoleDocumentPermissionRepository permissionRepository;
    private final UserObjectAccessRepository userObjectAccessRepository;

    public PermissionService(RoleDocumentPermissionRepository permissionRepository,
                             UserObjectAccessRepository userObjectAccessRepository) {
        this.permissionRepository = permissionRepository;
        this.userObjectAccessRepository = userObjectAccessRepository;
    }

    /**
     * ADMIN — всегда; CONTRACTOR — по {@code role_document_permissions.can_upload};
     * CUSTOMER — не загружает.
     */
    public boolean canUpload(UserEntity user, String documentTypeCode) {
        if (user == null) {
            return false;
        }
        if (ROLE_ADMIN.equals(user.getRole())) {
            return true;
        }
        if (!ROLE_CONTRACTOR.equals(user.getRole())) {
            return false;
        }
        if (documentTypeCode == null || documentTypeCode.isBlank() || "UNKNOWN".equals(documentTypeCode)) {
            return true;
        }
        return permissionRepository.existsByRoleAndDocumentType_TypeCodeAndCanUploadTrue(user.getRole(), documentTypeCode);
    }

    /**
     * ADMIN — все; CONTRACTOR — только документы, загруженные им; CUSTOMER — объекты из {@code user_object_access}.
     */
    public boolean canView(UserEntity user, DocumentEntity document) {
        if (user == null || document == null || document.getConstructionObject() == null) {
            return false;
        }
        if (ROLE_ADMIN.equals(user.getRole())) {
            return true;
        }
        if (ROLE_CONTRACTOR.equals(user.getRole())) {
            return document.getUploadedBy() != null
                    && document.getUploadedBy().getId().equals(user.getId());
        }
        if (ROLE_CUSTOMER.equals(user.getRole())) {
            return userObjectAccessRepository.existsByUser_IdAndConstructionObject_Id(
                    user.getId(),
                    document.getConstructionObject().getId()
            );
        }
        return false;
    }

    /**
     * Спецификация видимости для списка документов.
     * {@code null} — без ограничения (ADMIN).
     */
    public Specification<DocumentEntity> getVisibilitySpecification(UserEntity currentUser) {
        if (currentUser == null) {
            return (root, query, cb) -> cb.disjunction();
        }
        String role = currentUser.getRole();
        if (ROLE_ADMIN.equals(role)) {
            return null;
        }
        if (ROLE_CONTRACTOR.equals(role)) {
            return (root, query, cb) -> cb.equal(root.get("uploadedBy").get("id"), currentUser.getId());
        }
        if (ROLE_CUSTOMER.equals(role)) {
            Set<Long> accessibleObjectIds = userObjectAccessRepository.findConstructionObjectIdsByUserId(currentUser.getId());
            if (accessibleObjectIds.isEmpty()) {
                return (root, query, cb) -> cb.disjunction();
            }
            return (root, query, cb) -> root.get("constructionObject").get("id").in(accessibleObjectIds);
        }
        return (root, query, cb) -> cb.disjunction();
    }
}
