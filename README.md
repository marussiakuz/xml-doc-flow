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

