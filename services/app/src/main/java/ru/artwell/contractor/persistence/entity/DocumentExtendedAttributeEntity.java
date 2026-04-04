package ru.artwell.contractor.persistence.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "document_extended_attributes")
public class DocumentExtendedAttributeEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "document_version_id", nullable = false)
    private DocumentVersionEntity documentVersion;

    @Column(name = "attribute_name", nullable = false, length = 512)
    private String attributeName;

    @Column(name = "attribute_value", columnDefinition = "text")
    private String attributeValue;

    @Column(name = "attribute_type", length = 32)
    private String attributeType;

    @Column(name = "group_name", length = 256)
    private String groupName;

    protected DocumentExtendedAttributeEntity() {
    }
}
