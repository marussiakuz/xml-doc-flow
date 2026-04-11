package ru.artwell.contractor.dto;

import java.time.LocalDate;
import java.time.LocalDateTime;

public record DocumentResponse(
        Long versionId,
        Long documentId,
        String documentNumber,
        LocalDate documentDate,
        String title,
        DocumentTypeDto documentType,
        ConstructionObjectDto constructionObject,
        Integer currentVersion,
        Boolean latestVersion,
        String validationStatus,
        String status,
        UserDto uploadedBy,
        LocalDateTime uploadedAt,
        String xmlFileName,
        Long xmlFileSize,
        DocumentLinks links
) {
}
