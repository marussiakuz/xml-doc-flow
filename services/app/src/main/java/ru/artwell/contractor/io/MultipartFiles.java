package ru.artwell.contractor.io;

import org.springframework.web.multipart.MultipartFile;
import ru.artwell.contractor.exception.MultipartFileReadException;

import java.io.IOException;

public final class MultipartFiles {

    private MultipartFiles() {
    }

    public static byte[] readBytes(MultipartFile file) {
        try {
            return file.getBytes();
        } catch (IOException e) {
            throw new MultipartFileReadException(e);
        }
    }
}
