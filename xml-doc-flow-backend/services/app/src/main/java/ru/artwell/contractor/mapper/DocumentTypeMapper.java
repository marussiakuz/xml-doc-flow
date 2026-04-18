package ru.artwell.contractor.mapper;

import org.mapstruct.Mapper;
import ru.artwell.contractor.dto.DocumentTypeDto;
import ru.artwell.contractor.persistence.entity.DocumentTypeEntity;

@Mapper(componentModel = "spring")
public interface DocumentTypeMapper {

    DocumentTypeDto toDto(DocumentTypeEntity entity);
}
