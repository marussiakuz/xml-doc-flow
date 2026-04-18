package ru.artwell.contractor.dto;

import java.time.LocalDateTime;
import java.util.Map;

public record AuditLogDto(
        Long id,
        String actionType,
        String actionLabel,
        Long entityId,
        String entityType,
        String username,
        LocalDateTime createdAt,
        Map<String, Object> actionDetails,
        String ipAddress
) {
}
