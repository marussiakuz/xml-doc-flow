package ru.artwell.contractor.persistence.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "organizations")
public class OrganizationEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "org_name", nullable = false)
    private String orgName;

    @Column(name = "org_short_name")
    private String orgShortName;

    @Column(name = "org_type", length = 64)
    private String orgType;

    @Column(name = "inn", unique = true, length = 32)
    private String inn;

    @Column(name = "kpp", length = 32)
    private String kpp;

    @Column(name = "legal_address", columnDefinition = "text")
    private String legalAddress;

    @Column(name = "is_active", nullable = false)
    private boolean active = true;

    protected OrganizationEntity() {
    }

    public OrganizationEntity(String orgName,
                              String orgShortName,
                              String orgType,
                              String inn,
                              String kpp,
                              String legalAddress,
                              boolean active) {
        this.orgName = orgName;
        this.orgShortName = orgShortName;
        this.orgType = orgType;
        this.inn = inn;
        this.kpp = kpp;
        this.legalAddress = legalAddress;
        this.active = active;
    }

    public Long getId() {
        return id;
    }

    public String getOrgName() {
        return orgName;
    }

    public String getInn() {
        return inn;
    }
}
