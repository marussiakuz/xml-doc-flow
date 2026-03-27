package ru.artwell.contractor.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class UploadDocumentResponse {
    private UUID id;
    private UUID groupId;
    private String docType;
    private UUID documentNumber;
    private int version;
    private LocalDateTime uploadedAt;
    private boolean valid;
    private ru.artwell.contractor.persistence.entity.DocumentValidationStatus validationStatus;
    private List<ValidationErrorDto> validationErrors;
}

