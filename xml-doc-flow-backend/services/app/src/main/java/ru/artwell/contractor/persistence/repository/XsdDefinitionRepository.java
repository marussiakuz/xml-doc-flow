package ru.artwell.contractor.persistence.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import ru.artwell.contractor.persistence.entity.XsdDefinitionEntity;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface XsdDefinitionRepository extends JpaRepository<XsdDefinitionEntity, UUID> {

    Optional<XsdDefinitionEntity> findByXsdResourcePath(String xsdResourcePath);

    List<XsdDefinitionEntity> findByNamespaceUri(String namespaceUri);
}

