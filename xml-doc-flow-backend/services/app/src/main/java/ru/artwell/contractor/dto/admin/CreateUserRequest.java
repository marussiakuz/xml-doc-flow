package ru.artwell.contractor.dto.admin;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import ru.artwell.contractor.security.AppRole;

public record CreateUserRequest(
        @NotBlank @Size(min = 3, max = 128) String username,
        @NotBlank @Size(min = 6, max = 256) String password,
        @Size(max = 512) String fullName,
        @NotNull AppRole role,
        @Size(max = 256) String email,
        Long organizationId
) {
}

