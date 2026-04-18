package ru.artwell.contractor.persistence.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import ru.artwell.contractor.persistence.entity.WorkVolumeEntity;

import java.util.List;

public interface WorkVolumeRepository extends JpaRepository<WorkVolumeEntity, Long> {

    List<WorkVolumeEntity> findByDocumentVersion_Id(Long documentVersionId);
}
