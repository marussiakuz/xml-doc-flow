package ru.artwell.contractor.persistence.entity;

public enum DocumentValidationStatus {
    VALID,
    INVALID_SCHEMA,
    INVALID_UNKNOWN_DOCUMENT_TYPE,
    INVALID_DOCUMENT_ROOT,
    INVALID_XML,
    INVALID_CONFLICT
}

