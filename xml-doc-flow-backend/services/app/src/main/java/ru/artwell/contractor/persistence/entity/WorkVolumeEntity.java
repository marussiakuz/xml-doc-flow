package ru.artwell.contractor.persistence.entity;

import jakarta.persistence.*;

import java.math.BigDecimal;

@Entity
@Table(name = "work_volumes")
public class WorkVolumeEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "document_version_id", nullable = false)
    private DocumentVersionEntity documentVersion;

    @Column(name = "work_type", length = 512)
    private String workType;

    @Column(name = "quantity", precision = 19, scale = 4)
    private BigDecimal quantity;

    @Column(name = "price", precision = 19, scale = 4)
    private BigDecimal price;

    @Column(name = "amount", precision = 19, scale = 4)
    private BigDecimal amount;

    protected WorkVolumeEntity() {
    }

    public WorkVolumeEntity(DocumentVersionEntity documentVersion, String workType, BigDecimal quantity) {
        this.documentVersion = documentVersion;
        this.workType = workType;
        this.quantity = quantity;
    }

    public Long getId() { return id; }
    public String getWorkType() { return workType; }
    public BigDecimal getQuantity() { return quantity; }
    public BigDecimal getPrice() { return price; }
    public BigDecimal getAmount() { return amount; }
}
