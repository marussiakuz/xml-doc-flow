-- Удаление неиспользуемых уведомлений.
-- В проекте не подключён Flyway/Liquibase, поэтому скрипт выполняется вручную один раз.

DROP TABLE IF EXISTS notifications;

