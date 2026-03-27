package ru.artwell.contractor.persistence.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import ru.artwell.contractor.persistence.entity.XmlDocumentEntity;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface XmlDocumentRepository extends JpaRepository<XmlDocumentEntity, UUID> {

    Optional<XmlDocumentEntity> findTopByDocTypeAndDocumentNumberOrderByVersionDesc(String docType, UUID documentNumber);

    Optional<XmlDocumentEntity> findTopByGroupIdOrderByVersionDesc(UUID groupId);

    List<XmlDocumentEntity> findByGroupIdOrderByVersionDesc(UUID groupId);

    @Query("""
        select d from XmlDocumentEntity d
        where d.version = (
            select max(d2.version) from XmlDocumentEntity d2 where d2.groupId = d.groupId
        )
        and (:docType is null or d.docType = :docType)
        and (:documentNumber is null or d.documentNumber = :documentNumber)
        order by d.uploadedAt desc
    """)
    List<XmlDocumentEntity> findLatestVersions(String docType, UUID documentNumber);
}

