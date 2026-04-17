package ru.artwell.contractor.dto;

import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;

@Data
@NoArgsConstructor
public class DocumentDetailResponse {
    private Long id;
    private Long documentId;
    private String docType;
    private String documentNumber;
    private LocalDateTime uploadedAt;
    private List<DocumentVersionInfoResponse> versions;

    public DocumentDetailResponse(Long id, Long documentId, String docType, String documentNumber, LocalDateTime uploadedAt,
                                  List<DocumentVersionInfoResponse> versions) {
        this.id = id;
        this.documentId = documentId;
        this.docType = docType;
        this.documentNumber = documentNumber;
        this.uploadedAt = uploadedAt;
        this.versions = versions;
    }
}
