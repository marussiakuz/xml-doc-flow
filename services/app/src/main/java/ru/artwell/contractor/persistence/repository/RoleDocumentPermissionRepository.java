package ru.artwell.contractor.persistence.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import ru.artwell.contractor.persistence.entity.RoleDocumentPermissionEntity;

import java.util.List;
import java.util.Optional;

public interface RoleDocumentPermissionRepository extends JpaRepository<RoleDocumentPermissionEntity, Long> {

    Optional<RoleDocumentPermissionEntity> findByRoleAndDocumentType_TypeCode(String role, String documentTypeCode);

    List<RoleDocumentPermissionEntity> findByRole(String role);

    boolean existsByRoleAndDocumentType_TypeCodeAndCanUploadTrue(String role, String documentTypeCode);
}
