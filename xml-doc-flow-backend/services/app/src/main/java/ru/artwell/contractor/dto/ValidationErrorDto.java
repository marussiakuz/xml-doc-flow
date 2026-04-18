package ru.artwell.contractor.dto;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class ValidationErrorDto {
    private String message;
    private Integer lineNumber;
    private Integer columnNumber;

    public ValidationErrorDto(String message, Integer lineNumber, Integer columnNumber) {
        this.message = message;
        this.lineNumber = lineNumber;
        this.columnNumber = columnNumber;
    }
}

