package ru.artwell.contractor.dto;

import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.PastOrPresent;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.Size;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;

/**
 * Поиск документов с пагинацией (тело POST {@code /api/documents/search}).
 */
public record DocumentSearchRequest(
        @Positive Long objectId,
        @Size(max = 128) String objectCode,
        @Size(max = 1024) String documentType,
        @Size(max = 512) String documentNumber,
        @Size(max = 32) String status,
        @Size(max = 32) String validationStatus,
        @PastOrPresent LocalDate fromDate,
        @PastOrPresent LocalDate toDate,
        @PastOrPresent LocalDateTime uploadedFrom,
        @PastOrPresent LocalDateTime uploadedTo,
        Boolean latestOnly,
        @Min(0) Integer page,
        @Min(1) @Max(500) Integer size,
        @JsonDeserialize(using = SortCriterionListDeserializer.class)
        List<String> sort
) {
    public static final int DEFAULT_PAGE = 0;
    public static final int DEFAULT_SIZE = 20;
    public static final String DEFAULT_SORT_FIELD = "uploadedAt";
    public static final Sort.Direction DEFAULT_SORT_DIRECTION = Sort.Direction.DESC;

    /**
     * Поля {@link ru.artwell.contractor.persistence.entity.DocumentEntity}, разрешённые для Sort (без вложенных путей).
     */
    private static final Set<String> ALLOWED_SORT_PROPERTIES = Set.of(
            "id",
            "uploadedAt",
            "documentDate",
            "documentNumber",
            "status",
            "title",
            "currentVersion",
            "latestVersion"
    );

    public DocumentSearchRequest {
        if (sort == null) {
            sort = List.of();
        }
    }

    public String getStatusOrDefault() {
        if (status == null || status.isBlank()) {
            return "active";
        }
        return status.trim();
    }

    public boolean getLatestOnlyOrDefault() {
        return latestOnly == null || latestOnly;
    }

    public Pageable toPageable() {
        int pageNum = page != null ? page : DEFAULT_PAGE;
        int pageSize = size != null ? size : DEFAULT_SIZE;

        Sort sortBy;
        if (!sort.isEmpty()) {
            List<Sort.Order> orders = new ArrayList<>();
            for (String s : sort) {
                if (s == null || s.isBlank()) {
                    continue;
                }
                String[] parts = s.split(",", 2);
                String field = parts[0].trim();
                if (field.isEmpty() || !ALLOWED_SORT_PROPERTIES.contains(field)) {
                    continue;
                }
                Sort.Direction direction = DEFAULT_SORT_DIRECTION;
                if (parts.length > 1 && !parts[1].isBlank()) {
                    try {
                        direction = Sort.Direction.fromString(parts[1].trim());
                    } catch (IllegalArgumentException ignored) {
                        direction = DEFAULT_SORT_DIRECTION;
                    }
                }
                orders.add(new Sort.Order(direction, field));
            }
            if (orders.isEmpty()) {
                sortBy = Sort.by(DEFAULT_SORT_DIRECTION, DEFAULT_SORT_FIELD);
            } else {
                sortBy = Sort.by(orders);
            }
        } else {
            sortBy = Sort.by(DEFAULT_SORT_DIRECTION, DEFAULT_SORT_FIELD);
        }

        return PageRequest.of(pageNum, pageSize, sortBy);
    }

    public DocumentFilter toDocumentFilter() {
        return new DocumentFilter(
                objectId,
                objectCode,
                documentType,
                documentNumber,
                getStatusOrDefault(),
                validationStatus,
                fromDate,
                toDate,
                uploadedFrom,
                uploadedTo,
                getLatestOnlyOrDefault()
        );
    }
}
