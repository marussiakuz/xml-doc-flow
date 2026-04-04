package ru.artwell.contractor.persistence.entity;

import jakarta.persistence.*;

import java.time.LocalDateTime;

/**
 * Пользователь. Поле {@code additional_roles varchar[]} из целевой схемы пока не маппится: в Hibernate 6.2
 * {@code @JdbcTypeCode(ARRAY)} для {@code String[]} приводит к NPE при INSERT; вернём при внедрении ролей.
 */
@Entity
@Table(name = "users")
public class UserEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "username", nullable = false, unique = true, length = 128)
    private String username;

    @Column(name = "password_hash", nullable = false, length = 256)
    private String passwordHash;

    @Column(name = "full_name", length = 512)
    private String fullName;

    @Column(name = "role", length = 64)
    private String role;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "organization_id")
    private OrganizationEntity organization;

    @Column(name = "email", length = 256)
    private String email;

    @Column(name = "is_active", nullable = false)
    private boolean active = true;

    @Column(name = "last_login")
    private LocalDateTime lastLogin;

    protected UserEntity() {
    }

    public UserEntity(String username,
                      String passwordHash,
                      String fullName,
                      String role,
                      OrganizationEntity organization,
                      String email,
                      boolean active) {
        this.username = username;
        this.passwordHash = passwordHash;
        this.fullName = fullName;
        this.role = role;
        this.organization = organization;
        this.email = email;
        this.active = active;
    }

    public Long getId() {
        return id;
    }

    public String getUsername() {
        return username;
    }
}
