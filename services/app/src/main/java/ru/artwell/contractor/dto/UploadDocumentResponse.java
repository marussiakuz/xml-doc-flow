package ru.artwell.contractor.dto;

import lombok.Data;
import lombok.NoArgsConstructor;
import ru.artwell.contractor.persistence.entity.DocumentValidationStatus;

import java.time.LocalDateTime;
import java.util.List;

@Data
@NoArgsConstructor
public class UploadDocumentResponse {
    private Long id;
    private Long documentId;
    private String docType;
    private String docTypeName;
    private String documentNumber;
    private int version;
    private LocalDateTime uploadedAt;
    private boolean valid;
    private DocumentValidationStatus validationStatus;
    private List<ValidationErrorDto> validationErrors;

    public UploadDocumentResponse(Long id, Long documentId, String docType, String docTypeName,
                                  String documentNumber, int version,
                                  LocalDateTime uploadedAt, boolean valid, DocumentValidationStatus validationStatus,
                                  List<ValidationErrorDto> validationErrors) {
        this.id = id;
        this.documentId = documentId;
        this.docType = docType;
        this.docTypeName = docTypeName;
        this.documentNumber = documentNumber;
        this.version = version;
        this.uploadedAt = uploadedAt;
        this.valid = valid;
        this.validationStatus = validationStatus;
        this.validationErrors = validationErrors;
    }

    // Явные геттеры: защищаемся от проблем с обработкой Lombok в сборке.
    public DocumentValidationStatus getValidationStatus() {
        return validationStatus;
    }
}
