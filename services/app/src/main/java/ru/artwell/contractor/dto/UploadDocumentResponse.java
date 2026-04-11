package ru.artwell.contractor.dto;

import lombok.Data;
import lombok.NoArgsConstructor;
import ru.artwell.contractor.persistence.entity.DocumentValidationStatus;

import java.time.LocalDateTime;
import java.util.List;

@Data
@NoArgsConstructor
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

    public UploadDocumentResponse(Long id, Long documentId, String docType, String documentNumber, int version,
                                  LocalDateTime uploadedAt, boolean valid, DocumentValidationStatus validationStatus,
                                  List<ValidationErrorDto> validationErrors) {
        this.id = id;
        this.documentId = documentId;
        this.docType = docType;
        this.documentNumber = documentNumber;
        this.version = version;
        this.uploadedAt = uploadedAt;
        this.valid = valid;
        this.validationStatus = validationStatus;
        this.validationErrors = validationErrors;
    }
}
