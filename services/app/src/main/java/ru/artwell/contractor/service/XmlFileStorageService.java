package ru.artwell.contractor.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;

@Service
public class XmlFileStorageService {

    private final Path root;

    public XmlFileStorageService(@Value("${app.storage.xml-root}") String xmlRoot) {
        this.root = Paths.get(xmlRoot).toAbsolutePath().normalize();
    }

    /**
     * Сохраняет XML и возвращает путь относительно {@code app.storage.xml-root} (с '/' как разделителем).
     */
    public String store(long documentId, int versionNumber, byte[] content) throws IOException {
        Path dir = root.resolve("doc-" + documentId);
        Files.createDirectories(dir);
        Path file = dir.resolve("v" + versionNumber + ".xml");
        Files.write(file, content, StandardOpenOption.CREATE, StandardOpenOption.TRUNCATE_EXISTING);
        return root.relativize(file).toString().replace('\\', '/');
    }

    public byte[] load(String relativePath) throws IOException {
        Path file = root.resolve(relativePath).normalize();
        if (!file.startsWith(root)) {
            throw new SecurityException("Недопустимый путь к файлу");
        }
        return Files.readAllBytes(file);
    }
}
