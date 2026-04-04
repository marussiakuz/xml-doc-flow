package ru.artwell.contractor.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class DocumentVersionInfoResponse {
    private Long id;
    private int version;
    private Long previousVersionId;
    private LocalDateTime uploadedAt;
}
