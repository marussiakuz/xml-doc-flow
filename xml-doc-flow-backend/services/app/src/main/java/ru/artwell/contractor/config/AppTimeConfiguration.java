package ru.artwell.contractor.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.time.ZoneId;

/**
 * Часовой пояс приложения задаётся в {@code app.time-zone} (см. {@code application.yml}).
 */
@Configuration
public class AppTimeConfiguration {

    public static final String APPLICATION_ZONE_ID = "applicationZoneId";

    @Bean(name = APPLICATION_ZONE_ID)
    public ZoneId applicationZoneId(@Value("${app.time-zone:Europe/Moscow}") String timeZoneId) {
        return ZoneId.of(timeZoneId);
    }
}
