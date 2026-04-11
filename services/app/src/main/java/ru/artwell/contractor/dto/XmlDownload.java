package ru.artwell.contractor.dto;

/**
 * Результат выдачи исходного XML: тело и имя файла для {@code Content-Disposition}.
 */
public record XmlDownload(byte[] content, String fileName) {
}
