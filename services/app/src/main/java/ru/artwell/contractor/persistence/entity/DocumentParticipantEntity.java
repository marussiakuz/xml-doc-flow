package ru.artwell.contractor.persistence.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "document_participants")
public class DocumentParticipantEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "document_version_id", nullable = false)
    private DocumentVersionEntity documentVersion;

    @Column(name = "participant_role", length = 256)
    private String participantRole;

    @Column(name = "participant_type", length = 32)
    private String participantType;

    @Column(name = "participant_name", length = 512)
    private String participantName;

    @Column(name = "participant_inn", length = 32)
    private String participantInn;

    @Column(name = "participant_kpp", length = 32)
    private String participantKpp;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "organization_id")
    private OrganizationEntity organization;

    protected DocumentParticipantEntity() {
    }

    public DocumentParticipantEntity(DocumentVersionEntity documentVersion,
                                     OrganizationEntity organization,
                                     String participantRole,
                                     String participantType,
                                     String participantName,
                                     String participantInn,
                                     String participantKpp) {
        this.documentVersion = documentVersion;
        this.organization = organization;
        this.participantRole = participantRole;
        this.participantType = participantType;
        this.participantName = participantName;
        this.participantInn = participantInn;
        this.participantKpp = participantKpp;
    }

    public DocumentVersionEntity getDocumentVersion() {
        return documentVersion;
    }

    public String getParticipantRole() {
        return participantRole;
    }

    public String getParticipantName() {
        return participantName;
    }

    public String getParticipantInn() {
        return participantInn;
    }

    public OrganizationEntity getOrganization() {
        return organization;
    }
}
