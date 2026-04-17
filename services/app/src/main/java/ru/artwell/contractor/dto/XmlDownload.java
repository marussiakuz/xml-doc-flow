package ru.artwell.contractor.dto;

/**
 * Результат выдачи исходного XML: тело и имя файла.
 */
public record XmlDownload(byte[] content, String fileName) {
}
