# xml-doc-flow

## Что это
Сервис на Spring Boot для загрузки, определения типа и валидации строительных XML-документов по XSD (Минстрой РФ) с сохранением в PostgreSQL.

При старте приложения Hibernate создаёт минимальные таблицы, а содержимое XSD из `services/app/src/main/resources/validation-files/**.xsd` загружается в справочную таблицу `xsd_definitions`.

Если в `spring.datasource.url` указана БД PostgreSQL, которой ещё нет (например `xml_doc_flow`), приложение **до подключения Hibernate** подключается к служебной БД `postgres` и выполняет `CREATE DATABASE`, если база отсутствует. Нужны права на создание БД у пользователя из `spring.datasource.username` (в Docker-образе `postgres` это обычно так).

Часовой пояс для `LocalDateTime` и Jackson задаётся в `application.yml`: `app.time-zone` (по умолчанию `Europe/Moscow`). Переопределить можно тем же ключом через внешний конфиг, JVM-свойство `-Dapp.time-zone=UTC` или переменные Spring Boot для соответствующего свойства.

## Запуск
Требуется Docker Desktop.

1. Запуск стека:
   ```bash
   docker compose up --build
   ```
2. Swagger UI:
   - http://localhost:8080/swagger-ui.html
3. OpenAPI JSON:
   - http://localhost:8080/v3/api-docs

## API (5 эндпоинтов MVP)
Базовый URL: `/api/documents`

В загрузку нужно передавать **XML-документ** (экземпляр по схеме Минстроя: корень вида `aogrooks` в своём namespace и т.п.). Файлы **`.xsl` / `.xsd` / `.svg`** из `validation-files` — это шаблоны отображения и схемы, они **не являются** документом для валидации и будут отклонены с понятным сообщением.

1. Загрузка XML и валидация (с сохранением при успехе)
   ```bash
   curl -i -X POST "http://localhost:8080/api/documents" \
     -F "file=@/path/to/document.xml"
   ```

2. Список документов (актуальная версия по каждому документу)
   ```bash
   curl -i "http://localhost:8080/api/documents?docType=AOGROOKS&documentNumber=123"
   ```

3. Детальный просмотр документа по `id` (все версии)
   ```bash
   curl -i "http://localhost:8080/api/documents/<id>"
   ```

4. Скачивание XML по `id`
   ```bash
   curl -i -OJ "http://localhost:8080/api/documents/<id>/xml"
   ```

5. Замена XML с версионированием
   ```bash
   curl -i -X PUT "http://localhost:8080/api/documents/<id>/replace" \
     -F "file=@/path/to/document.xml"
   ```

## Схема базы данных (детальная)

### Описание таблиц

| Таблица | Назначение |
|---------|------------|
| `organizations` | Справочник организаций (юридических лиц) — застройщики, подрядчики, проектировщики, стройконтроль |
| `users` | Пользователи системы с ролевой моделью (7 ролей: ADMIN, CUSTOMER, TECH_CUSTOMER, CONTRACTOR, SUB_CONTRACTOR, DESIGNER, SUPERVISOR) |
| `construction_objects` | Объекты капитального строительства (здания, сооружения) с привязкой к участникам проекта |
| `document_types` | Справочник типов документов (21 тип по классификации Минстроя России) |
| `documents` | Основная таблица документов — хранит метаданные (номер, дата, тип, объект) |
| `document_versions` | Версии документов — хранит оригинальные XML-файлы и статусы валидации |
| `document_extended_attributes` | Гибкое хранилище для специфических полей XML (EAV-модель для полей, которых нет в основных таблицах) |
| `document_participants` | Участники документов (застройщик, подрядчик, проектировщик и др.) с реквизитами |
| `journal_entries` | Записи журналов работ (для журналов, которые содержат множество записей) |
| `work_volumes` | Объемы и суммы работ по документам (для агрегации и отчетов) |
| `role_document_permissions` | Права доступа ролей к типам документов (кто что может загружать, просматривать, редактировать) |
| `user_object_access` | Права доступа пользователей к объектам строительства (разграничение по объектам) |
| `role_assignment_history` | История назначения ролей пользователям (аудит изменений ролей) |
| `audit_log` | Журнал аудита всех действий пользователей (загрузка, просмотр, скачивание, удаление) |
| `notifications` | Системные уведомления для пользователей (валидация, новые версии, статусы) |

---

### ER-диаграмма

```mermaid
erDiagram
    organizations {
        bigserial id PK "уникальный идентификатор организации"
        varchar org_name "полное наименование организации"
        varchar org_short_name "краткое наименование"
        varchar org_type "тип: CUSTOMER/CONTRACTOR/DESIGNER/SUPERVISOR"
        varchar inn UK "ИНН организации"
        varchar kpp "КПП организации"
        text legal_address "юридический адрес"
        boolean is_active "активна / заблокирована"
    }

    users {
        bigserial id PK "уникальный идентификатор пользователя"
        varchar username UK "логин для входа"
        varchar password_hash "хеш пароля (BCrypt)"
        varchar full_name "ФИО пользователя"
        varchar role "основная роль: ADMIN/CUSTOMER/TECH_CUSTOMER/CONTRACTOR/SUB_CONTRACTOR/DESIGNER/SUPERVISOR"
        varchar[] additional_roles "дополнительные роли (массив)"
        bigint organization_id FK "ссылка на организацию (работодателя)"
        varchar email "email для уведомлений"
        boolean is_active "активен / заблокирован"
        timestamp last_login "дата и время последнего входа"
    }

    construction_objects {
        bigserial id PK "уникальный идентификатор объекта"
        varchar object_code UK "уникальный код объекта (для интеграции)"
        varchar object_name "наименование объекта строительства"
        text address "адрес объекта"
        bigint customer_id FK "заказчик (ссылка на пользователя)"
        bigint contractor_id FK "генеральный подрядчик"
        bigint designer_id FK "проектировщик"
        bigint supervisor_id FK "строительный контроль"
        varchar status "статус: active/suspended/completed/archived"
        date start_date "дата начала строительства"
        date end_date "плановая дата окончания"
    }

    document_types {
        bigserial id PK "уникальный идентификатор типа документа"
        varchar type_code UK "код типа документа (по классификации Минстроя)"
        varchar type_name "наименование типа документа"
        varchar category "категория: Исполнительная документация/Журналы/Строительный контроль"
        varchar xsd_schema_path "путь к XSD-схеме для валидации"
        boolean is_active "тип активен / отключен"
    }

    documents {
        bigserial id PK "уникальный идентификатор документа"
        varchar document_number "номер документа (из XML)"
        date document_date "дата документа (из XML)"
        bigint document_type_id FK "тип документа (ссылка на справочник)"
        bigint construction_object_id FK "объект строительства"
        varchar title "название документа"
        integer current_version "текущий номер версии"
        boolean is_latest_version "признак последней версии"
        bigint uploaded_by FK "кто загрузил документ"
        timestamp uploaded_at "дата и время загрузки"
        varchar status "статус: active/archived/replaced/deleted"
    }

    document_versions {
        bigserial id PK "уникальный идентификатор версии"
        bigint document_id FK "ссылка на документ"
        integer version_number "номер версии (начиная с 1)"
        varchar xml_file_path "путь к сохраненному XML-файлу"
        varchar xml_file_name "оригинальное имя файла"
        bigint xml_file_size "размер файла в байтах"
        varchar validation_status "статус валидации: pending/validating/valid/invalid/error"
        text validation_errors "текст ошибок валидации (если есть)"
        bigint uploaded_by FK "кто загрузил версию"
        timestamp uploaded_at "дата и время загрузки версии"
        bigint previous_version_id FK "ссылка на предыдущую версию (для цепочки)"
    }

    document_extended_attributes {
        bigserial id PK "уникальный идентификатор атрибута"
        bigint document_version_id FK "ссылка на версию документа"
        varchar attribute_name "название атрибута (поле из XML)"
        text attribute_value "значение атрибута"
        varchar attribute_type "тип данных: string/number/date/boolean/json/xml"
        varchar group_name "группа атрибутов (для связанных полей)"
    }

    document_participants {
        bigserial id PK "уникальный идентификатор участника"
        bigint document_version_id FK "ссылка на версию документа"
        varchar participant_role "роль: Застройщик/Подрядчик/Проектировщик и т.д."
        varchar participant_type "тип: legal/physical/organization"
        varchar participant_name "наименование организации или ФИО"
        varchar participant_inn "ИНН (для юридических лиц)"
        varchar participant_kpp "КПП (для юридических лиц)"
    }

    journal_entries {
        bigserial id PK "уникальный идентификатор записи журнала"
        bigint document_version_id FK "ссылка на версию документа (журнала)"
        integer entry_number "номер записи в журнале"
        date entry_date "дата записи"
        text work_description "описание выполненных работ"
        varchar performer_name "ФИО исполнителя / ответственного"
    }

    work_volumes {
        bigserial id PK "уникальный идентификатор объема работ"
        bigint document_version_id FK "ссылка на версию документа"
        varchar work_type "тип работ (код или наименование)"
        decimal quantity "объем работ (в единицах измерения)"
        decimal price "цена за единицу"
        decimal amount "общая сумма (quantity * price)"
    }

    role_document_permissions {
        bigserial id PK "уникальный идентификатор права"
        varchar role "роль пользователя"
        bigint document_type_id FK "тип документа"
        boolean can_upload "может загружать документы этого типа"
        boolean can_view "может просматривать документы"
        boolean can_edit "может редактировать"
        boolean can_delete "может удалять"
        boolean can_approve "может утверждать документы"
    }

    user_object_access {
        bigserial id PK "уникальный идентификатор доступа"
        bigint user_id FK "пользователь"
        bigint construction_object_id FK "объект строительства"
        varchar access_level "уровень доступа: read/write/admin"
    }

    role_assignment_history {
        bigserial id PK "уникальный идентификатор записи истории"
        bigint user_id FK "пользователь, чья роль изменилась"
        varchar old_role "старая роль"
        varchar new_role "новая роль"
        bigint changed_by FK "кто изменил роль (администратор)"
        timestamp changed_at "дата и время изменения"
    }

    audit_log {
        bigserial id PK "уникальный идентификатор записи аудита"
        bigint user_id FK "пользователь, совершивший действие"
        varchar username "логин пользователя (для быстрого поиска)"
        varchar action_type "тип действия: UPLOAD/VIEW/DOWNLOAD/UPDATE/DELETE/LOGIN/ROLE_CHANGE"
        varchar entity_type "тип сущности: DOCUMENT/VERSION/USER/OBJECT"
        bigint entity_id "ID сущности, с которой произведено действие"
        jsonb action_details "детали действия в формате JSON"
        inet ip_address "IP-адрес пользователя"
        timestamp created_at "дата и время действия"
    }

    notifications {
        bigserial id PK "уникальный идентификатор уведомления"
        bigint user_id FK "получатель уведомления"
        varchar notification_type "тип: DOCUMENT_VALIDATED/NEW_VERSION/STATUS_CHANGED/VALIDATION_ERROR"
        varchar title "заголовок уведомления"
        text message "текст уведомления"
        boolean is_read "прочитано / не прочитано"
        timestamp created_at "дата и время создания"
    }

    %% ==================== СВЯЗИ ====================
    organizations ||--o{ users : "имеет сотрудников"
    users ||--o{ documents : "загружает"
    users ||--o{ document_versions : "загружает версию"
    users ||--o{ audit_log : "совершает действия"
    users ||--o{ notifications : "получает"
    users ||--o{ user_object_access : "имеет доступ к"
    users ||--o{ role_assignment_history : "имеет историю ролей"
    
    construction_objects ||--o{ documents : "содержит"
    construction_objects ||--o{ user_object_access : "доступны для"
    
    document_types ||--o{ documents : "определяет тип"
    document_types ||--o{ role_document_permissions : "настраивает права"
    
    documents ||--|{ document_versions : "имеет версии"
    
    document_versions ||--o{ document_extended_attributes : "содержит"
    document_versions ||--o{ document_participants : "включает участников"
    document_versions ||--o{ journal_entries : "содержит записи"
    document_versions ||--o{ work_volumes : "содержит объемы"
    document_versions ||--o| document_versions : "ссылается на предыдущую версию"
```
