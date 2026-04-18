package ru.artwell.contractor.mapper;

import java.util.Map;

public final class AuditActionLabels {

    private static final Map<String, String> LABELS = Map.of(
            "UPLOAD", "Загрузка документа",
            "REPLACE", "Замена версии",
            "VIEW_DETAIL", "Просмотр карточки",
            "DOWNLOAD_XML", "Скачивание XML",
            "VIEW_DOCUMENTS_LIST", "Просмотр списка документов"
    );

    private AuditActionLabels() {
    }

    public static String label(String actionType) {
        if (actionType == null) {
            return null;
        }
        return LABELS.getOrDefault(actionType, actionType);
    }
}
