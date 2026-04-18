package ru.artwell.contractor.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import ru.artwell.contractor.dto.UploadDocumentResponse;
import ru.artwell.contractor.dto.ValidationErrorDto;
import ru.artwell.contractor.persistence.entity.DocumentEntity;
import ru.artwell.contractor.persistence.entity.DocumentValidationStatus;
import ru.artwell.contractor.persistence.entity.DocumentVersionEntity;

import java.util.List;

@Mapper(componentModel = "spring")
public interface UploadDocumentMapper {

    @Mapping(target = "id", source = "saved.id")
    @Mapping(target = "documentId", source = "document.id")
    @Mapping(target = "docType", source = "document.documentType.typeCode")
    @Mapping(target = "docTypeName", source = "document.documentType.typeName")
    @Mapping(target = "documentNumber", source = "document.documentNumber")
    @Mapping(target = "version", source = "saved.versionNumber")
    @Mapping(target = "uploadedAt", source = "saved.uploadedAt")
    @Mapping(target = "valid", source = "valid")
    @Mapping(target = "validationStatus", source = "validationStatus")
    @Mapping(target = "validationErrors", source = "errors")
    UploadDocumentResponse toUploadResponse(
            DocumentVersionEntity saved,
            DocumentEntity document,
            boolean valid,
            DocumentValidationStatus validationStatus,
            List<ValidationErrorDto> errors
    );
}
