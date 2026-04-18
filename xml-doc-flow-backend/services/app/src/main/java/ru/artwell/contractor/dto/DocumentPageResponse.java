package ru.artwell.contractor.dto;

import java.util.List;

public record DocumentPageResponse(
        List<DocumentResponse> content,
        int pageNumber,
        int pageSize,
        long totalElements,
        int totalPages,
        boolean last,
        boolean first
) {
}
