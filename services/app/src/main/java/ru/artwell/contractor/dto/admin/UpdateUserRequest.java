package ru.artwell.contractor.dto.admin;

import jakarta.validation.constraints.Size;

public record UpdateUserRequest(
        @Size(max = 512) String fullName,
        String role,
        Boolean active,
        @Size(max = 256) String email,
        Long organizationId
) {
}

