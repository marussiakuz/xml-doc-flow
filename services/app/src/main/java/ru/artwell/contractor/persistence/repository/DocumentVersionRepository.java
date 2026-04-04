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

    @Query("""
            select v from DocumentVersionEntity v
            join fetch v.document d
            join fetch d.documentType
            where v.versionNumber = d.currentVersion
            and (:typeCode is null or d.documentType.typeCode = :typeCode)
            and (:docNum is null or d.documentNumber = :docNum)
            order by v.uploadedAt desc
            """)
    List<DocumentVersionEntity> findCurrentVersions(
            @Param("typeCode") String typeCode,
            @Param("docNum") String documentNumber
    );

    @Query("""
            select v from DocumentVersionEntity v
            join fetch v.document d
            join fetch d.documentType
            where v.id = :id
            """)
    Optional<DocumentVersionEntity> findByIdWithDocument(@Param("id") Long id);
}
