package ru.artwell.contractor.dto;

import ru.artwell.contractor.persistence.entity.AuditLogEntity;

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
    private static final Map<String, String> ACTION_LABELS = Map.of(
            "UPLOAD", "Загрузка документа",
            "REPLACE", "Замена версии",
            "VIEW_DETAIL", "Просмотр карточки",
            "DOWNLOAD_XML", "Скачивание XML",
            "VIEW_DOCUMENTS_LIST", "Просмотр списка документов"
    );

    public static AuditLogDto from(AuditLogEntity e) {
        return new AuditLogDto(
                e.getId(),
                e.getActionType(),
                ACTION_LABELS.getOrDefault(e.getActionType(), e.getActionType()),
                e.getEntityId(),
                e.getEntityType(),
                e.getUsername(),
                e.getCreatedAt(),
                e.getActionDetails(),
                e.getIpAddress()
        );
    }
}
