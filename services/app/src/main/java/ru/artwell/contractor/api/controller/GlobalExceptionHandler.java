package ru.artwell.contractor.api.controller;

import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import ru.artwell.contractor.config.AppTimeConfiguration;
import ru.artwell.contractor.dto.ErrorResponse;
import ru.artwell.contractor.dto.UploadDocumentResponse;
import ru.artwell.contractor.dto.ValidationErrorDto;
import ru.artwell.contractor.exception.MultipartFileReadException;
import ru.artwell.contractor.service.DocumentService;
import ru.artwell.contractor.service.XsdCatalogService;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.List;

@RestControllerAdvice
public class GlobalExceptionHandler {

    private final ZoneId applicationZoneId;

    public GlobalExceptionHandler(
            @Qualifier(AppTimeConfiguration.APPLICATION_ZONE_ID) ZoneId applicationZoneId) {
        this.applicationZoneId = applicationZoneId;
    }

    @ExceptionHandler(DocumentService.NotFoundException.class)
    public ResponseEntity<ErrorResponse> handleNotFound(DocumentService.NotFoundException ex) {
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(new ErrorResponse(ex.getMessage()));
    }

    @ExceptionHandler(DocumentService.ConflictException.class)
    public ResponseEntity<UploadDocumentResponse> handleConflict(DocumentService.ConflictException ex) {
        return ResponseEntity.status(HttpStatus.CONFLICT).body(uploadErrorEnvelope(ex.getMessage()));
    }

    @ExceptionHandler(XsdCatalogService.UnknownDocumentTypeException.class)
    public ResponseEntity<UploadDocumentResponse> handleUnknownDocumentType(
            XsdCatalogService.UnknownDocumentTypeException ex) {
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(uploadErrorEnvelope(ex.getMessage()));
    }

    @ExceptionHandler(IllegalArgumentException.class)
    public ResponseEntity<ErrorResponse> handleBadRequest(IllegalArgumentException ex) {
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(new ErrorResponse(ex.getMessage()));
    }

    @ExceptionHandler(MultipartFileReadException.class)
    public ResponseEntity<ErrorResponse> handleMultipartFileRead(MultipartFileReadException ex) {
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(new ErrorResponse(
                "При загрузке документа произошла ошибка. Проверьте, что файл не повреждён, и попробуйте снова."
        ));
    }

    private UploadDocumentResponse uploadErrorEnvelope(String message) {
        return new UploadDocumentResponse(
                null,
                null,
                null,
                null,
                0,
                LocalDateTime.now(applicationZoneId),
                false,
                List.of(new ValidationErrorDto(message, null, null))
        );
    }
}
