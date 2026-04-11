package ru.artwell.contractor.dto;

import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
public class VersionInfo {
    private Long versionId;
    private Integer versionNumber;
    private LocalDateTime uploadedAt;
    private String validationStatus;
    private Boolean isCurrent;
    private String downloadUrl;

    public VersionInfo(Long versionId, Integer versionNumber, LocalDateTime uploadedAt, String validationStatus,
                       Boolean isCurrent, String downloadUrl) {
        this.versionId = versionId;
        this.versionNumber = versionNumber;
        this.uploadedAt = uploadedAt;
        this.validationStatus = validationStatus;
        this.isCurrent = isCurrent;
        this.downloadUrl = downloadUrl;
    }
}
