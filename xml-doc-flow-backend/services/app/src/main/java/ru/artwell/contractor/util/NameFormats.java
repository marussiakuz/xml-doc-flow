package ru.artwell.contractor.util;

/**
 * Форматирование ФИО для UI.
 */
public final class NameFormats {
    private NameFormats() {
    }

    /**
     * Преобразует "Фамилия Имя Отчество" → "Фамилия И.О.".
     * <p>
     * Если частей меньше — возвращает "Фамилия И." или "Фамилия".
     */
    public static String toLastNameWithInitials(String fullName) {
        if (fullName == null) {
            return null;
        }
        String trimmed = fullName.trim();
        if (trimmed.isEmpty()) {
            return trimmed;
        }

        String[] parts = trimmed.split("\\s+");
        if (parts.length == 0) {
            return trimmed;
        }

        String last = parts[0];
        StringBuilder sb = new StringBuilder(last);

        if (parts.length > 1) {
            String first = parts[1];
            if (!first.isBlank()) {
                sb.append(' ').append(Character.toUpperCase(first.charAt(0))).append('.');
            }
        }
        if (parts.length > 2) {
            String middle = parts[2];
            if (!middle.isBlank()) {
                sb.append(Character.toUpperCase(middle.charAt(0))).append('.');
            }
        }
        return sb.toString();
    }
}

