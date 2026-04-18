package ru.artwell.contractor.persistence.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import ru.artwell.contractor.persistence.entity.DocumentParticipantEntity;

import java.util.List;

public interface DocumentParticipantRepository extends JpaRepository<DocumentParticipantEntity, Long> {

    @Query("select p from DocumentParticipantEntity p left join fetch p.organization where p.documentVersion.id = :versionId")
    List<DocumentParticipantEntity> findByDocumentVersion_Id(@Param("versionId") Long versionId);

    @Query("select p from DocumentParticipantEntity p left join fetch p.organization where p.documentVersion.document.id = :documentId")
    List<DocumentParticipantEntity> findByDocumentVersion_Document_Id(@Param("documentId") Long documentId);
}
