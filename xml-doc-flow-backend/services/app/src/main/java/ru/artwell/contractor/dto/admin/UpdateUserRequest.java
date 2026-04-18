package ru.artwell.contractor.dto.admin;

import jakarta.validation.constraints.Size;
import ru.artwell.contractor.security.AppRole;

public record UpdateUserRequest(
        @Size(max = 512) String fullName,
        AppRole role,
        Boolean active,
        @Size(max = 256) String email,
        Long organizationId
) {
}

