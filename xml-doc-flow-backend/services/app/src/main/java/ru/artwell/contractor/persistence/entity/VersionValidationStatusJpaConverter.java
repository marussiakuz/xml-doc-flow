package ru.artwell.contractor.persistence.entity;

import jakarta.persistence.AttributeConverter;
import jakarta.persistence.Converter;

@Converter(autoApply = true)
public class VersionValidationStatusJpaConverter implements AttributeConverter<VersionValidationStatus, String> {

    @Override
    public String convertToDatabaseColumn(VersionValidationStatus attribute) {
        if (attribute == null) {
            return null;
        }
        return attribute.name().toLowerCase();
    }

    @Override
    public VersionValidationStatus convertToEntityAttribute(String dbData) {
        if (dbData == null || dbData.isBlank()) {
            return null;
        }
        return VersionValidationStatus.valueOf(dbData.trim().toUpperCase());
    }
}
