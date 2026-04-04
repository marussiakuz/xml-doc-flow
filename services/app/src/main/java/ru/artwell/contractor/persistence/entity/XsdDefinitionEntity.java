package ru.artwell.contractor.persistence.entity;

import jakarta.persistence.*;

import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(
        name = "xsd_definitions",
        uniqueConstraints = @UniqueConstraint(name = "uk_xsd_resource_path", columnNames = {"xsd_resource_path"})
)
public class XsdDefinitionEntity {

    @Id
    @GeneratedValue
    private UUID id;

    @Column(name = "namespace_uri", nullable = false, length = 512)
    private String namespaceUri;

    @Column(name = "root_element_local_name", length = 256)
    private String rootElementLocalName;

    @Column(name = "document_type", length = 256)
    private String documentType;

    @Column(name = "xsd_resource_path", nullable = false, length = 512)
    private String xsdResourcePath;

    @Lob
    @Column(name = "xsd_content", nullable = false)
    private String xsdContent;

    @Column(name = "loaded_at", nullable = false)
    private LocalDateTime loadedAt;

    protected XsdDefinitionEntity() {
    }

    public XsdDefinitionEntity(String namespaceUri,
                                String rootElementLocalName,
                                String documentType,
                                String xsdResourcePath,
                                String xsdContent,
                                LocalDateTime loadedAt) {
        this.namespaceUri = namespaceUri;
        this.rootElementLocalName = rootElementLocalName;
        this.documentType = documentType;
        this.xsdResourcePath = xsdResourcePath;
        this.xsdContent = xsdContent;
        this.loadedAt = loadedAt;
    }

    /**
     * Обновление после повторного сканирования classpath (новые XSD или правка схемы).
     */
    public void syncFromClasspath(String namespaceUri,
                                  String rootElementLocalName,
                                  String documentType,
                                  String xsdContent,
                                  LocalDateTime loadedAt) {
        this.namespaceUri = namespaceUri;
        this.rootElementLocalName = rootElementLocalName;
        this.documentType = documentType;
        this.xsdContent = xsdContent;
        this.loadedAt = loadedAt;
    }

    public UUID getId() {
        return id;
    }

    public String getNamespaceUri() {
        return namespaceUri;
    }

    public String getRootElementLocalName() {
        return rootElementLocalName;
    }

    public String getDocumentType() {
        return documentType;
    }

    public String getXsdResourcePath() {
        return xsdResourcePath;
    }

    public String getXsdContent() {
        return xsdContent;
    }
}

