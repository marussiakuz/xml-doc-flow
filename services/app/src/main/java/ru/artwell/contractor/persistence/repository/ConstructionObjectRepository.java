package ru.artwell.contractor.persistence.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import ru.artwell.contractor.persistence.entity.ConstructionObjectEntity;

import java.util.Optional;

public interface ConstructionObjectRepository extends JpaRepository<ConstructionObjectEntity, Long> {

    Optional<ConstructionObjectEntity> findByObjectCode(String objectCode);

    Optional<ConstructionObjectEntity> findByPermanentObjectUuid(String permanentObjectUuid);
}
