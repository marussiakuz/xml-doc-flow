package ru.artwell.contractor.dto;

import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
public class DocumentVersionInfoResponse {
    private Long id;
    private int version;
    private Long previousVersionId;
    private LocalDateTime uploadedAt;

    public DocumentVersionInfoResponse(Long id, int version, Long previousVersionId, LocalDateTime uploadedAt) {
        this.id = id;
        this.version = version;
        this.previousVersionId = previousVersionId;
        this.uploadedAt = uploadedAt;
    }
}
