package ru.artwell.contractor.persistence.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import ru.artwell.contractor.persistence.entity.AuditLogEntity;

import java.util.Collection;

public interface AuditLogRepository extends JpaRepository<AuditLogEntity, Long> {

    /** События по документу (прямые) и по всем его версиям. */
    @Query("""
            SELECT a FROM AuditLogEntity a
            WHERE (a.entityType = 'DOCUMENT' AND a.entityId = :docId)
               OR (a.entityType = 'VERSION'  AND a.entityId IN :versionIds)
            ORDER BY a.createdAt DESC
            """)
    Page<AuditLogEntity> findDocumentHistory(
            @Param("docId") Long documentId,
            @Param("versionIds") Collection<Long> versionIds,
            Pageable pageable);

    /** События только по документу (когда версий ещё нет). */
    @Query("""
            SELECT a FROM AuditLogEntity a
            WHERE a.entityType = 'DOCUMENT' AND a.entityId = :docId
            ORDER BY a.createdAt DESC
            """)
    Page<AuditLogEntity> findByDocumentId(
            @Param("docId") Long documentId,
            Pageable pageable);

    Page<AuditLogEntity> findAllByOrderByCreatedAtDesc(Pageable pageable);
}
