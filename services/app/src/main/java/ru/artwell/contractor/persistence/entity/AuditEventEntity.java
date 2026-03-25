package ru.artwell.contractor.persistence.entity;

import jakarta.persistence.*;

import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "audit_events", indexes = @Index(name = "idx_audit_document", columnList = "document_id"))
public class AuditEventEntity {

    @Id
    @GeneratedValue
    private UUID id;

    @Column(name = "event_at", nullable = false)
    private LocalDateTime eventAt;

    @Column(name = "event_type", nullable = false, length = 64)
    private String eventType;

    @Column(name = "actor", nullable = false, length = 128)
    private String actor;

    @Column(name = "document_id")
    private UUID documentId;

    @Column(name = "document_group_id")
    private UUID documentGroupId;

    @Column(name = "details", length = 4000)
    private String details;

    protected AuditEventEntity() {
    }

    public AuditEventEntity(LocalDateTime eventAt,
                             String eventType,
                             String actor,
                             UUID documentId,
                             UUID documentGroupId,
                             String details) {
        this.eventAt = eventAt;
        this.eventType = eventType;
        this.actor = actor;
        this.documentId = documentId;
        this.documentGroupId = documentGroupId;
        this.details = details;
    }

    public UUID getId() {
        return id;
    }
}

