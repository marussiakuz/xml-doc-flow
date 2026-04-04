package ru.artwell.contractor.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import ru.artwell.contractor.persistence.entity.DocumentValidationStatus;

import java.time.LocalDateTime;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class UploadDocumentResponse {
    /** Идентификатор сохранённой версии ({@code document_versions.id}). */
    private Long id;
    /** Логический документ ({@code documents.id}). */
    private Long documentId;
    private String docType;
    /** Номер документа из XML (бизнес-номер). */
    private String documentNumber;
    private int version;
    private LocalDateTime uploadedAt;
    private boolean valid;
    private DocumentValidationStatus validationStatus;
    private List<ValidationErrorDto> validationErrors;
}
