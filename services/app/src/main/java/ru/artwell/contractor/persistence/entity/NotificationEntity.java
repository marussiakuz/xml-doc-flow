package ru.artwell.contractor.persistence.entity;

import jakarta.persistence.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "notifications")
public class NotificationEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "user_id", nullable = false)
    private UserEntity user;

    @Column(name = "notification_type", length = 64)
    private String notificationType;

    @Column(name = "title", length = 512)
    private String title;

    @Column(name = "message", columnDefinition = "text")
    private String message;

    @Column(name = "is_read", nullable = false)
    private boolean readByUser;

    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt;

    protected NotificationEntity() {
    }
}
