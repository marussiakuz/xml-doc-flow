package ru.artwell.contractor.dto;

import java.util.List;

public record AuditLogPageResponse(
        List<AuditLogDto> content,
        int pageNumber,
        int pageSize,
        long totalElements,
        int totalPages
) {
}
