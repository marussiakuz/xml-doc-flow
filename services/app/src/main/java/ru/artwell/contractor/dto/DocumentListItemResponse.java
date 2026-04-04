package ru.artwell.contractor.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class DocumentListItemResponse {
    /** Идентификатор актуальной версии ({@code document_versions.id}). */
    private Long id;
    private String docType;
    private String documentNumber;
    private int version;
    private LocalDateTime uploadedAt;
}
