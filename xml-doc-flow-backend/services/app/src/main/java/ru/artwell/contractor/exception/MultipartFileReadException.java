package ru.artwell.contractor.exception;

import java.io.IOException;

/**
 * Не удалось прочитать тело загруженного multipart-файла (например, обрыв потока или повреждённые данные).
 */
public class MultipartFileReadException extends RuntimeException {

    public MultipartFileReadException(IOException cause) {
        super(cause);
    }
}
