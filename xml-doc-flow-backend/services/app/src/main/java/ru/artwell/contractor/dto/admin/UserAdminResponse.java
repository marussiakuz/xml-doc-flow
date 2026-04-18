package ru.artwell.contractor.dto.admin;

import java.time.LocalDateTime;

public record UserAdminResponse(
        Long id,
        String username,
        String fullName,
        String role,
        String email,
        Boolean active,
        Long organizationId,
        String organizationName,
        LocalDateTime createdAt,
        LocalDateTime lastLogin
) {
}

