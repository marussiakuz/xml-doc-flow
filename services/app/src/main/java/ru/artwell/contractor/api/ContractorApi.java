package ru.artwell.contractor.api;

import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.multipart.MultipartFile;
import ru.artwell.contractor.dto.DocumentCardResponse;
import ru.artwell.contractor.dto.UploadDocumentResponse;
import ru.artwell.contractor.dto.VersionInfo;
import ru.artwell.contractor.security.SecurityUser;

import java.util.List;

@RequestMapping("/api/documents")
public interface ContractorApi {

    @PostMapping(consumes = MediaType.MULTIPART_FORM_DATA_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    ResponseEntity<UploadDocumentResponse> upload(
            @RequestPart("file") MultipartFile file,
            @AuthenticationPrincipal SecurityUser currentUser);

    @GetMapping(value = "/{id}", produces = MediaType.APPLICATION_JSON_VALUE)
    ResponseEntity<DocumentCardResponse> getById(
            @PathVariable Long id,
            @AuthenticationPrincipal SecurityUser currentUser);

    @GetMapping(value = "/{documentId}/versions", produces = MediaType.APPLICATION_JSON_VALUE)
    ResponseEntity<List<VersionInfo>> listVersions(
            @PathVariable Long documentId,
            @AuthenticationPrincipal SecurityUser currentUser);

    @GetMapping(value = "/{documentId}/versions/{versionId}/download", produces = MediaType.APPLICATION_XML_VALUE)
    ResponseEntity<byte[]> downloadXmlByDocumentAndVersion(
            @PathVariable Long documentId,
            @PathVariable Long versionId,
            @AuthenticationPrincipal SecurityUser currentUser);

    @GetMapping(value = "/{documentId}/versions/latest/download", produces = MediaType.APPLICATION_XML_VALUE)
    ResponseEntity<byte[]> downloadLatestXml(
            @PathVariable Long documentId,
            @AuthenticationPrincipal SecurityUser currentUser);

    @GetMapping(value = "/{id}/xml", produces = MediaType.APPLICATION_XML_VALUE)
    ResponseEntity<byte[]> downloadXml(
            @PathVariable Long id,
            @AuthenticationPrincipal SecurityUser currentUser);

    @PutMapping(value = "/{id}/replace", consumes = MediaType.MULTIPART_FORM_DATA_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    ResponseEntity<UploadDocumentResponse> replace(
            @PathVariable Long id,
            @RequestPart("file") MultipartFile file,
            @AuthenticationPrincipal SecurityUser currentUser);
}
