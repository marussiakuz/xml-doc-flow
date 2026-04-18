package ru.artwell.contractor.persistence.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import ru.artwell.contractor.persistence.entity.RoleAssignmentHistoryEntity;

public interface RoleAssignmentHistoryRepository extends JpaRepository<RoleAssignmentHistoryEntity, Long> {
}
