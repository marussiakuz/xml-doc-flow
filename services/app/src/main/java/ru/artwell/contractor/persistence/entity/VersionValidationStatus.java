package ru.artwell.contractor.persistence.entity;

/**
 * Значения колонки {@code document_versions.validation_status} (README).
 */
public enum VersionValidationStatus {
    PENDING,
    VALIDATING,
    VALID,
    INVALID,
    ERROR
}
