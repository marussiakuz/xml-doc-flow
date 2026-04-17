package ru.artwell.contractor.persistence.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import ru.artwell.contractor.persistence.entity.DocumentVersionEntity;

import java.util.List;
import java.util.Optional;

public interface DocumentVersionRepository extends JpaRepository<DocumentVersionEntity, Long> {

    Optional<DocumentVersionEntity> findTopByDocument_IdOrderByVersionNumberDesc(Long documentId);

    List<DocumentVersionEntity> findByDocument_IdOrderByVersionNumberDesc(Long documentId);

    Optional<DocumentVersionEntity> findByDocument_IdAndVersionNumber(Long documentId, int versionNumber);

    @Query("""
            select v from DocumentVersionEntity v
            join fetch v.document d
            join fetch d.documentType
            where v.id = :id
            """)
    Optional<DocumentVersionEntity> findByIdWithDocument(@Param("id") Long id);

    @Query("SELECT v.id FROM DocumentVersionEntity v WHERE v.document.id = :documentId")
    List<Long> findIdsByDocumentId(@Param("documentId") Long documentId);
}
