package ru.artwell.contractor.dto;

import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Data
@NoArgsConstructor
public class DocumentCardResponse {
    private Long documentId;
    private String documentNumber;
    private LocalDate documentDate;
    private String docType;
    private String docTypeName;
    private ConstructionObjectInfo constructionObject;
    private List<ParticipantInfo> participants;
    private Integer currentVersion;
    private LocalDateTime uploadedAt;
    private UserInfo uploadedBy;
    private List<VersionInfo> versions;
    private String status;
    /** Статус валидации актуальной версии ({@link ru.artwell.contractor.persistence.entity.VersionValidationStatus}). */
    private String validationStatus;
    private List<WorkVolumeInfo> workVolumes;

    public DocumentCardResponse(Long documentId, String documentNumber, LocalDate documentDate, String docType,
                                String docTypeName, ConstructionObjectInfo constructionObject,
                                List<ParticipantInfo> participants, Integer currentVersion, LocalDateTime uploadedAt,
                                UserInfo uploadedBy, List<VersionInfo> versions, String status, String validationStatus,
                                List<WorkVolumeInfo> workVolumes) {
        this.documentId = documentId;
        this.documentNumber = documentNumber;
        this.documentDate = documentDate;
        this.docType = docType;
        this.docTypeName = docTypeName;
        this.constructionObject = constructionObject;
        this.participants = participants;
        this.currentVersion = currentVersion;
        this.uploadedAt = uploadedAt;
        this.uploadedBy = uploadedBy;
        this.versions = versions;
        this.status = status;
        this.validationStatus = validationStatus;
        this.workVolumes = workVolumes;
    }
}
