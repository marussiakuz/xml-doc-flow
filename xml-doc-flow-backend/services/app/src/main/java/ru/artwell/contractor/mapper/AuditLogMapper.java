package ru.artwell.contractor.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import ru.artwell.contractor.dto.AuditLogDto;
import ru.artwell.contractor.persistence.entity.AuditLogEntity;

@Mapper(componentModel = "spring")
public interface AuditLogMapper {

    @Mapping(target = "actionLabel", expression = "java(AuditActionLabels.label(e.getActionType()))")
    AuditLogDto toDto(AuditLogEntity e);
}
