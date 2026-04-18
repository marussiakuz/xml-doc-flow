package ru.artwell.contractor.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import ru.artwell.contractor.dto.AuthUserResponse;
import ru.artwell.contractor.dto.UserDto;
import ru.artwell.contractor.dto.UserInfo;
import ru.artwell.contractor.dto.admin.UserAdminResponse;
import ru.artwell.contractor.persistence.entity.UserEntity;
import ru.artwell.contractor.util.NameFormats;

@Mapper(componentModel = "spring", imports = NameFormats.class)
public interface UserPresentationMapper {

    @Mapping(target = "fullName", expression = "java(NameFormats.toLastNameWithInitials(user.getFullName()))")
    UserDto toUserDto(UserEntity user);

    @Mapping(target = "fullName", expression = "java(NameFormats.toLastNameWithInitials(user.getFullName()))")
    UserInfo toUserInfo(UserEntity user);

    @Mapping(target = "fullName", expression = "java(NameFormats.toLastNameWithInitials(user.getFullName()))")
    AuthUserResponse toAuthUserResponse(UserEntity user);

    @Mapping(target = "organizationId", expression = "java(user.getOrganization() != null ? user.getOrganization().getId() : null)")
    @Mapping(target = "organizationName", expression = "java(user.getOrganization() != null ? user.getOrganization().getOrgName() : null)")
    UserAdminResponse toUserAdminResponse(UserEntity user);
}
