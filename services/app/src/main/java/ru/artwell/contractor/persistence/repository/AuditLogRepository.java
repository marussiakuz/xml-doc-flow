package ru.artwell.contractor.persistence.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import ru.artwell.contractor.persistence.entity.AuditLogEntity;

public interface AuditLogRepository extends JpaRepository<AuditLogEntity, Long> {
}
