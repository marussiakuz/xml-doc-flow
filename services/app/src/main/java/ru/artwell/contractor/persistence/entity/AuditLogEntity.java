package ru.artwell.contractor.persistence.entity;

import jakarta.persistence.*;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

import java.time.LocalDateTime;
import java.util.Map;

@Entity
@Table(name = "audit_log", indexes = @Index(name = "idx_audit_log_entity", columnList = "entity_type,entity_id"))
public class AuditLogEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    private UserEntity user;

    @Column(name = "username", length = 128)
    private String username;

    @Column(name = "action_type", nullable = false, length = 64)
    private String actionType;

    @Column(name = "entity_type", length = 64)
    private String entityType;

    @Column(name = "entity_id")
    private Long entityId;

    @JdbcTypeCode(SqlTypes.JSON)
    @Column(name = "action_details", columnDefinition = "jsonb")
    private Map<String, Object> actionDetails;

    @Column(name = "ip_address", length = 64)
    private String ipAddress;

    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt;

    protected AuditLogEntity() {
    }

    public AuditLogEntity(UserEntity user,
                          String username,
                          String actionType,
                          String entityType,
                          Long entityId,
                          Map<String, Object> actionDetails,
                          String ipAddress,
                          LocalDateTime createdAt) {
        this.user = user;
        this.username = username;
        this.actionType = actionType;
        this.entityType = entityType;
        this.entityId = entityId;
        this.actionDetails = actionDetails;
        this.ipAddress = ipAddress;
        this.createdAt = createdAt;
    }
}
