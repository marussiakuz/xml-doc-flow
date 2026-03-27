package ru.artwell.contractor.api.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.enums.ParameterIn;
import io.swagger.v3.oas.annotations.media.ArraySchema;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.http.ContentDisposition;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import ru.artwell.contractor.api.ContractorApi;
import ru.artwell.contractor.dto.DocumentDetailResponse;
import ru.artwell.contractor.dto.DocumentListItemResponse;
import ru.artwell.contractor.dto.ErrorResponse;
import ru.artwell.contractor.dto.UploadDocumentResponse;
import ru.artwell.contractor.io.MultipartFiles;
import ru.artwell.contractor.service.DocumentService;

import java.util.List;
import java.util.UUID;

@Tag(name = "01. API загрузки строительных документов", description = "Загрузка XML, валидация по XSD, версионирование и выдача документов")
@RestController
@RequestMapping("/api/documents")
public class DocumentController implements ContractorApi {

    private final DocumentService documentService;

    public DocumentController(DocumentService documentService) {
        this.documentService = documentService;
    }

    @Override
    @Operation(summary = "Загрузка XML: определение типа по корню, XSD-валидация, сохранение")
    @ApiResponses({
            @ApiResponse(
                    responseCode = "201",
                    description = "Документ успешно сохранён. В ответе есть `validationStatus=VALID` и `documentNumber` (UUID) для группировки версий",
                    content = @Content(schema = @Schema(implementation = UploadDocumentResponse.class))),
            @ApiResponse(
                    responseCode = "400",
                    description = "Документ сохранён как невалидный (в ответе `validationStatus=INVALID_*` и список ошибок в `validationErrors`). Ошибка чтения multipart/некорректный XML могут вернуться как ErrorResponse",
                    content = @Content(schema = @Schema(implementation = UploadDocumentResponse.class)))
    })
    @PostMapping(
            consumes = org.springframework.http.MediaType.MULTIPART_FORM_DATA_VALUE,
            produces = org.springframework.http.MediaType.APPLICATION_JSON_VALUE
    )
    public ResponseEntity<UploadDocumentResponse> upload(
            @Parameter(
                    name = "file",
                    in = ParameterIn.DEFAULT,
                    description = "Файл экземпляра XML-документа (не XSL/XSD/SVG)",
                    example = "document.xml"
            )
            @RequestPart("file") MultipartFile file
    ) {
        UploadDocumentResponse resp = documentService.uploadXml(MultipartFiles.readBytes(file));
        if (resp.isValid()) {
            return ResponseEntity.status(HttpStatus.CREATED).body(resp);
        }
        return ResponseEntity.badRequest().body(resp);
    }

    @Override
    @Operation(summary = "Список документов: по одной актуальной версии на каждый номер документа")
    @ApiResponses({
            @ApiResponse(
                    responseCode = "200",
                    description = "Список найденных документов",
                    content = @Content(array = @ArraySchema(schema = @Schema(implementation = DocumentListItemResponse.class))))
    })
    @GetMapping(produces = org.springframework.http.MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<List<DocumentListItemResponse>> list(
            @Parameter(
                    name = "docType",
                    in = ParameterIn.QUERY,
                    description = "Фильтр по коду типа документа (как в каталоге XSD), без фильтра — все типы",
                    example = "AOSR"
            )
            @RequestParam(name = "docType", required = false) String docType,
            @Parameter(
                    name = "documentNumber",
                    in = ParameterIn.QUERY,
                    description = "Фильтр по `documentNumber` (UUID), который возвращается в UploadDocumentResponse. Без фильтра — все документы",
                    example = "550e8400-e29b-41d4-a716-446655440000"
            )
            @RequestParam(name = "documentNumber", required = false) String documentNumber
    ) {
        return ResponseEntity.ok(documentService.listLatestVersions(docType, documentNumber));
    }

    @Override
    @Operation(summary = "Карточка документа по id версии и история версий в группе")
    @ApiResponses({
            @ApiResponse(
                    responseCode = "200",
                    description = "Детали документа и список версий",
                    content = @Content(schema = @Schema(implementation = DocumentDetailResponse.class))),
            @ApiResponse(
                    responseCode = "404",
                    description = "Версия документа с указанным id не найдена",
                    content = @Content(schema = @Schema(implementation = ErrorResponse.class)))
    })
    @GetMapping(value = "/{id}", produces = org.springframework.http.MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<DocumentDetailResponse> getById(
            @Parameter(
                    name = "id",
                    in = ParameterIn.PATH,
                    description = "Идентификатор сохранённой версии документа (UUID)",
                    example = "550e8400-e29b-41d4-a716-446655440000"
            )
            @PathVariable UUID id
    ) {
        return ResponseEntity.ok(documentService.getDetail(id));
    }

    @Override
    @Operation(summary = "Скачивание исходного XML по id версии")
    @ApiResponses({
            @ApiResponse(
                    responseCode = "200",
                    description = "Тело ответа — содержимое XML, Content-Disposition: attachment",
                    content = @Content(mediaType = MediaType.APPLICATION_XML_VALUE)),
            @ApiResponse(
                    responseCode = "404",
                    description = "Документ не найден",
                    content = @Content(schema = @Schema(implementation = ErrorResponse.class)))
    })
    @GetMapping(value = "/{id}/xml", produces = org.springframework.http.MediaType.APPLICATION_XML_VALUE)
    public ResponseEntity<byte[]> downloadXml(
            @Parameter(
                    name = "id",
                    in = ParameterIn.PATH,
                    description = "Идентификатор версии документа для скачивания XML",
                    example = "550e8400-e29b-41d4-a716-446655440000"
            )
            @PathVariable UUID id
    ) {
        byte[] bytes = documentService.downloadXml(id);
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(org.springframework.http.MediaType.APPLICATION_XML);

        ContentDisposition disposition = ContentDisposition.attachment()
                .filename("document-" + id + ".xml")
                .build();
        headers.setContentDisposition(disposition);

        return new ResponseEntity<>(bytes, headers, HttpStatus.OK);
    }

    @Override
    @Operation(summary = "Замена XML: новая версия при совпадении типа и номера документа")
    @ApiResponses({
            @ApiResponse(
                    responseCode = "200",
                    description = "Новая версия успешно сохранена (validationStatus=VALID)",
                    content = @Content(schema = @Schema(implementation = UploadDocumentResponse.class))),
            @ApiResponse(
                    responseCode = "400",
                    description = "Новая версия сохранена как невалидная (validationStatus=INVALID_* и validationErrors) либо ошибка чтения файла (ErrorResponse)",
                    content = @Content(schema = @Schema(implementation = UploadDocumentResponse.class))),
            @ApiResponse(
                    responseCode = "404",
                    description = "Версия с указанным id не найдена",
                    content = @Content(schema = @Schema(implementation = ErrorResponse.class))),
            @ApiResponse(
                    responseCode = "409",
                    description = "Конфликт (validationStatus=INVALID_CONFLICT): другой тип/номер относительно выбранной версии",
                    content = @Content(schema = @Schema(implementation = UploadDocumentResponse.class)))
    })
    @PutMapping(
            value = "/{id}/replace",
            consumes = org.springframework.http.MediaType.MULTIPART_FORM_DATA_VALUE,
            produces = org.springframework.http.MediaType.APPLICATION_JSON_VALUE
    )
    public ResponseEntity<UploadDocumentResponse> replace(
            @Parameter(
                    name = "id",
                    in = ParameterIn.PATH,
                    description = "Id существующей версии документа, от которой ведётся замена",
                    example = "550e8400-e29b-41d4-a716-446655440000"
            )
            @PathVariable UUID id,
            @Parameter(
                    name = "file",
                    in = ParameterIn.DEFAULT,
                    description = "Новый XML той же схемы с тем же номером документа",
                    example = "document.xml"
            )
            @RequestPart("file") MultipartFile file
    ) {
        UploadDocumentResponse resp = documentService.replaceXml(id, MultipartFiles.readBytes(file));
        if (resp.isValid()) {
            return ResponseEntity.ok(resp);
        }
        return ResponseEntity.badRequest().body(resp);
    }
}
