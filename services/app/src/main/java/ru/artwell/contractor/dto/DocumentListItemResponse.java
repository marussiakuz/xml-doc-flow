package ru.artwell.contractor.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.UUID;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class DocumentListItemResponse {
    private UUID id;
    private String docType;
    private UUID documentNumber;
    private int version;
    private LocalDateTime uploadedAt;
}

