package ru.artwell.contractor.dto;

import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
public class DocumentListItemResponse {
    /** Идентификатор актуальной версии ({@code document_versions.id}). */
    private Long id;
    private String docType;
    private String documentNumber;
    private int version;
    private LocalDateTime uploadedAt;

    public DocumentListItemResponse(Long id, String docType, String documentNumber, int version, LocalDateTime uploadedAt) {
        this.id = id;
        this.docType = docType;
        this.documentNumber = documentNumber;
        this.version = version;
        this.uploadedAt = uploadedAt;
    }
}
