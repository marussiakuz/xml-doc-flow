package ru.artwell.contractor.mapper;

import ru.artwell.contractor.dto.ParticipantDto;

import java.util.Map;

/**
 * Подписи ролей участников для UI (соответствуют справочнику ролей в XML).
 */
public final class ParticipantRoleLabels {

    private static final Map<String, String> LABELS = Map.of(
            ParticipantDto.ROLE_DEVELOPER, "Застройщик",
            ParticipantDto.ROLE_BUILDING_CONTRACTOR, "Лицо, осуществляющее строительство",
            ParticipantDto.ROLE_PROJECT_DOCUMENTATION_CONTRACTOR, "Лицо, осуществляющее подготовку проектной документации",
            ParticipantDto.ROLE_TECHNICAL_CUSTOMER, "Технический заказчик"
    );

    private ParticipantRoleLabels() {
    }

    public static String label(String role) {
        if (role == null) {
            return null;
        }
        return LABELS.getOrDefault(role, role);
    }
}
