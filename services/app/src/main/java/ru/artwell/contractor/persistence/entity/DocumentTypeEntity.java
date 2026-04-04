package ru.artwell.contractor.persistence.entity;

import jakarta.persistence.*;

@Entity
@Table(
        name = "document_types",
        uniqueConstraints = @UniqueConstraint(name = "uk_document_types_type_code", columnNames = "type_code")
)
public class DocumentTypeEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "type_code", nullable = false, unique = true, length = 128)
    private String typeCode;

    @Column(name = "type_name", nullable = false)
    private String typeName;

    @Column(name = "category", length = 256)
    private String category;

    @Column(name = "xsd_schema_path", length = 1024)
    private String xsdSchemaPath;

    @Column(name = "is_active", nullable = false)
    private boolean active = true;

    protected DocumentTypeEntity() {
    }

    public DocumentTypeEntity(String typeCode,
                              String typeName,
                              String category,
                              String xsdSchemaPath,
                              boolean active) {
        this.typeCode = typeCode;
        this.typeName = typeName;
        this.category = category;
        this.xsdSchemaPath = xsdSchemaPath;
        this.active = active;
    }

    public Long getId() {
        return id;
    }

    public String getTypeCode() {
        return typeCode;
    }

    public String getXsdSchemaPath() {
        return xsdSchemaPath;
    }
}
