package ru.artwell.contractor.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import ru.artwell.contractor.dto.DocumentLinks;
import ru.artwell.contractor.dto.DocumentResponse;
import ru.artwell.contractor.persistence.entity.DocumentEntity;
import ru.artwell.contractor.persistence.entity.DocumentVersionEntity;

@Mapper(componentModel = "spring", uses = {
        DocumentTypeMapper.class,
        ConstructionObjectDtoMapper.class,
        UserPresentationMapper.class
})
public interface DocumentListItemMapper {

    @Mapping(target = "versionId", source = "ver.id")
    @Mapping(target = "documentId", source = "doc.id")
    @Mapping(target = "documentNumber", source = "doc.documentNumber")
    @Mapping(target = "documentDate", source = "doc.documentDate")
    @Mapping(target = "title", source = "doc.title")
    @Mapping(target = "documentType", source = "doc.documentType")
    @Mapping(target = "constructionObject", source = "doc.constructionObject")
    @Mapping(target = "currentVersion", source = "doc.currentVersion")
    @Mapping(target = "latestVersion", source = "doc.latestVersion")
    @Mapping(target = "validationStatus", expression = "java(ver.getValidationStatus() != null ? ver.getValidationStatus().name() : null)")
    @Mapping(target = "status", source = "doc.status")
    @Mapping(target = "uploadedBy", source = "doc.uploadedBy")
    @Mapping(target = "uploadedAt", source = "doc.uploadedAt")
    @Mapping(target = "xmlFileName", source = "ver.xmlFileName")
    @Mapping(target = "xmlFileSize", source = "ver.xmlFileSize")
    @Mapping(target = "links", expression = "java(documentLinks(doc.getId(), ver.getId()))")
    DocumentResponse toDocumentResponse(DocumentEntity doc, DocumentVersionEntity ver);

    default DocumentLinks documentLinks(Long documentId, Long versionId) {
        String base = "/api/documents/" + documentId;
        return new DocumentLinks(
                base + "/versions/" + versionId + "/download",
                base + "/versions",
                base
        );
    }
}
