package ru.artwell.contractor.service;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.mockito.junit.jupiter.MockitoSettings;
import org.mockito.quality.Strictness;
import ru.artwell.contractor.persistence.entity.ConstructionObjectEntity;
import ru.artwell.contractor.persistence.entity.DocumentEntity;
import ru.artwell.contractor.persistence.entity.UserEntity;
import ru.artwell.contractor.persistence.repository.RoleDocumentPermissionRepository;
import ru.artwell.contractor.persistence.repository.UserObjectAccessRepository;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
@MockitoSettings(strictness = Strictness.LENIENT)
class PermissionServiceTest {

    @Mock RoleDocumentPermissionRepository permissionRepository;
    @Mock UserObjectAccessRepository userObjectAccessRepository;

    private PermissionService permissionService;

    private UserEntity admin;
    private UserEntity contractor;
    private UserEntity otherContractor;
    private UserEntity customer;
    private DocumentEntity document;

    @BeforeEach
    void setUp() {
        permissionService = new PermissionService(permissionRepository, userObjectAccessRepository);

        admin = user(1L, "ADMIN");
        contractor = user(2L, "CONTRACTOR");
        otherContractor = user(3L, "CONTRACTOR");
        customer = user(4L, "CUSTOMER");

        ConstructionObjectEntity object = mock(ConstructionObjectEntity.class);
        when(object.getId()).thenReturn(10L);

        document = mock(DocumentEntity.class);
        when(document.getId()).thenReturn(100L);
        when(document.getUploadedBy()).thenReturn(contractor);
        when(document.getConstructionObject()).thenReturn(object);
    }

    // --- canView ---

    @Test
    void admin_canViewAnyDocument() {
        assertThat(permissionService.canView(admin, document)).isTrue();
    }

    @Test
    void contractor_canViewOwnDocument() {
        assertThat(permissionService.canView(contractor, document)).isTrue();
    }

    @Test
    void contractor_cannotViewOthersDocument() {
        assertThat(permissionService.canView(otherContractor, document)).isFalse();
    }

    @Test
    void customer_canViewDocumentWithObjectAccess() {
        when(userObjectAccessRepository.existsByUser_IdAndConstructionObject_Id(4L, 10L)).thenReturn(true);
        assertThat(permissionService.canView(customer, document)).isTrue();
    }

    @Test
    void customer_cannotViewDocumentWithoutObjectAccess() {
        when(userObjectAccessRepository.existsByUser_IdAndConstructionObject_Id(4L, 10L)).thenReturn(false);
        assertThat(permissionService.canView(customer, document)).isFalse();
    }

    @Test
    void nullUser_cannotViewDocument() {
        assertThat(permissionService.canView(null, document)).isFalse();
    }

    @Test
    void nullDocument_cannotView() {
        assertThat(permissionService.canView(contractor, null)).isFalse();
    }

    // --- canUpload ---

    @Test
    void admin_canUploadAnyType() {
        assertThat(permissionService.canUpload(admin, "AOOK")).isTrue();
    }

    @Test
    void customer_cannotUpload() {
        assertThat(permissionService.canUpload(customer, "AOOK")).isFalse();
    }

    @Test
    void contractor_canUploadWithPermission() {
        when(permissionRepository.existsByRoleAndDocumentType_TypeCodeAndCanUploadTrue("CONTRACTOR", "AOOK"))
                .thenReturn(true);
        assertThat(permissionService.canUpload(contractor, "AOOK")).isTrue();
    }

    @Test
    void contractor_cannotUploadWithoutPermission() {
        when(permissionRepository.existsByRoleAndDocumentType_TypeCodeAndCanUploadTrue("CONTRACTOR", "AOOK"))
                .thenReturn(false);
        assertThat(permissionService.canUpload(contractor, "AOOK")).isFalse();
    }

    @Test
    void contractor_canUploadUnknownType() {
        assertThat(permissionService.canUpload(contractor, "UNKNOWN")).isTrue();
    }

    @Test
    void nullUser_cannotUpload() {
        assertThat(permissionService.canUpload(null, "AOOK")).isFalse();
    }

    private static UserEntity user(Long id, String role) {
        UserEntity u = mock(UserEntity.class);
        when(u.getId()).thenReturn(id);
        when(u.getRole()).thenReturn(role);
        return u;
    }
}
