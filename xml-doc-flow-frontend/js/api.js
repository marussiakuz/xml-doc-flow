/**
 * Клиент API по xml-doc-flow-backend/docs/api.yaml.
 *
 * Базовый URL:
 * - По умолчанию — относительный `/api` (тот же хост и порт, что у страницы: Docker + nginx, прод за reverse-proxy).
 * - Перед подключением api.js можно задать `window.__API_BASE__ = 'https://example.com'` (без /api или с /api — нормализуется).
 * - Локальная разработка: статика на 3000/5500/5173 — автоматически `http://<host>:8080/api`.
 * - `file://` — fallback на `http://localhost:8080/api`.
 */
function resolveApiBaseUrl() {
    if (typeof window === 'undefined') {
        return '/api';
    }
    if (window.__API_BASE__) {
        var u = String(window.__API_BASE__).trim().replace(/\/+$/, '');
        if (u.endsWith('/api')) {
            return u;
        }
        return u + '/api';
    }
    var loc = window.location;
    if (loc.protocol === 'file:') {
        return 'http://localhost:8080/api';
    }
    var port = String(loc.port || '');
    if (port === '80' || port === '443' || port === '') {
        return loc.origin + '/api';
    }
    if (port === '8080') {
        return loc.origin + '/api';
    }
    if (['3000', '3001', '3002', '3003', '5500', '5173', '8081', '4173'].indexOf(port) >= 0) {
        return loc.protocol + '//' + loc.hostname + ':8080/api';
    }
    return loc.origin + '/api';
}

const API_CONFIG = {
    baseUrl: resolveApiBaseUrl()
};

function withSession(options) {
    return Object.assign({ credentials: 'include' }, options || {});
}

function getCsrfToken() {
    const match = document.cookie.match(/(?:^|;\s*)XSRF-TOKEN=([^;]+)/);
    return match ? decodeURIComponent(match[1]) : null;
}

function headers(extra) {
    return Object.assign({}, extra || {});
}

function csrfHeaders(extra) {
    const token = getCsrfToken();
    return Object.assign(token ? { 'X-XSRF-TOKEN': token } : {}, extra || {});
}

async function parseJsonBody(response) {
    const text = await response.text();
    if (!text) return null;
    try {
        return JSON.parse(text);
    } catch (e) {
        return null;
    }
}

async function buildHttpError(response) {
    const data = await parseJsonBody(response);
    const msg =
        (data && (data.message || data.error)) ||
        'HTTP ' + response.status;
    const err = new Error(msg);
    err.status = response.status;
    err.body = data;
    return err;
}

/**
 * POST /documents/search
 */
async function searchDocuments(request) {
    const response = await fetch(API_CONFIG.baseUrl + '/documents/search', {
        method: 'POST',
        headers: csrfHeaders({ 'Content-Type': 'application/json' }),
        body: JSON.stringify(request || {}),
        credentials: 'include'
    });
    if (!response.ok) throw await buildHttpError(response);
    return response.json();
}

/**
 * GET /documents/{documentId}
 */
async function getDocumentById(id) {
    const response = await fetch(
        API_CONFIG.baseUrl + '/documents/' + encodeURIComponent(id),
        withSession({ headers: headers() })
    );
    if (!response.ok) throw await buildHttpError(response);
    return response.json();
}

/**
 * GET /documents/{documentId}/versions
 */
async function getDocumentVersions(documentId) {
    const response = await fetch(
        API_CONFIG.baseUrl + '/documents/' + encodeURIComponent(documentId) + '/versions',
        withSession({ headers: headers() })
    );
    if (!response.ok) throw await buildHttpError(response);
    return response.json();
}

/**
 * POST /documents (multipart/form-data)
 * @returns {Promise<object>} UploadDocumentResponse при 201
 */
async function uploadDocument(file) {
    const formData = new FormData();
    formData.append('file', file);
    var url = API_CONFIG.baseUrl + '/documents';
    const response = await fetch(url, {
        method: 'POST',
        headers: csrfHeaders(),
        body: formData,
        credentials: 'include'
    });
    const data = await parseJsonBody(response);
    if (!response.ok) {
        var err = new Error((data && data.message) || 'Ошибка загрузки (HTTP ' + response.status + ')');
        err.status = response.status;
        err.body = data;
        throw err;
    }
    return data;
}

/**
 * PUT /documents/{id}/replace (multipart/form-data)
 * id = id версии документа, от которой ведётся замена
 */
async function replaceDocument(versionId, file) {
    const formData = new FormData();
    formData.append('file', file);
    const response = await fetch(
        API_CONFIG.baseUrl + '/documents/' + encodeURIComponent(versionId) + '/replace',
        {
            method: 'PUT',
            headers: csrfHeaders(),
            body: formData,
            credentials: 'include'
        }
    );
    const data = await parseJsonBody(response);
    if (!response.ok) {
        const err = new Error((data && data.message) || 'Ошибка замены (HTTP ' + response.status + ')');
        err.status = response.status;
        err.body = data;
        throw err;
    }
    return data;
}

/**
 * GET /documents/{id}/xml
 * id = id версии документа
 */
async function downloadDocumentXmlByVersionId(id) {
    const response = await fetch(
        API_CONFIG.baseUrl + '/documents/' + encodeURIComponent(id) + '/xml',
        withSession({ headers: headers() })
    );
    if (!response.ok) {
        throw await buildHttpError(response);
    }
    const blob = await response.blob();
    const url = window.URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = 'document-' + id + '.xml';
    a.click();
    window.URL.revokeObjectURL(url);
}

/**
 * GET /documents/{documentId}/versions/latest/download
 */
async function downloadLatestXml(documentId) {
    const response = await fetch(
        API_CONFIG.baseUrl + '/documents/' + encodeURIComponent(documentId) + '/versions/latest/download',
        withSession({ headers: headers() })
    );
    if (!response.ok) throw await buildHttpError(response);
    const blob = await response.blob();
    const url = window.URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = 'document-' + documentId + '-latest.xml';
    a.click();
    window.URL.revokeObjectURL(url);
}

/**
 * GET /documents/{documentId}/history
 */
async function getDocumentHistory(documentId, page, size) {
    const p = page != null ? page : 0;
    const s = size != null ? size : 20;
    const response = await fetch(
        API_CONFIG.baseUrl + '/documents/' + encodeURIComponent(documentId) + '/history?page=' + p + '&size=' + s,
        withSession({})
    );
    if (!response.ok) throw await buildHttpError(response);
    return response.json();
}

/**
 * GET /audit-log (только ADMIN)
 */
async function getAuditLog(page, size) {
    const p = page != null ? page : 0;
    const s = size != null ? size : 20;
    const response = await fetch(
        API_CONFIG.baseUrl + '/audit-log?page=' + p + '&size=' + s,
        withSession({})
    );
    if (!response.ok) throw await buildHttpError(response);
    return response.json();
}

/**
 * GET /admin/users (только ADMIN)
 */
async function adminListUsers(role, page, size) {
    const p = page != null ? page : 0;
    const s = size != null ? size : 20;
    const r = role != null && String(role).trim() ? '&role=' + encodeURIComponent(String(role).trim()) : '';
    const response = await fetch(
        API_CONFIG.baseUrl + '/admin/users?page=' + p + '&size=' + s + r,
        withSession({ headers: headers() })
    );
    if (!response.ok) throw await buildHttpError(response);
    return response.json();
}

/**
 * GET /admin/users/{id} (только ADMIN)
 */
async function adminGetUser(id) {
    const response = await fetch(
        API_CONFIG.baseUrl + '/admin/users/' + encodeURIComponent(id),
        withSession({ headers: headers() })
    );
    if (!response.ok) throw await buildHttpError(response);
    return response.json();
}

/**
 * POST /admin/users (только ADMIN)
 */
async function adminCreateUser(request) {
    const response = await fetch(API_CONFIG.baseUrl + '/admin/users', {
        method: 'POST',
        headers: csrfHeaders({ 'Content-Type': 'application/json' }),
        credentials: 'include',
        body: JSON.stringify(request || {})
    });
    if (!response.ok) throw await buildHttpError(response);
    return response.json();
}

/**
 * PUT /admin/users/{id} (только ADMIN)
 */
async function adminUpdateUser(id, request) {
    const response = await fetch(API_CONFIG.baseUrl + '/admin/users/' + encodeURIComponent(id), {
        method: 'PUT',
        headers: csrfHeaders({ 'Content-Type': 'application/json' }),
        credentials: 'include',
        body: JSON.stringify(request || {})
    });
    if (!response.ok) throw await buildHttpError(response);
    return response.json();
}

/**
 * DELETE /admin/users/{id} (только ADMIN)
 */
async function adminDeleteUser(id) {
    const response = await fetch(API_CONFIG.baseUrl + '/admin/users/' + encodeURIComponent(id), {
        method: 'DELETE',
        headers: csrfHeaders(),
        credentials: 'include'
    });
    if (!response.ok) throw await buildHttpError(response);
    return null;
}

/**
 * POST /admin/users/{id}/reset-password (только ADMIN)
 */
async function adminResetPassword(id, password) {
    const response = await fetch(API_CONFIG.baseUrl + '/admin/users/' + encodeURIComponent(id) + '/reset-password', {
        method: 'POST',
        headers: csrfHeaders({ 'Content-Type': 'application/json' }),
        credentials: 'include',
        body: JSON.stringify({ password: password })
    });
    if (!response.ok) throw await buildHttpError(response);
    return null;
}

/**
 * POST /auth/login
 */
async function login(username, password) {
    const response = await fetch(API_CONFIG.baseUrl + '/auth/login', {
        method: 'POST',
        headers: csrfHeaders({ 'Content-Type': 'application/json' }),
        credentials: 'include',
        body: JSON.stringify({ username: username, password: password })
    });
    // Важно: тело ответа можно прочитать только один раз.
    // Если сначала прочитать body, а потом построить HttpError — buildHttpError попробует прочитать body повторно.
    if (!response.ok) throw await buildHttpError(response);
    return parseJsonBody(response);
}

/**
 * POST /auth/logout
 */
async function logout() {
    const response = await fetch(API_CONFIG.baseUrl + '/auth/logout', {
        method: 'POST',
        headers: csrfHeaders(),
        credentials: 'include'
    });
    if (!response.ok) throw await buildHttpError(response);
    return null;
}

/**
 * GET /auth/me
 */
async function getMe() {
    const response = await fetch(API_CONFIG.baseUrl + '/auth/me', {
        credentials: 'include'
    });
    if (response.status === 401) return null;
    if (!response.ok) throw await buildHttpError(response);
    return response.json();
}
