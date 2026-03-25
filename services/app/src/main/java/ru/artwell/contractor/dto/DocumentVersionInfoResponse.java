package ru.artwell.contractor.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.UUID;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class DocumentVersionInfoResponse {
    private UUID id;
    private int version;
    private UUID previousVersionId;
    private LocalDateTime uploadedAt;
}

