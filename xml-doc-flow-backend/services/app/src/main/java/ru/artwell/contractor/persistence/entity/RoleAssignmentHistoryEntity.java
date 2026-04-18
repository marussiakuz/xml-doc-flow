package ru.artwell.contractor.persistence.entity;

import jakarta.persistence.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "role_assignment_history")
public class RoleAssignmentHistoryEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "user_id", nullable = false)
    private UserEntity user;

    @Column(name = "old_role", length = 64)
    private String oldRole;

    @Column(name = "new_role", length = 64)
    private String newRole;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "changed_by")
    private UserEntity changedBy;

    @Column(name = "changed_at", nullable = false)
    private LocalDateTime changedAt;

    protected RoleAssignmentHistoryEntity() {
    }

    public RoleAssignmentHistoryEntity(UserEntity user,
                                       String oldRole,
                                       String newRole,
                                       UserEntity changedBy,
                                       LocalDateTime changedAt) {
        this.user = user;
        this.oldRole = oldRole;
        this.newRole = newRole;
        this.changedBy = changedBy;
        this.changedAt = changedAt;
    }
}
