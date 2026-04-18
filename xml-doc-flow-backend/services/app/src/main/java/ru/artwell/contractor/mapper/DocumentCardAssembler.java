package ru.artwell.contractor.mapper;

import org.springframework.stereotype.Component;
import ru.artwell.contractor.dto.DocumentCardResponse;
import ru.artwell.contractor.dto.ParticipantInfo;
import ru.artwell.contractor.dto.UserInfo;
import ru.artwell.contractor.dto.VersionInfo;
import ru.artwell.contractor.dto.WorkVolumeInfo;
import ru.artwell.contractor.persistence.entity.DocumentEntity;
import ru.artwell.contractor.persistence.entity.DocumentVersionEntity;

import java.util.List;

/**
 * Сборка карточки документа из нескольких сущностей и уже смапленных коллекций.
 */
@Component
public class DocumentCardAssembler {

    private final ConstructionObjectInfoMapper constructionObjectInfoMapper;
    private final UserPresentationMapper userPresentationMapper;

    public DocumentCardAssembler(ConstructionObjectInfoMapper constructionObjectInfoMapper,
                                 UserPresentationMapper userPresentationMapper) {
        this.constructionObjectInfoMapper = constructionObjectInfoMapper;
        this.userPresentationMapper = userPresentationMapper;
    }

    public DocumentCardResponse toCard(
            DocumentEntity document,
            DocumentVersionEntity currentVersion,
            List<ParticipantInfo> participants,
            List<VersionInfo> versions,
            List<WorkVolumeInfo> workVolumes
    ) {
        UserInfo uploadedBy = userPresentationMapper.toUserInfo(document.getUploadedBy());
        return new DocumentCardResponse(
                document.getId(),
                document.getDocumentNumber(),
                document.getDocumentDate(),
                document.getDocumentType().getTypeCode(),
                document.getDocumentType().getTypeName(),
                constructionObjectInfoMapper.toInfo(document.getConstructionObject()),
                participants,
                document.getCurrentVersion(),
                document.getUploadedAt(),
                uploadedBy,
                versions,
                document.getStatus(),
                currentVersion.getValidationStatus().name(),
                workVolumes
        );
    }
}
