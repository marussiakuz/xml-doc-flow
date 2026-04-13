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
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import ru.artwell.contractor.api.ContractorApi;
import ru.artwell.contractor.security.SecurityUser;
import ru.artwell.contractor.dto.DocumentCardResponse;
import ru.artwell.contractor.dto.DocumentPageResponse;
import ru.artwell.contractor.dto.DocumentResponse;
import ru.artwell.contractor.dto.DocumentSearchRequest;
import ru.artwell.contractor.dto.ErrorResponse;
import ru.artwell.contractor.dto.UploadDocumentResponse;
import ru.artwell.contractor.dto.VersionInfo;
import ru.artwell.contractor.dto.XmlDownload;
import ru.artwell.contractor.io.MultipartFiles;
import ru.artwell.contractor.service.DocumentService;

import java.nio.charset.StandardCharsets;
import java.util.List;

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
                    description = "Версия документа сохранена в БД (BYTEA). При `validationStatus=VALID` — XSD пройден; при `INVALID_*` — в теле `validationErrors` и `valid=false`. HTTP 400 не используется для результата валидации",
                    content = @Content(schema = @Schema(implementation = UploadDocumentResponse.class))),
            @ApiResponse(
                    responseCode = "400",
                    description = "Не удалось прочитать файл из multipart (`MultipartFileReadException`, тело `ErrorResponse`)",
                    content = @Content(schema = @Schema(implementation = ErrorResponse.class)))
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
            @RequestPart("file") MultipartFile file,
            @AuthenticationPrincipal @Parameter(hidden = true) SecurityUser currentUser
    ) {
        UploadDocumentResponse resp = documentService.uploadXml(
                MultipartFiles.readBytes(file),
                file.getOriginalFilename(),
                currentUser.getUser());
        return ResponseEntity.status(HttpStatus.CREATED).body(resp);
    }

    @Operation(summary = "Поиск документов с фильтрацией и пагинацией (JSON)")
    @ApiResponses({
            @ApiResponse(
                    responseCode = "200",
                    description = "Страница документов",
                    content = @Content(schema = @Schema(implementation = DocumentPageResponse.class))),
            @ApiResponse(
                    responseCode = "400",
                    description = "Невалидные параметры запроса",
                    content = @Content(schema = @Schema(implementation = ErrorResponse.class)))
    })
    @PostMapping(value = "/search", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<DocumentPageResponse> search(
            @Valid @RequestBody DocumentSearchRequest request,
            @AuthenticationPrincipal @Parameter(hidden = true) SecurityUser currentUser
    ) {
        Pageable pageable = request.toPageable();
        Page<DocumentResponse> page = documentService.getDocuments(request.toDocumentFilter(), pageable, currentUser.getUser());
        DocumentPageResponse body = new DocumentPageResponse(
                page.getContent(),
                page.getNumber(),
                page.getSize(),
                page.getTotalElements(),
                page.getTotalPages(),
                page.isLast(),
                page.isFirst()
        );
        return ResponseEntity.ok(body);
    }

    @Override
    @Operation(summary = "Карточка логического документа: объект, участники, версии, кто загрузил")
    @ApiResponses({
            @ApiResponse(
                    responseCode = "200",
                    description = "Полная карточка по идентификатору логического документа (documents.id)",
                    content = @Content(schema = @Schema(implementation = DocumentCardResponse.class))),
            @ApiResponse(
                    responseCode = "404",
                    description = "Документ не найден",
                    content = @Content(schema = @Schema(implementation = ErrorResponse.class)))
    })
    @GetMapping(value = "/{id}", produces = org.springframework.http.MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<DocumentCardResponse> getById(
            @Parameter(
                    name = "id",
                    in = ParameterIn.PATH,
                    description = "Идентификатор логического документа (documents.id), не id версии",
                    example = "13"
            )
            @PathVariable Long id,
            @AuthenticationPrincipal @Parameter(hidden = true) SecurityUser currentUser
    ) {
        return ResponseEntity.ok(documentService.getDocumentCard(id, currentUser.getUser()));
    }

    @Override
    @Operation(summary = "Список версий логического документа")
    @ApiResponses({
            @ApiResponse(
                    responseCode = "200",
                    description = "Версии в порядке убывания номера версии",
                    content = @Content(array = @ArraySchema(schema = @Schema(implementation = VersionInfo.class)))),
            @ApiResponse(
                    responseCode = "404",
                    description = "Документ не найден",
                    content = @Content(schema = @Schema(implementation = ErrorResponse.class)))
    })
    @GetMapping(value = "/{documentId}/versions", produces = org.springframework.http.MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<List<VersionInfo>> listVersions(
            @Parameter(name = "documentId", description = "Идентификатор логического документа (documents.id)")
            @PathVariable Long documentId,
            @AuthenticationPrincipal @Parameter(hidden = true) SecurityUser currentUser
    ) {
        return ResponseEntity.ok(documentService.listDocumentVersions(documentId, currentUser.getUser()));
    }

    @Override
    @Operation(summary = "Скачивание XML последней версии документа")
    @ApiResponses({
            @ApiResponse(
                    responseCode = "200",
                    description = "Тело ответа — содержимое XML",
                    content = @Content(mediaType = MediaType.APPLICATION_XML_VALUE)),
            @ApiResponse(
                    responseCode = "404",
                    description = "Документ или версии не найдены",
                    content = @Content(schema = @Schema(implementation = ErrorResponse.class)))
    })
    @GetMapping(value = "/{documentId}/versions/latest/download", produces = org.springframework.http.MediaType.APPLICATION_XML_VALUE)
    public ResponseEntity<byte[]> downloadLatestXml(
            @Parameter(name = "documentId", description = "Идентификатор логического документа (documents.id)")
            @PathVariable Long documentId,
            @AuthenticationPrincipal @Parameter(hidden = true) SecurityUser currentUser
    ) {
        XmlDownload dl = documentService.downloadLatestXml(documentId, currentUser.getUser());
        return downloadXmlResponse(dl.content(), dl.fileName());
    }

    @Override
    @Operation(summary = "Скачивание XML конкретной версии документа")
    @ApiResponses({
            @ApiResponse(
                    responseCode = "200",
                    description = "Тело ответа — содержимое XML",
                    content = @Content(mediaType = MediaType.APPLICATION_XML_VALUE)),
            @ApiResponse(
                    responseCode = "404",
                    description = "Документ или версия не найдены, либо версия не относится к документу",
                    content = @Content(schema = @Schema(implementation = ErrorResponse.class)))
    })
    @GetMapping(value = "/{documentId}/versions/{versionId}/download", produces = org.springframework.http.MediaType.APPLICATION_XML_VALUE)
    public ResponseEntity<byte[]> downloadXmlByDocumentAndVersion(
            @Parameter(name = "documentId", description = "Идентификатор логического документа (documents.id)")
            @PathVariable Long documentId,
            @Parameter(name = "versionId", description = "Идентификатор версии (document_versions.id)")
            @PathVariable Long versionId,
            @AuthenticationPrincipal @Parameter(hidden = true) SecurityUser currentUser
    ) {
        XmlDownload dl = documentService.downloadXml(documentId, versionId, currentUser.getUser());
        return downloadXmlResponse(dl.content(), dl.fileName());
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
                    example = "1"
            )
            @PathVariable Long id,
            @AuthenticationPrincipal @Parameter(hidden = true) SecurityUser currentUser
    ) {
        XmlDownload dl = documentService.downloadXml(id, currentUser.getUser());
        return downloadXmlResponse(dl.content(), dl.fileName());
    }

    private static ResponseEntity<byte[]> downloadXmlResponse(byte[] bytes, String originalFileName) {
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(org.springframework.http.MediaType.APPLICATION_XML);
        String safeName = (originalFileName == null || originalFileName.isBlank())
                ? "document.xml"
                : originalFileName.trim();
        ContentDisposition disposition = ContentDisposition.attachment()
                .filename(safeName, StandardCharsets.UTF_8)
                .build();
        headers.setContentDisposition(disposition);
        return new ResponseEntity<>(bytes, headers, HttpStatus.OK);
    }

    @Override
    @Operation(summary = "Замена XML: новая версия при совпадении типа и номера документа")
    @ApiResponses({
            @ApiResponse(
                    responseCode = "200",
                    description = "Новая версия сохранена. При `validationStatus=VALID` — XSD пройден; при `INVALID_*` — ошибки в `validationErrors`. HTTP 400 не используется для результата валидации",
                    content = @Content(schema = @Schema(implementation = UploadDocumentResponse.class))),
            @ApiResponse(
                    responseCode = "400",
                    description = "Ошибка чтения файла из multipart (`ErrorResponse`)",
                    content = @Content(schema = @Schema(implementation = ErrorResponse.class))),
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
                    example = "1"
            )
            @PathVariable Long id,
            @Parameter(
                    name = "file",
                    in = ParameterIn.DEFAULT,
                    description = "Новый XML той же схемы с тем же номером документа",
                    example = "document.xml"
            )
            @RequestPart("file") MultipartFile file,
            @AuthenticationPrincipal @Parameter(hidden = true) SecurityUser currentUser
    ) {
        UploadDocumentResponse resp = documentService.replaceXml(
                id,
                MultipartFiles.readBytes(file),
                file.getOriginalFilename(),
                currentUser.getUser());
        return ResponseEntity.ok(resp);
    }
}
