package ru.artwell.contractor.dto;

import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * Параметры фильтрации списка документов (внутренний слой сервиса).
 */
public record DocumentFilter(
        Long objectId,
        String objectCode,
        String documentType,
        String documentNumber,
        String status,
        String validationStatus,
        LocalDate fromDate,
        LocalDate toDate,
        LocalDateTime uploadedFrom,
        LocalDateTime uploadedTo,
        boolean latestOnly
) {
    public String statusOrDefault() {
        return (status == null || status.isBlank()) ? "active" : status.trim();
    }
}
