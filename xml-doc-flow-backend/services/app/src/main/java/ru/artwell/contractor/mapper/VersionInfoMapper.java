package ru.artwell.contractor.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import ru.artwell.contractor.dto.VersionInfo;
import ru.artwell.contractor.persistence.entity.DocumentVersionEntity;

@Mapper(componentModel = "spring")
public interface VersionInfoMapper {

    @Mapping(target = "versionId", source = "v.id")
    @Mapping(target = "versionNumber", source = "v.versionNumber")
    @Mapping(target = "uploadedAt", source = "v.uploadedAt")
    @Mapping(target = "validationStatus", expression = "java(v.getValidationStatus() != null ? v.getValidationStatus().name() : null)")
    @Mapping(target = "isCurrent", expression = "java(v.getVersionNumber() == documentCurrentVersion)")
    @Mapping(target = "downloadUrl", expression = "java(versionDownloadUrl(documentId, v.getId()))")
    VersionInfo toVersionInfo(DocumentVersionEntity v, int documentCurrentVersion, Long documentId);

    default String versionDownloadUrl(Long documentId, Long versionId) {
        return "/api/documents/" + documentId + "/versions/" + versionId + "/download";
    }
}
