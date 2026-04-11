package ru.artwell.contractor.persistence.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import ru.artwell.contractor.persistence.entity.DocumentEntity;

import java.util.Optional;

public interface DocumentRepository extends JpaRepository<DocumentEntity, Long>, JpaSpecificationExecutor<DocumentEntity> {

    Optional<DocumentEntity> findByDocumentType_TypeCodeAndDocumentNumber(String typeCode, String documentNumber);
}
