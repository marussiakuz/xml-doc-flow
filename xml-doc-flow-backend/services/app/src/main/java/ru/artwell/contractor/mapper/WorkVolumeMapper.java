package ru.artwell.contractor.mapper;

import org.mapstruct.Mapper;
import ru.artwell.contractor.dto.WorkVolumeInfo;
import ru.artwell.contractor.persistence.entity.WorkVolumeEntity;

@Mapper(componentModel = "spring")
public interface WorkVolumeMapper {

    WorkVolumeInfo toInfo(WorkVolumeEntity entity);
}
