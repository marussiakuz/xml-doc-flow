package ru.artwell.contractor.api.controller;

import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import ru.artwell.contractor.config.AppTimeConfiguration;
import ru.artwell.contractor.dto.ErrorResponse;
import ru.artwell.contractor.dto.UploadDocumentResponse;
import ru.artwell.contractor.dto.ValidationErrorDto;
import ru.artwell.contractor.exception.MultipartFileReadException;
import ru.artwell.contractor.persistence.entity.DocumentValidationStatus;
import ru.artwell.contractor.service.DocumentService;
import ru.artwell.contractor.service.XsdCatalogService;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.List;
import java.util.stream.Collectors;

@RestControllerAdvice
public class GlobalExceptionHandler {

    private final ZoneId applicationZoneId;

    public GlobalExceptionHandler(
            @Qualifier(AppTimeConfiguration.APPLICATION_ZONE_ID) ZoneId applicationZoneId) {
        this.applicationZoneId = applicationZoneId;
    }

    @ExceptionHandler(DocumentService.NotFoundException.class)
    public ResponseEntity<ErrorResponse> handleNotFound(DocumentService.NotFoundException ex) {
        ErrorResponse error = new ErrorResponse(ex.getMessage());
        return ResponseEntity
                .status(HttpStatus.NOT_FOUND)
                .contentType(MediaType.APPLICATION_JSON)
                .body(error);
    }

    @ExceptionHandler(DocumentService.UnrecognizedDocumentTypeException.class)
    public ResponseEntity<ErrorResponse> handleUnrecognizedDocumentType(
            DocumentService.UnrecognizedDocumentTypeException ex) {
        return ResponseEntity
                .status(HttpStatus.BAD_REQUEST)
                .contentType(MediaType.APPLICATION_JSON)
                .body(new ErrorResponse(ex.getMessage()));
    }

    @ExceptionHandler(AccessDeniedException.class)
    public ResponseEntity<ErrorResponse> handleAccessDenied(AccessDeniedException ex) {
        String msg = ex.getMessage();
        if (msg == null || msg.isBlank()) {
            msg = "Доступ запрещён";
        }
        return ResponseEntity
                .status(HttpStatus.FORBIDDEN)
                .contentType(MediaType.APPLICATION_JSON)
                .body(new ErrorResponse(msg));
    }

    @ExceptionHandler(DocumentService.ConflictException.class)
    public ResponseEntity<UploadDocumentResponse> handleConflict(DocumentService.ConflictException ex) {
        return ResponseEntity.status(HttpStatus.CONFLICT).body(uploadErrorEnvelope(ex.getMessage(), DocumentValidationStatus.INVALID_CONFLICT));
    }

    /** перехватывается в {@link ru.artwell.contractor.service.DocumentService}; здесь — 201. */
    @ExceptionHandler(XsdCatalogService.UnknownDocumentTypeException.class)
    public ResponseEntity<UploadDocumentResponse> handleUnknownDocumentType(
            XsdCatalogService.UnknownDocumentTypeException ex) {
        return ResponseEntity.status(HttpStatus.CREATED).body(uploadErrorEnvelope(ex.getMessage(), DocumentValidationStatus.INVALID_UNKNOWN_DOCUMENT_TYPE));
    }

    @ExceptionHandler(IllegalArgumentException.class)
    public ResponseEntity<ErrorResponse> handleBadRequest(IllegalArgumentException ex) {
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(new ErrorResponse(ex.getMessage()));
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ErrorResponse> handleValidation(MethodArgumentNotValidException ex) {
        String msg = ex.getBindingResult().getFieldErrors().stream()
                .map(e -> e.getField() + ": " + e.getDefaultMessage())
                .collect(Collectors.joining("; "));
        if (msg.isBlank()) {
            msg = "Невалидные параметры запроса";
        }
        return ResponseEntity
                .status(HttpStatus.BAD_REQUEST)
                .contentType(MediaType.APPLICATION_JSON)
                .body(new ErrorResponse(msg));
    }

    @ExceptionHandler(MultipartFileReadException.class)
    public ResponseEntity<ErrorResponse> handleMultipartFileRead(MultipartFileReadException ex) {
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(new ErrorResponse(
                "При загрузке документа произошла ошибка. Проверьте, что файл не повреждён, и попробуйте снова."
        ));
    }

    private UploadDocumentResponse uploadErrorEnvelope(String message, DocumentValidationStatus status) {
        return new UploadDocumentResponse(
                null,
                null,
                null,
                null,
                null,
                0,
                LocalDateTime.now(applicationZoneId),
                false,
                status,
                List.of(new ValidationErrorDto(message, null, null))
        );
    }
}
