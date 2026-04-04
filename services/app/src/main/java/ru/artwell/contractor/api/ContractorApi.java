package ru.artwell.contractor.api;

import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import ru.artwell.contractor.dto.DocumentDetailResponse;
import ru.artwell.contractor.dto.DocumentListItemResponse;
import ru.artwell.contractor.dto.UploadDocumentResponse;

import java.util.List;

@RequestMapping("/api/documents")
public interface ContractorApi {

    @PostMapping(consumes = MediaType.MULTIPART_FORM_DATA_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    ResponseEntity<UploadDocumentResponse> upload(@RequestPart("file") MultipartFile file);

    @GetMapping(produces = MediaType.APPLICATION_JSON_VALUE)
    ResponseEntity<List<DocumentListItemResponse>> list(
            @RequestParam(name = "docType", required = false) String docType,
            @RequestParam(name = "documentNumber", required = false) String documentNumber
    );

    @GetMapping(value = "/{id}", produces = MediaType.APPLICATION_JSON_VALUE)
    ResponseEntity<DocumentDetailResponse> getById(@PathVariable Long id);

    @GetMapping(value = "/{id}/xml", produces = MediaType.APPLICATION_XML_VALUE)
    ResponseEntity<byte[]> downloadXml(@PathVariable Long id);

    @PutMapping(value = "/{id}/replace", consumes = MediaType.MULTIPART_FORM_DATA_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    ResponseEntity<UploadDocumentResponse> replace(
            @PathVariable Long id,
            @RequestPart("file") MultipartFile file
    );
}
