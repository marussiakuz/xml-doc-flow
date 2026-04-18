package ru.artwell.contractor.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import ru.artwell.contractor.dto.ConstructionObjectAddressDto;
import ru.artwell.contractor.dto.ConstructionObjectInfo;
import ru.artwell.contractor.persistence.entity.ConstructionObjectEntity;

@Mapper(componentModel = "spring", imports = ConstructionObjectAddressDto.class)
public interface ConstructionObjectInfoMapper {

    @Mapping(target = "name", source = "objectName")
    @Mapping(target = "address", expression = "java(ConstructionObjectAddressDto.fromEntity(co))")
    @Mapping(target = "objectCode", expression = "java(displayObjectCode(co))")
    ConstructionObjectInfo toInfo(ConstructionObjectEntity co);

    default String displayObjectCode(ConstructionObjectEntity co) {
        String uuid = co.getPermanentObjectUuid();
        if (uuid != null && !uuid.isBlank()) {
            return uuid;
        }
        return co.getObjectCode();
    }
}
