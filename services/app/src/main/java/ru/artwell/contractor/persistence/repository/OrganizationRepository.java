package ru.artwell.contractor.persistence.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import ru.artwell.contractor.persistence.entity.OrganizationEntity;

public interface OrganizationRepository extends JpaRepository<OrganizationEntity, Long> {
}
