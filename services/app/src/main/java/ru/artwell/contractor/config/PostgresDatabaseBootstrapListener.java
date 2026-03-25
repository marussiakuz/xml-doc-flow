package ru.artwell.contractor.config;

import org.springframework.boot.context.event.ApplicationEnvironmentPreparedEvent;
import org.springframework.context.ApplicationListener;
import org.springframework.core.env.Environment;

/**
 * Выполняется до создания контекста и DataSource: при необходимости создаёт БД PostgreSQL.
 */
public class PostgresDatabaseBootstrapListener implements ApplicationListener<ApplicationEnvironmentPreparedEvent> {

    @Override
    public void onApplicationEvent(ApplicationEnvironmentPreparedEvent event) {
        Environment env = event.getEnvironment();
        String url = env.getProperty("spring.datasource.url");
        String username = env.getProperty("spring.datasource.username");
        String password = env.getProperty("spring.datasource.password");
        PostgresDatabaseBootstrap.ensureDatabaseExistsIfNeeded(url, username, password);
    }
}
