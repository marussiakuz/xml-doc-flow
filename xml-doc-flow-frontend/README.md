# Артвелл — система управления исполнительной документацией

Веб-интерфейс для загрузки, валидации и хранения строительных документов в формате XML.

## Быстрый старт

### Вариант A — всё из Docker (рекомендуется)

Требования: Docker Desktop.

Из каталога `xml-doc-flow-backend`:

```bash
docker compose up --build
```

- **Веб-интерфейс**: http://localhost:8888/ (nginx отдаёт фронт и проксирует `/api` на backend — один origin, работает на любом хосте без захардкоженного `localhost:8080` в браузере).
- **API / Swagger напрямую**: http://localhost:8080
- **PostgreSQL**: `localhost:5432` (db `xml_doc_flow`, user/pass `xml_doc_flow`)

### Вариант B — бэкенд в Docker, фронт отдельным HTTP‑сервером

Поднимите только БД и приложение (без nginx-фронта):

```bash
cd xml-doc-flow-backend
docker compose up -d db app
```

Затем в другом терминале:

```bash
cd xml-doc-flow-frontend
python3 -m http.server 3000
```

Откройте `http://127.0.0.1:3000/`. Для порта `3000` клиент API сам направляет запросы на `http://<хост>:8080/api`.

Не открывайте `index.html` через `file://` — для `file://` используется fallback `http://localhost:8080/api`.

### Подключение к API

Фронтенд использует **session-based login** через `/api/auth/login` и cookie-сессию.

Тестовые пользователи:
- `contractor` / пароль из `APP_SEED_DEMO_PASSWORD` (по умолчанию `artwell-local-2026!`)
- `customer` / пароль из `APP_SEED_DEMO_PASSWORD` (по умолчанию `artwell-local-2026!`)

## Структура

См. `scheme.txt`. Скрипты подключаются в порядке: `js/data.js` → `js/api.js` → `js/app.js`.

## Бэкенд

`js/api.js` задаёт `API_CONFIG.baseUrl`: по умолчанию относительный путь **`/api`** (тот же хост и порт, что у страницы — удобно за nginx/Docker или прод reverse-proxy). При локальной разработке на портах `3000`, `5500`, `5173` подставляется `http://localhost:8080/api`. При необходимости можно задать `window.__API_BASE__` до загрузки `api.js`.

Эндпоинты — по `xml-doc-flow-backend/docs/api.yaml`, в т.ч. `/api/auth/*`.

Стартовый экран — **Документы**.