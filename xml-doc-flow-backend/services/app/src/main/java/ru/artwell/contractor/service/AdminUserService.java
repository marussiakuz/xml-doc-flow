package ru.artwell.contractor.service;

import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ru.artwell.contractor.config.AppTimeConfiguration;
import ru.artwell.contractor.dto.admin.CreateUserRequest;
import ru.artwell.contractor.dto.admin.UpdateUserRequest;
import ru.artwell.contractor.dto.admin.UserAdminResponse;
import ru.artwell.contractor.mapper.UserPresentationMapper;
import ru.artwell.contractor.persistence.entity.AuditLogEntity;
import ru.artwell.contractor.persistence.entity.OrganizationEntity;
import ru.artwell.contractor.persistence.entity.RoleAssignmentHistoryEntity;
import ru.artwell.contractor.persistence.entity.UserEntity;
import ru.artwell.contractor.persistence.repository.AuditLogRepository;
import ru.artwell.contractor.persistence.repository.OrganizationRepository;
import ru.artwell.contractor.persistence.repository.RoleAssignmentHistoryRepository;
import ru.artwell.contractor.persistence.repository.UserRepository;
import ru.artwell.contractor.security.AppRole;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Map;

@Service
public class AdminUserService {

    private final UserRepository userRepository;
    private final OrganizationRepository organizationRepository;
    private final PasswordEncoder passwordEncoder;
    private final AuditLogRepository auditLogRepository;
    private final RoleAssignmentHistoryRepository roleAssignmentHistoryRepository;
    @Qualifier(AppTimeConfiguration.APPLICATION_ZONE_ID)
    private final ZoneId applicationZoneId;
    private final UserPresentationMapper userPresentationMapper;

    public AdminUserService(UserRepository userRepository,
                            OrganizationRepository organizationRepository,
                            PasswordEncoder passwordEncoder,
                            AuditLogRepository auditLogRepository,
                            RoleAssignmentHistoryRepository roleAssignmentHistoryRepository,
                            @Qualifier(AppTimeConfiguration.APPLICATION_ZONE_ID) ZoneId applicationZoneId,
                            UserPresentationMapper userPresentationMapper) {
        this.userRepository = userRepository;
        this.organizationRepository = organizationRepository;
        this.passwordEncoder = passwordEncoder;
        this.auditLogRepository = auditLogRepository;
        this.roleAssignmentHistoryRepository = roleAssignmentHistoryRepository;
        this.applicationZoneId = applicationZoneId;
        this.userPresentationMapper = userPresentationMapper;
    }

    @Transactional
    public UserAdminResponse createUser(CreateUserRequest request, UserEntity admin) {
        if (userRepository.existsByUsername(request.username())) {
            throw new IllegalArgumentException("Username already exists: " + request.username());
        }

        OrganizationEntity org = null;
        if (request.organizationId() != null) {
            org = organizationRepository.findById(request.organizationId())
                    .orElseThrow(() -> new IllegalArgumentException("Organization not found"));
        }

        UserEntity user = new UserEntity(
                request.username(),
                passwordEncoder.encode(request.password()),
                request.fullName(),
                request.role().name(),
                org,
                request.email(),
                true
        );

        UserEntity saved = userRepository.save(user);

        auditLogRepository.save(new AuditLogEntity(
                admin, admin.getUsername(), "USER_CREATED", "USER", saved.getId(),
                Map.of("username", saved.getUsername(), "role", saved.getRole()),
                null, LocalDateTime.now(applicationZoneId)
        ));

        return userPresentationMapper.toUserAdminResponse(saved);
    }

    @Transactional(readOnly = true)
    public Page<UserAdminResponse> listUsers(String role, Pageable pageable) {
        Page<UserEntity> page;
        AppRole filter = parseRoleFilter(role);
        if (filter != null) {
            page = userRepository.findByRole(filter.name(), pageable);
        } else {
            page = userRepository.findAllActive(pageable);
        }
        return page.map(userPresentationMapper::toUserAdminResponse);
    }

    /**
     * {@code null} или пустая строка — без фильтра по роли; иначе только {@link AppRole}.
     */
    private static AppRole parseRoleFilter(String role) {
        if (role == null || role.isBlank()) {
            return null;
        }
        try {
            return AppRole.valueOf(role.trim());
        } catch (IllegalArgumentException e) {
            throw new IllegalArgumentException("Unknown role: " + role + ". Allowed: ADMIN, CONTRACTOR, CUSTOMER");
        }
    }

    @Transactional(readOnly = true)
    public UserAdminResponse getUser(Long id) {
        UserEntity user = userRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("User not found: " + id));
        return userPresentationMapper.toUserAdminResponse(user);
    }

    @Transactional
    public UserAdminResponse updateUser(Long id, UpdateUserRequest request, UserEntity admin) {
        UserEntity user = userRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("User not found: " + id));

        String previousRole = user.getRole();

        if (user.getId().equals(admin.getId()) && request.role() != null
                && !request.role().name().equals(user.getRole())) {
            throw new AccessDeniedException("Cannot change your own role");
        }

        if (request.fullName() != null) {
            user.setFullName(request.fullName());
        }
        if (request.role() != null) {
            user.setRole(request.role().name());
        }
        if (request.active() != null) {
            user.setActive(request.active());
        }
        if (request.email() != null) {
            user.setEmail(request.email());
        }
        if (request.organizationId() != null) {
            OrganizationEntity org = organizationRepository.findById(request.organizationId()).orElse(null);
            user.setOrganization(org);
        }

        UserEntity saved = userRepository.save(user);

        if (request.role() != null && !request.role().name().equals(previousRole)) {
            roleAssignmentHistoryRepository.save(new RoleAssignmentHistoryEntity(
                    saved,
                    previousRole,
                    request.role().name(),
                    admin,
                    LocalDateTime.now(applicationZoneId)
            ));
        }

        auditLogRepository.save(new AuditLogEntity(
                admin, admin.getUsername(), "USER_UPDATED", "USER", saved.getId(),
                Map.of("username", saved.getUsername(), "changes", request),
                null, LocalDateTime.now(applicationZoneId)
        ));

        return userPresentationMapper.toUserAdminResponse(saved);
    }

    @Transactional
    public void deleteUser(Long id, UserEntity admin) {
        UserEntity user = userRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("User not found: " + id));

        if (user.getId().equals(admin.getId())) {
            throw new AccessDeniedException("Cannot delete your own account");
        }

        user.setActive(false);
        userRepository.save(user);

        auditLogRepository.save(new AuditLogEntity(
                admin, admin.getUsername(), "USER_DELETED", "USER", id,
                Map.of("username", user.getUsername()),
                null, LocalDateTime.now(applicationZoneId)
        ));
    }

    @Transactional
    public void resetPassword(Long id, String newPassword, UserEntity admin) {
        UserEntity user = userRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("User not found: " + id));

        user.setPasswordHash(passwordEncoder.encode(newPassword));
        userRepository.save(user);

        auditLogRepository.save(new AuditLogEntity(
                admin, admin.getUsername(), "PASSWORD_RESET", "USER", id,
                Map.of("username", user.getUsername()),
                null, LocalDateTime.now(applicationZoneId)
        ));
    }
}

