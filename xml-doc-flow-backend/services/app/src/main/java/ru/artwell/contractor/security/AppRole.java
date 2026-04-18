package ru.artwell.contractor.security;

/**
 * Роли пользователя в приложении (совпадают с {@code UserEntity.role} и {@code ROLE_*} в Spring Security).
 */
public enum AppRole {
    ADMIN,
    CONTRACTOR,
    CUSTOMER
}
