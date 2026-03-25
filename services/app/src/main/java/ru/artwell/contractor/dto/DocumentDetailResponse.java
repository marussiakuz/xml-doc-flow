package ru.artwell.contractor.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class DocumentDetailResponse {
    private UUID id;
    private UUID groupId;
    private String docType;
    private String documentNumber;
    private LocalDateTime uploadedAt;
    private List<DocumentVersionInfoResponse> versions;
}

