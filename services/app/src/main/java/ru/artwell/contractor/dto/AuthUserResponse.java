package ru.artwell.contractor.dto;

public record AuthUserResponse(
        Long id,
        String username,
        String fullName,
        String role
) {
}

