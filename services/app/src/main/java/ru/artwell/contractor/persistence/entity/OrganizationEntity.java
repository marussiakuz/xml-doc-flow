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

    @Column(name = "ogrn", length = 32)
    private String ogrn;

    @Column(name = "kpp", length = 32)
    private String kpp;

    @Column(name = "legal_address", columnDefinition = "text")
    private String legalAddress;

    @Column(name = "country", length = 512)
    private String country;

    @Column(name = "region", length = 512)
    private String region;

    @Column(name = "district", length = 512)
    private String district;

    @Column(name = "locality", length = 512)
    private String locality;

    @Column(name = "street", length = 1024)
    private String street;

    @Column(name = "house", length = 256)
    private String house;

    @Column(name = "postal_code", length = 32)
    private String postalCode;

    @Column(name = "oktmo", length = 32)
    private String oktmo;

    @Column(name = "is_active", nullable = false)
    private boolean active = true;

    protected OrganizationEntity() {
    }

    public OrganizationEntity(String orgName,
                              String orgShortName,
                              String orgType,
                              String inn,
                              String kpp,
                              String ogrn,
                              String legalAddress,
                              boolean active) {
        this.orgName = orgName;
        this.orgShortName = orgShortName;
        this.orgType = orgType;
        this.inn = inn;
        this.kpp = kpp;
        this.ogrn = ogrn;
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

    public void setOrgName(String orgName) {
        this.orgName = orgName;
    }

    public void setOgrn(String ogrn) {
        this.ogrn = ogrn;
    }

    public void setLegalAddress(String legalAddress) {
        this.legalAddress = legalAddress;
    }

    public String getOgrn() {
        return ogrn;
    }

    public String getLegalAddress() {
        return legalAddress;
    }

    public String getCountry() {
        return country;
    }

    public void setCountry(String country) {
        this.country = country;
    }

    public String getRegion() {
        return region;
    }

    public void setRegion(String region) {
        this.region = region;
    }

    public String getDistrict() {
        return district;
    }

    public void setDistrict(String district) {
        this.district = district;
    }

    public String getLocality() {
        return locality;
    }

    public void setLocality(String locality) {
        this.locality = locality;
    }

    public String getStreet() {
        return street;
    }

    public void setStreet(String street) {
        this.street = street;
    }

    public String getHouse() {
        return house;
    }

    public void setHouse(String house) {
        this.house = house;
    }

    public String getPostalCode() {
        return postalCode;
    }

    public void setPostalCode(String postalCode) {
        this.postalCode = postalCode;
    }

    public String getOktmo() {
        return oktmo;
    }

    public void setOktmo(String oktmo) {
        this.oktmo = oktmo;
    }
}
