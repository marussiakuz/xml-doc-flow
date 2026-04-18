package ru.artwell.contractor.config;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

/**
 * Подключается к служебной БД {@code postgres} и создаёт целевую БД, если её ещё нет.
 * Нужно, чтобы приложение стартовало без ручного {@code CREATE DATABASE}.
 */
public final class PostgresDatabaseBootstrap {

    private static final Logger log = LoggerFactory.getLogger(PostgresDatabaseBootstrap.class);

    private PostgresDatabaseBootstrap() {
    }

    public static void ensureDatabaseExistsIfNeeded(String jdbcUrl, String username, String password) {
        if (jdbcUrl == null || !jdbcUrl.startsWith("jdbc:postgresql:")) {
            return;
        }

        ParsedPostgresUrl parsed = parsePostgresUrl(jdbcUrl);
        if (parsed == null) {
            log.warn("Не удалось распарсить JDBC URL PostgreSQL, пропуск предсоздания БД");
            return;
        }

        if (!isSafeIdentifier(parsed.database())) {
            log.warn("Небезопасное имя БД в URL, пропуск предсоздания: {}", parsed.database());
            return;
        }
        if (!isSafeIdentifier(username)) {
            log.warn("Небезопасное имя пользователя, пропуск предсоздания БД");
            return;
        }

        if ("postgres".equalsIgnoreCase(parsed.database())) {
            return;
        }

        String maintenanceUrl = buildMaintenanceUrl(parsed);
        String safePassword = password == null ? "" : password;

        try (Connection conn = DriverManager.getConnection(maintenanceUrl, username, safePassword)) {
            conn.setAutoCommit(true);
            if (databaseExists(conn, parsed.database())) {
                log.debug("База данных '{}' уже существует", parsed.database());
                return;
            }
            createDatabase(conn, parsed.database(), username);
            log.info("Создана база данных '{}'", parsed.database());
        } catch (SQLException e) {
            log.error("Не удалось предсоздать БД '{}': {}", parsed.database(), e.getMessage());
            throw new IllegalStateException(
                    "Не удалось создать БД '" + parsed.database()
                            + "'. Убедитесь, что PostgreSQL запущен и у пользователя есть право на создание БД. "
                            + "Причина: " + e.getMessage(), e);
        }
    }

    private static boolean databaseExists(Connection conn, String dbName) throws SQLException {
        try (PreparedStatement ps = conn.prepareStatement("SELECT 1 FROM pg_database WHERE datname = ?")) {
            ps.setString(1, dbName);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    private static void createDatabase(Connection conn, String dbName, String owner) throws SQLException {
        String sql = "CREATE DATABASE " + dbName + " WITH OWNER " + owner + " ENCODING 'UTF8'";
        try (Statement st = conn.createStatement()) {
            st.executeUpdate(sql);
        }
    }

    private static boolean isSafeIdentifier(String s) {
        return s != null && s.matches("[a-zA-Z_][a-zA-Z0-9_]*");
    }

    private static String buildMaintenanceUrl(ParsedPostgresUrl parsed) {
        StringBuilder sb = new StringBuilder();
        sb.append("jdbc:postgresql://").append(parsed.host()).append(":").append(parsed.port()).append("/postgres");
        if (parsed.querySuffix() != null && !parsed.querySuffix().isEmpty()) {
            sb.append("?").append(parsed.querySuffix());
        }
        return sb.toString();
    }

    private static ParsedPostgresUrl parsePostgresUrl(String jdbcUrl) {
        try {
            String rest = jdbcUrl.substring("jdbc:postgresql://".length());
            int q = rest.indexOf('?');
            String querySuffix = q >= 0 ? rest.substring(q + 1) : null;
            if (q >= 0) {
                rest = rest.substring(0, q);
            }
            int slash = rest.indexOf('/');
            if (slash <= 0 || slash == rest.length() - 1) {
                return null;
            }
            String hostPort = rest.substring(0, slash);
            String database = rest.substring(slash + 1);
            if (database.isBlank()) {
                return null;
            }

            String host;
            int port = 5432;
            if (hostPort.startsWith("[")) {
                int close = hostPort.indexOf(']');
                if (close < 0) {
                    return null;
                }
                host = hostPort.substring(0, close + 1);
                if (close + 1 < hostPort.length() && hostPort.charAt(close + 1) == ':') {
                    port = Integer.parseInt(hostPort.substring(close + 2));
                }
            } else if (hostPort.contains(":")) {
                int lastColon = hostPort.lastIndexOf(':');
                host = hostPort.substring(0, lastColon);
                port = Integer.parseInt(hostPort.substring(lastColon + 1));
            } else {
                host = hostPort;
            }

            return new ParsedPostgresUrl(host, port, database, querySuffix);
        } catch (Exception e) {
            log.debug("Ошибка разбора URL: {}", e.toString());
            return null;
        }
    }

    private static final class ParsedPostgresUrl {
        private final String host;
        private final int port;
        private final String database;
        private final String querySuffix;

        private ParsedPostgresUrl(String host, int port, String database, String querySuffix) {
            this.host = host;
            this.port = port;
            this.database = database;
            this.querySuffix = querySuffix;
        }

        String host() {
            return host;
        }

        int port() {
            return port;
        }

        String database() {
            return database;
        }

        String querySuffix() {
            return querySuffix;
        }
    }
}
