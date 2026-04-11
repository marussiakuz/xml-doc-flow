package ru.artwell.contractor.persistence.entity;

import jakarta.persistence.*;

import java.time.LocalDate;

@Entity
@Table(name = "construction_objects")
public class ConstructionObjectEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "object_code", nullable = false, unique = true, length = 128)
    private String objectCode;

    /** GUID объекта капитального строительства из XML ({@code permanentObjectUUID} / {@code permanentObjectId}). */
    @Column(name = "permanent_object_uuid", length = 64, unique = true)
    private String permanentObjectUuid;

    @Column(name = "object_name", nullable = false)
    private String objectName;

    @Column(name = "address", columnDefinition = "text")
    private String address;

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

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "customer_id")
    private UserEntity customer;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "contractor_id")
    private UserEntity contractor;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "designer_id")
    private UserEntity designer;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "supervisor_id")
    private UserEntity supervisor;

    @Column(name = "status", length = 32)
    private String status;

    @Column(name = "start_date")
    private LocalDate startDate;

    @Column(name = "end_date")
    private LocalDate endDate;

    protected ConstructionObjectEntity() {
    }

    public ConstructionObjectEntity(String objectCode,
                                    String objectName,
                                    String address,
                                    UserEntity customer,
                                    UserEntity contractor,
                                    UserEntity designer,
                                    UserEntity supervisor,
                                    String status) {
        this.objectCode = objectCode;
        this.objectName = objectName;
        this.address = address;
        this.customer = customer;
        this.contractor = contractor;
        this.designer = designer;
        this.supervisor = supervisor;
        this.status = status;
    }

    public ConstructionObjectEntity(String objectCode,
                                    String permanentObjectUuid,
                                    String objectName,
                                    String address,
                                    UserEntity customer,
                                    UserEntity contractor,
                                    UserEntity designer,
                                    UserEntity supervisor,
                                    String status) {
        this.objectCode = objectCode;
        this.permanentObjectUuid = permanentObjectUuid;
        this.objectName = objectName;
        this.address = address;
        this.customer = customer;
        this.contractor = contractor;
        this.designer = designer;
        this.supervisor = supervisor;
        this.status = status;
    }

    public Long getId() {
        return id;
    }

    public String getObjectCode() {
        return objectCode;
    }

    public String getPermanentObjectUuid() {
        return permanentObjectUuid;
    }

    public void setPermanentObjectUuid(String permanentObjectUuid) {
        this.permanentObjectUuid = permanentObjectUuid;
    }

    public void setObjectName(String objectName) {
        this.objectName = objectName;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getObjectName() {
        return objectName;
    }

    public String getAddress() {
        return address;
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
