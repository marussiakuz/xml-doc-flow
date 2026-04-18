package ru.artwell.contractor.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import ru.artwell.contractor.dto.ConstructionObjectAddressDto;
import ru.artwell.contractor.dto.OrganizationInfo;
import ru.artwell.contractor.dto.ParticipantInfo;
import ru.artwell.contractor.persistence.entity.DocumentParticipantEntity;
import ru.artwell.contractor.persistence.entity.OrganizationEntity;

@Mapper(componentModel = "spring")
public interface ParticipantMapper {

    @Mapping(target = "role", source = "participantRole")
    @Mapping(target = "roleName", expression = "java(ParticipantRoleLabels.label(p.getParticipantRole()))")
    @Mapping(target = "organization", expression = "java(participantOrganization(p))")
    @Mapping(target = "address", expression = "java(participantAddress(p))")
    ParticipantInfo toParticipantInfo(DocumentParticipantEntity p);

    default ConstructionObjectAddressDto participantAddress(DocumentParticipantEntity p) {
        OrganizationEntity org = p.getOrganization();
        return org != null ? ConstructionObjectAddressDto.fromOrganizationEntity(org) : null;
    }

    default OrganizationInfo participantOrganization(DocumentParticipantEntity p) {
        OrganizationEntity orgEntity = p.getOrganization();
        if (orgEntity != null) {
            ConstructionObjectAddressDto addr = ConstructionObjectAddressDto.fromOrganizationEntity(orgEntity);
            return new OrganizationInfo(
                    orgEntity.getId(),
                    orgEntity.getOrgName(),
                    orgEntity.getInn(),
                    orgEntity.getOgrn(),
                    addr
            );
        }
        return new OrganizationInfo(null, p.getParticipantName(), p.getParticipantInn(), null, null);
    }
}
