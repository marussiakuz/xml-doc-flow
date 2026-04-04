package ru.artwell.contractor.persistence.entity;

import jakarta.persistence.*;

import java.time.LocalDate;

@Entity
@Table(name = "journal_entries")
public class JournalEntryEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "document_version_id", nullable = false)
    private DocumentVersionEntity documentVersion;

    @Column(name = "entry_number")
    private Integer entryNumber;

    @Column(name = "entry_date")
    private LocalDate entryDate;

    @Column(name = "work_description", columnDefinition = "text")
    private String workDescription;

    @Column(name = "performer_name", length = 512)
    private String performerName;

    protected JournalEntryEntity() {
    }
}
