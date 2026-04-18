package ru.artwell.contractor.mapper;

import org.mapstruct.Mapper;
import ru.artwell.contractor.dto.ConstructionObjectDto;
import ru.artwell.contractor.persistence.entity.ConstructionObjectEntity;

@Mapper(componentModel = "spring")
public interface ConstructionObjectDtoMapper {

    ConstructionObjectDto toDto(ConstructionObjectEntity entity);
}
