var listState = {
    page: 0,
    size: 10,
    totalElements: 0,
    totalPages: 0
};

var historyState = { page: 0, size: 20, totalPages: 0 };
var auditState = { page: 0, size: 20, totalPages: 0 };
var adminUsersState = { page: 0, size: 20, totalPages: 0, role: '' };

var docsFilters = { category: '', validation: '', objectName: '' };

window.__modalDocumentId = null;
window.__replaceBaseVersionId = null;
window.__modalCurrentVersionId = null;

function reportClientError(err, context) {
    try {
        var msg = (context ? context + ': ' : '') + (err && err.message ? err.message : String(err));
        if (typeof console !== 'undefined' && console.error) console.error(context || 'ClientError', err);
        if (typeof showToast === 'function') showToast(msg, 'error');
        var errorBox = document.getElementById('validationError');
        var errorText = document.getElementById('errorMessage');
        if (errorBox && errorText) {
            errorText.textContent = msg;
            errorBox.classList.remove('hidden');
        }
    } catch (_) {
        // ignore
    }
}

function navigateTo(page) {
    document.querySelectorAll('.sidebar-item').forEach(function (i) {
        i.classList.remove('active');
    });
    var nav = document.querySelector('.sidebar-item[data-page="' + page + '"]');
    if (nav) {
        nav.classList.add('active');
    }

    document.querySelectorAll('.page-content').forEach(function (p) {
        p.classList.add('hidden');
    });
    var pageEl = document.getElementById(page + 'Page');
    if (pageEl) {
        pageEl.classList.remove('hidden');
    }
    updatePageHeader(page);
    if (page === 'documents') {
        loadDocumentList();
    }
    if (page === 'audit') {
        auditState.page = 0;
        loadAuditLog();
    }
    if (page === 'adminUsers') {
        adminUsersState.page = 0;
        loadAdminUsers();
    }
}

function updatePageHeader(page) {
    var titles = {
        documents: { title: 'Документы', desc: 'Список документов; версии — в карточке документа' },
        upload: { title: 'Загрузка документов', desc: 'Загрузите XML-документ для проверки и добавления в систему' },
        audit: { title: 'Журнал действий', desc: 'Полная история событий системы' },
        adminUsers: { title: 'Пользователи', desc: 'Администрирование пользователей' }
    };
    var t = titles[page];
    if (!t) return;
    document.getElementById('pageTitle').textContent = t.title;
    document.getElementById('pageDescription').textContent = t.desc;
}

function initializeNavigation() {
    document.getElementById('app').addEventListener('click', function (e) {
        var link = e.target.closest('[data-page]');
        if (!link) return;
        e.preventDefault();
        var page = link.getAttribute('data-page');
        if (!page) return;
        document.querySelectorAll('.sidebar-item').forEach(function (i) {
            i.classList.remove('active');
        });
        var sidebarMatch = document.querySelector('.sidebar-item[data-page="' + page + '"]');
        if (sidebarMatch) {
            sidebarMatch.classList.add('active');
        }
        document.querySelectorAll('.page-content').forEach(function (p) {
            p.classList.add('hidden');
        });
        var pageEl = document.getElementById(page + 'Page');
        if (pageEl) {
            pageEl.classList.remove('hidden');
        }
        updatePageHeader(page);
        if (page === 'documents') {
            loadDocumentList();
        }
        if (page === 'audit') {
            auditState.page = 0;
            loadAuditLog();
        }
        if (page === 'upload') {
            window.__replaceBaseVersionId = null;
        }
        if (page === 'adminUsers') {
            adminUsersState.page = 0;
            loadAdminUsers();
        }
    });

    document.getElementById('uploadBtn').addEventListener('click', function () {
        window.__replaceBaseVersionId = null;
        navigateTo('upload');
    });
}

function setCurrentUserUi(user) {
    var nameEl = document.getElementById('userName');
    var roleEl = document.getElementById('userRole');
    if (!nameEl || !roleEl) return;
    if (!user) {
        nameEl.textContent = '—';
        roleEl.textContent = '—';
        applyRoleBasedUi(null);
        return;
    }
    nameEl.textContent = user.fullName || user.username || '—';
    roleEl.textContent = user.role || '—';
    applyRoleBasedUi(user.role);
}

function applyRoleBasedUi(role) {
    // Загрузка документов доступна только подрядчику (CONTRACTOR).
    // ADMIN управляет пользователями/аудитом и не должен видеть UI загрузки.
    var canUpload = role === 'CONTRACTOR';
    var isAdmin = role === 'ADMIN';

    var uploadBtn = document.getElementById('uploadBtn');
    if (uploadBtn) uploadBtn.classList.toggle('hidden', !canUpload);

    var uploadNav = document.querySelector('.sidebar-item[data-page="upload"]');
    if (uploadNav) uploadNav.classList.toggle('hidden', !canUpload);

    var modalNewVersionBtn = document.getElementById('modalNewVersionBtn');
    if (modalNewVersionBtn) modalNewVersionBtn.classList.toggle('hidden', !canUpload);

    var auditNavItem = document.getElementById('auditNavItem');
    if (auditNavItem) auditNavItem.classList.toggle('hidden', !isAdmin);

    var adminUsersNavItem = document.getElementById('adminUsersNavItem');
    if (adminUsersNavItem) adminUsersNavItem.classList.toggle('hidden', !isAdmin);

    // Админу не нужен список документов в UI
    var docsNav = document.querySelector('.sidebar-item[data-page="documents"]');
    if (docsNav) docsNav.classList.toggle('hidden', isAdmin);

    // Админу не нужен поиск документов в шапке
    var headerSearch = document.getElementById('headerDocSearch');
    if (headerSearch) headerSearch.classList.toggle('hidden', isAdmin);
}

function showLoginModal(show) {
    var modal = document.getElementById('loginModal');
    if (!modal) return;
    if (show) modal.classList.remove('hidden');
    else modal.classList.add('hidden');
}

async function ensureLoggedIn() {
    try {
        var me = await getMe();
        if (me) {
            window.__authUser = me;
            setCurrentUserUi(me);
            showLoginModal(false);
            return true;
        }
    } catch (e) {
        // ignore and show login
    }
    window.__authUser = null;
    setCurrentUserUi(null);
    showLoginModal(true);
    return false;
}

function initializeAuthUi() {
    var form = document.getElementById('loginForm');
    var u = document.getElementById('loginUsername');
    var p = document.getElementById('loginPassword');
    var err = document.getElementById('loginError');
    var logoutBtn = document.getElementById('logoutBtn');

    if (form && u && p) {
        form.addEventListener('submit', async function (e) {
            e.preventDefault();
            if (err) {
                err.classList.add('hidden');
                err.textContent = '';
            }
            try {
                var user = await login(u.value, p.value);
                window.__authUser = user;
                setCurrentUserUi(user);
                showLoginModal(false);
                showToast('Вход выполнен');
                if (String(user.role || '').toUpperCase() === 'ADMIN') {
                    navigateTo('adminUsers');
                } else {
                    navigateTo('documents');
                }
            } catch (ex) {
                var msg = (ex && ex.message) ? ex.message : 'Ошибка входа';
                if (ex && ex.status === 401) {
                    msg = 'Логин или пароль неверный';
                } else if (msg === 'HTTP 401') {
                    msg = 'Логин или пароль неверный';
                }
                if (err) {
                    err.textContent = msg;
                    err.classList.remove('hidden');
                } else {
                    showToast(msg, 'error');
                }
            }
        });
    }

    if (logoutBtn) {
        logoutBtn.addEventListener('click', async function (e) {
            e.preventDefault();
            try {
                await logout();
            } catch (_) {
                // ignore
            }
            window.__authUser = null;
            setCurrentUserUi(null);
            showLoginModal(true);
        });
    }
}

function resetUploadPanels() {
    document.getElementById('uploadProgress').classList.add('hidden');
    document.getElementById('validationResult').classList.add('hidden');
    document.getElementById('validationError').classList.add('hidden');
    var bar = document.getElementById('progressBar');
    if (bar) bar.style.width = '0%';
    var pct = document.getElementById('uploadPercent');
    if (pct) pct.textContent = '0%';
    var msgList = document.getElementById('validationMessagesList');
    if (msgList) {
        msgList.innerHTML = '';
        msgList.classList.add('hidden');
    }
    var metaHint = document.getElementById('uploadMetaLoadHint');
    if (metaHint) {
        metaHint.textContent = '';
        metaHint.classList.add('hidden');
    }
}

function apiStatusToUiClass(status) {
    if (!status) return 'valid';
    var u = String(status).toUpperCase();
    if (u.indexOf('INVALID') === 0) return 'invalid';
    return 'valid';
}

function getStatusText(status) {
    var u = status ? String(status).toUpperCase() : '';
    if (!u) return '—';
    if (u === 'VALID') return 'Валидный';
    if (u.indexOf('INVALID') === 0) return 'Ошибка';
    return status;
}

function formatDateRu(iso) {
    if (!iso) return '—';
    var d = new Date(iso);
    if (!isNaN(d.getTime())) return d.toLocaleDateString('ru-RU');
    return String(iso);
}

function formatIsoDateTime(iso) {
    if (!iso) return '—';
    var d = new Date(iso);
    if (!isNaN(d.getTime())) return d.toLocaleString('ru-RU');
    return String(iso);
}

function displayDocumentType(doc) {
    if (doc.title) return doc.title;
    if (doc.documentType) return String(doc.documentType).replace(/_/g, ' ');
    return '—';
}

async function loadDocumentList() {
    var table = document.getElementById('allDocsTable');
    var info = document.getElementById('listPageInfo');
    if (!window.__staticDocsTableHtml && table) {
        window.__staticDocsTableHtml = table.innerHTML;
    }
    info.textContent = 'Загрузка списка с сервера…';
    try {
        // Подстраховка: читаем значения фильтров напрямую из DOM
        var catEl = document.getElementById('docsCategoryFilter');
        var valEl = document.getElementById('docsValidationFilter');
        var objEl = document.getElementById('docsObjectFilter');
        if (catEl) docsFilters.category = catEl.value || '';
        if (valEl) docsFilters.validation = valEl.value || '';
        if (objEl) docsFilters.objectName = objEl.value || '';

        var ok = await ensureLoggedIn();
        if (!ok) {
            info.textContent = 'Требуется вход для работы с API.';
            return;
        }
        var page = await searchDocuments({
            page: listState.page,
            size: listState.size,
            latestOnly: true,
            validationStatus: docsFilters.validation || null
        });
        listState.totalElements = page.totalElements || 0;
        listState.totalPages = page.totalPages || 0;
        var content = page.content || [];

        syncDocsFiltersFromContent(content);
        var filtered = applyDocsClientFilters(content);
        var pageNumber = page.pageNumber != null ? page.pageNumber : listState.page;
        var pageSize = page.pageSize != null ? page.pageSize : listState.size;
        var start = filtered.length === 0 ? 0 : pageNumber * pageSize + 1;
        var end = filtered.length === 0 ? 0 : pageNumber * pageSize + filtered.length;
        info.textContent =
            'Показано ' +
            start +
            '–' +
            end +
            ' из ' +
            (page.totalElements || 0) +
            (docsFilters.category || docsFilters.objectName ? ' (после фильтра: ' + filtered.length + ')' : '') +
            ' документов (стр. ' +
            (pageNumber + 1) +
            ' из ' +
            Math.max(1, page.totalPages || 0) +
            ')';

        if (filtered.length === 0) {
            table.innerHTML =
                '<tr><td colspan="8" class="px-6 py-8 text-center text-gray-500">Нет документов</td></tr>';
        } else {
            table.innerHTML = filtered.map(renderDocumentRow).join('');
        }
        if (typeof lucide !== 'undefined') lucide.createIcons();

        document.getElementById('paginationPrev').disabled = pageNumber <= 0;
        document.getElementById('paginationNext').disabled =
            (page.totalPages || 0) <= 0 || pageNumber >= (page.totalPages || 0) - 1;
    } catch (e) {
        if (window.__staticDocsTableHtml) {
            table.innerHTML = window.__staticDocsTableHtml;
            if (typeof lucide !== 'undefined') lucide.createIcons();
        }
        var hint = '';
        if (e && e.status === 401) hint = ' (401: проверь Basic Auth в Настройках)';
        else if (e && e.status) hint = ' (HTTP ' + e.status + ')';
        info.textContent = 'Ошибка API' + hint + ': ' + (e && e.message ? e.message : 'неизвестная ошибка') + '. Показаны документы из страницы (без API).';
        showToast('Ошибка API' + hint + ': ' + (e && e.message ? e.message : 'неизвестная ошибка'), 'error');
    }
}

function applyDocsClientFilters(content) {
    var out = content || [];
    if (docsFilters.category) {
        out = out.filter(function (d) {
            return detectDocCategory(d) === docsFilters.category;
        });
    }
    if (docsFilters.objectName) {
        out = out.filter(function (d) {
            var name =
                (d && d.constructionObject && (d.constructionObject.objectName || d.constructionObject.name)) || '';
            return String(name) === docsFilters.objectName;
        });
    }
    return out;
}

function detectDocCategory(d) {
    // В бэке "category" — техническое поле справочника, а в UI нужны "Акты/Журналы/Протоколы".
    // Делаем классификацию по наименованию типа/тайтлу.
    var typeName = '';
    if (d && d.documentType && d.documentType.typeName) typeName = String(d.documentType.typeName);
    else if (d && d.docTypeName) typeName = String(d.docTypeName);
    else if (d && d.title) typeName = String(d.title);
    var t = typeName.toLowerCase();
    if (t.indexOf('журнал') >= 0) return 'Журналы';
    if (t.indexOf('протокол') >= 0) return 'Протоколы';
    return 'Акты';
}

function syncDocsFiltersFromContent(content) {
    var objectEl = document.getElementById('docsObjectFilter');
    if (!objectEl) return;

    var objects = {};
    (content || []).forEach(function (d) {
        var obj =
            (d && d.constructionObject && (d.constructionObject.objectName || d.constructionObject.name))
                ? String(d.constructionObject.objectName || d.constructionObject.name)
                : '';
        if (obj) objects[obj] = true;
    });

    // Объекты пополняем, не перетирая текущий список (иначе выбор "прыгает" при перезагрузке)
    var existing = {};
    for (var i = 0; i < objectEl.options.length; i++) {
        existing[objectEl.options[i].value] = true;
    }
    Object.keys(objects).sort().forEach(function (name) {
        if (existing[name]) return;
        var opt = document.createElement('option');
        opt.value = name;
        opt.textContent = name;
        objectEl.appendChild(opt);
    });
}

function initializeDocumentsFilters() {
    var categoryEl = document.getElementById('docsCategoryFilter');
    var validationEl = document.getElementById('docsValidationFilter');
    var objectEl = document.getElementById('docsObjectFilter');
    if (categoryEl) {
        categoryEl.addEventListener('change', function () {
            docsFilters.category = categoryEl.value || '';
            listState.page = 0;
            loadDocumentList();
        });
    }
    if (validationEl) {
        validationEl.addEventListener('change', function () {
            docsFilters.validation = validationEl.value || '';
            listState.page = 0;
            loadDocumentList();
        });
    }
    if (objectEl) {
        objectEl.addEventListener('change', function () {
            docsFilters.objectName = objectEl.value || '';
            listState.page = 0;
            loadDocumentList();
        });
    }
}

function renderDocumentRow(doc) {
    var documentId = String(doc.documentId);
    var documentIdAttr = documentId.replace(/\\/g, '\\\\').replace(/'/g, "\\'");
    var st = apiStatusToUiClass(doc.validationStatus);
    return (
        '<tr class="hover:bg-gray-50 cursor-pointer" onclick="openDocumentModal(\'' +
        documentIdAttr +
        '\')">' +
        '<td class="px-6 py-4 whitespace-nowrap"><input type="checkbox" class="rounded" onclick="event.stopPropagation()"></td>' +
        '<td class="px-6 py-4 whitespace-nowrap">' +
        '<div class="flex items-center">' +
        '<div class="w-10 h-10 bg-blue-100 rounded-lg flex items-center justify-center mr-3">' +
        '<i data-lucide="file-text" class="w-5 h-5 text-blue-600"></i></div>' +
        '<div><p class="font-medium text-gray-900">' +
        escapeHtml(doc.documentNumber || '') +
        '</p>' +
        '<p class="text-sm text-gray-500">' +
        escapeHtml(displayDocumentType(doc)) +
        '</p></div></div></td>' +
        '<td class="px-6 py-4 whitespace-nowrap text-sm text-gray-700">' +
        escapeHtml(doc.documentNumber || '') +
        '</td>' +
        '<td class="px-6 py-4 whitespace-nowrap text-sm text-gray-700">' +
        escapeHtml((doc.constructionObject && doc.constructionObject.objectName) || '—') +
        '</td>' +
        '<td class="px-6 py-4 whitespace-nowrap text-sm text-gray-700">' +
        escapeHtml(formatDateRu(doc.documentDate)) +
        '</td>' +
        '<td class="px-6 py-4 whitespace-nowrap">' +
        '<span class="status-badge status-' +
        st +
        '">' +
        getStatusText(doc.validationStatus) +
        '</span></td>' +
        '<td class="px-6 py-4 whitespace-nowrap text-sm text-gray-700">v' +
        (doc.currentVersion != null ? doc.currentVersion : '—') +
        '</td>' +
        '<td class="px-6 py-4 whitespace-nowrap">' +
        '<div class="flex items-center space-x-2">' +
        '<button type="button" class="text-blue-600 hover:text-blue-800" onclick="event.stopPropagation(); openDocumentModal(\'' +
        documentIdAttr +
        '\')"><i data-lucide="eye" class="w-5 h-5"></i></button>' +
        '<button type="button" class="text-green-600 hover:text-green-800" onclick="event.stopPropagation(); downloadDocumentFromList(\'' +
        documentIdAttr +
        '\')"><i data-lucide="download" class="w-5 h-5"></i></button>' +
        '</div></td></tr>'
    );
}

window.downloadDocumentFromList = async function (id) {
    try {
        await downloadLatestXml(id);
        showToast('Файл скачан');
    } catch (e) {
        showToast(e.message || 'Ошибка скачивания', 'error');
    }
};

function initializePagination() {
    document.getElementById('paginationPrev').addEventListener('click', function () {
        if (listState.page > 0) {
            listState.page -= 1;
            loadDocumentList();
        }
    });
    document.getElementById('paginationNext').addEventListener('click', function () {
        if (listState.totalPages > 0 && listState.page < listState.totalPages - 1) {
            listState.page += 1;
            loadDocumentList();
        }
    });
}

function initializeUpload() {
    var uploadZone = document.getElementById('uploadZone');
    var fileInput = document.getElementById('fileInput');

    uploadZone.addEventListener('click', function (e) {
        if (e.target.closest('button')) {
            e.stopPropagation();
            fileInput.click();
            return;
        }
        fileInput.click();
    });

    uploadZone.addEventListener('dragover', function (e) {
        e.preventDefault();
        uploadZone.classList.add('dragover');
    });

    uploadZone.addEventListener('dragleave', function () {
        uploadZone.classList.remove('dragover');
    });

    uploadZone.addEventListener('drop', function (e) {
        e.preventDefault();
        uploadZone.classList.remove('dragover');
        if (e.dataTransfer.files.length > 0) {
            handleFileUpload(e.dataTransfer.files[0]);
        }
    });

    fileInput.addEventListener('change', function (e) {
        if (e.target.files.length > 0) {
            handleFileUpload(e.target.files[0]);
        }
        e.target.value = '';
    });

    document.getElementById('uploadGoToListBtn').addEventListener('click', function () {
        resetUploadPanels();
        navigateTo('documents');
    });

    document.getElementById('uploadAnotherSuccessBtn').addEventListener('click', function () {
        resetUploadPanels();
    });

    document.getElementById('uploadAnotherErrorBtn').addEventListener('click', function () {
        resetUploadPanels();
    });
}

async function handleFileUpload(file) {
    if (!file.name.toLowerCase().endsWith('.xml')) {
        showToast('Пожалуйста, загрузите XML-файл', 'error');
        return;
    }

    var ok = await ensureLoggedIn();
    if (!ok) {
        showToast('Сначала выполните вход', 'error');
        return;
    }

    resetUploadPanels();
    document.getElementById('uploadProgress').classList.remove('hidden');
    document.getElementById('uploadFileName').textContent = file.name;

    var progress = 0;
    var interval = setInterval(function () {
        progress = Math.min(95, progress + 12);
        document.getElementById('progressBar').style.width = progress + '%';
        document.getElementById('uploadPercent').textContent = progress + '%';
    }, 120);

    try {
        if (typeof uploadDocument !== 'function') {
            throw new Error('Функция uploadDocument не найдена (проверь загрузку js/api.js и обновление страницы)');
        }
        if (window.__replaceBaseVersionId && typeof replaceDocument !== 'function') {
            throw new Error('Функция replaceDocument не найдена (проверь загрузку js/api.js и обновление страницы)');
        }
        var result;
        if (window.__replaceBaseVersionId) {
            result = await replaceDocument(window.__replaceBaseVersionId, file);
        } else {
            result = await uploadDocument(file);
        }
        clearInterval(interval);
        document.getElementById('progressBar').style.width = '100%';
        document.getElementById('uploadPercent').textContent = '100%';
        setTimeout(function () {
            document.getElementById('uploadProgress').classList.add('hidden');
            Promise.resolve(showUploadSuccess(result)).catch(function (e) {
                reportClientError(e, 'Результат загрузки');
                // даже если не смогли докачать метаданные, сам факт загрузки уже успешен
            });
        }, 200);
    } catch (e) {
        clearInterval(interval);
        document.getElementById('uploadProgress').classList.add('hidden');
        reportClientError(e, 'Загрузка');
        showUploadFailure(e);
    }
}

async function showUploadSuccess(result) {
    var status = result.validationStatus || '';

    document.getElementById('docNumber').textContent = result.documentNumber || '—';
    document.getElementById('docDate').textContent = '—';
    document.getElementById('docObject').textContent = '—';
    document.getElementById('docType').textContent = result.docTypeName || result.docType || '—';

    // UploadDocumentResponse не содержит дату/объект строительства — докачиваем по id документа
    var metaHint = document.getElementById('uploadMetaLoadHint');
    if (metaHint) {
        metaHint.textContent = '';
        metaHint.classList.add('hidden');
    }
    try {
        if (result && result.documentId != null && status !== 'INVALID_CONFLICT' && typeof getDocumentById === 'function') {
            var doc = await getDocumentById(String(result.documentId));
            if (doc) {
                document.getElementById('docDate').textContent = formatDateRu(doc.documentDate);
                document.getElementById('docObject').textContent =
                    (doc.constructionObject && (doc.constructionObject.objectName || doc.constructionObject.name)) || '—';
                if (!result.docTypeName && doc.docTypeName) {
                    document.getElementById('docType').textContent = doc.docTypeName;
                }
            } else {
                var emptyMsg =
                    'Не удалось получить дату и объект строительства (пустой ответ). Документ сохранён — смотрите карточку в списке.';
                if (metaHint) {
                    metaHint.textContent = emptyMsg;
                    metaHint.classList.remove('hidden');
                }
                showToast(emptyMsg, 'error');
                if (typeof console !== 'undefined' && console.warn) console.warn('getDocumentById returned empty after upload');
            }
        }
    } catch (e) {
        var errDetail = (e && e.message) ? e.message : 'неизвестная ошибка';
        var errMsg =
            'Не удалось загрузить дату и объект строительства: ' +
            errDetail +
            '. Документ сохранён — откройте карточку в списке документов.';
        if (typeof console !== 'undefined' && console.warn) console.warn('Failed to load document metadata after upload:', e);
        if (metaHint) {
            metaHint.textContent = errMsg;
            metaHint.classList.remove('hidden');
        }
        showToast(errMsg, 'error');
    }

    var messages = result.validationErrors || [];
    var badge = document.getElementById('validationStatus');
    var stClass = apiStatusToUiClass(status);
    badge.className = 'status-badge status-' + stClass;
    if (status === 'VALID' || !status) {
        badge.textContent =
            messages.length > 0 ? 'Валидный документ (есть предупреждения XSD)' : 'Валидный документ';
    } else {
        badge.textContent = getStatusText(status);
    }

    var msgList = document.getElementById('validationMessagesList');
    if (messages.length > 0) {
        msgList.classList.remove('hidden');
        var liClass = status === 'INVALID_CONFLICT' ? ' class="text-red-600 font-medium"' : '';
        msgList.innerHTML = messages
            .map(function (m) {
                var line =
                    (m.lineNumber != null ? 'стр. ' + m.lineNumber + (m.columnNumber != null ? ', кол. ' + m.columnNumber : '') + ': ' : '') +
                    (m.message || '');
                return '<li' + liClass + '>' + escapeHtml(line) + '</li>';
            })
            .join('');
    } else {
        msgList.classList.add('hidden');
        msgList.innerHTML = '';
    }

    document.getElementById('validationResult').classList.remove('hidden');
    if (status !== 'INVALID_CONFLICT') {
        showToast(window.__replaceBaseVersionId ? 'Новая версия сохранена' : 'Документ сохранён');
    }
    window.__replaceBaseVersionId = null;
}

function showUploadFailure(err) {
    var body = err.body || {};
    var status = body.validationStatus || '';
    var firstValidationMessage = body.validationErrors && body.validationErrors.length > 0
        ? body.validationErrors[0].message
        : null;

    var titleEl = document.getElementById('errorTitle');
    if (titleEl) {
        if (status === 'INVALID_CONFLICT') {
            var conflictMsg = firstValidationMessage || '';
            titleEl.textContent =
                conflictMsg.indexOf('другим подрядчиком') !== -1
                    ? 'Документ уже загружен'
                    : 'Несовместимый тип документа';
        } else if (status === 'INVALID_SCHEMA') {
            titleEl.textContent = 'Документ не соответствует XSD-схеме';
        } else if (status === 'INVALID_XML') {
            titleEl.textContent = 'Файл не является корректным XML';
        } else if (status === 'INVALID_UNKNOWN_DOCUMENT_TYPE') {
            titleEl.textContent = 'Неизвестный тип документа';
        } else if (status === 'INVALID_DOCUMENT_ROOT') {
            titleEl.textContent = 'Недопустимый корневой элемент';
        } else {
            titleEl.textContent = 'Ошибка загрузки документа';
        }
    }

    var text = firstValidationMessage || err.message || 'Неизвестная ошибка';
    var details = body.details;
    if (details && details.length) {
        text += '\n' + details.join('\n');
    }

    document.getElementById('errorMessage').textContent = text;
    document.getElementById('validationError').classList.remove('hidden');
    showToast('Ошибка загрузки', 'error');
}

// ─── История событий документа ───────────────────────────────────────────────

function setHistoryPanelVisible(show) {
    var panel = document.getElementById('historyPanel');
    var label = document.getElementById('toggleHistoryBtnLabel');
    if (!panel || !label) return;
    panel.classList.toggle('hidden', !show);
    label.textContent = show ? 'Скрыть историю' : 'История';
}

async function loadHistoryIntoModal(documentId, page) {
    var listEl = document.getElementById('historyList');
    var infoEl = document.getElementById('historyPageInfo');
    listEl.innerHTML = '<p class="text-sm text-gray-500 py-2">Загрузка…</p>';
    try {
        var data = await getDocumentHistory(documentId, page || 0, historyState.size);
        historyState.page = data.pageNumber;
        historyState.totalPages = data.totalPages;
        var items = data.content || [];
        if (items.length === 0) {
            listEl.innerHTML = '<p class="text-sm text-gray-500 py-2">Событий не найдено</p>';
        } else {
            listEl.innerHTML = items.map(function (e) {
                var entityLabel = e.entityType === 'VERSION' ? 'версия #' + e.entityId
                    : e.entityType === 'DOCUMENT' ? 'документ #' + e.entityId : '';
                var ipText = e.ipAddress ? ' · ' + e.ipAddress : '';
                return '<div class="flex items-start justify-between py-2 border-b border-gray-100 last:border-0 gap-2">' +
                    '<div>' +
                    '<p class="text-sm font-medium text-gray-900">' + escapeHtml(e.actionLabel || e.actionType) + '</p>' +
                    '<p class="text-xs text-gray-500">' + escapeHtml(e.username || '—') + ' · ' + escapeHtml(formatIsoDateTime(e.createdAt)) + escapeHtml(ipText) + '</p>' +
                    '</div>' +
                    '<span class="text-xs text-gray-400 shrink-0">' + escapeHtml(entityLabel) + '</span>' +
                    '</div>';
            }).join('');
        }
        if (infoEl) {
            infoEl.textContent = 'Стр. ' + (data.pageNumber + 1) + ' из ' + Math.max(1, data.totalPages);
        }
        document.getElementById('historyPrev').disabled = data.pageNumber <= 0;
        document.getElementById('historyNext').disabled = data.pageNumber >= data.totalPages - 1;
    } catch (e) {
        listEl.innerHTML = '<p class="text-sm text-red-600">' + escapeHtml(e.message || 'Ошибка загрузки') + '</p>';
    }
}

// ─── Глобальный журнал аудита ─────────────────────────────────────────────────

async function loadAuditLog() {
    var table = document.getElementById('auditLogTable');
    var info = document.getElementById('auditPageInfo');
    if (!table) return;
    table.innerHTML = '<tr><td colspan="5" class="px-6 py-4 text-center text-gray-500">Загрузка…</td></tr>';
    try {
        var data = await getAuditLog(auditState.page, auditState.size);
        auditState.totalPages = data.totalPages;
        var items = data.content || [];
        if (items.length === 0) {
            table.innerHTML = '<tr><td colspan="5" class="px-6 py-8 text-center text-gray-500">Событий нет</td></tr>';
        } else {
            table.innerHTML = items.map(function (e) {
                var entityLabel = e.entityType && e.entityId
                    ? escapeHtml(e.entityType) + ' #' + e.entityId
                    : escapeHtml(e.entityType || '—');
                return '<tr class="hover:bg-gray-50">' +
                    '<td class="px-6 py-3 text-sm text-gray-700 whitespace-nowrap">' + escapeHtml(formatIsoDateTime(e.createdAt)) + '</td>' +
                    '<td class="px-6 py-3 text-sm text-gray-900 font-medium">' + escapeHtml(e.username || '—') + '</td>' +
                    '<td class="px-6 py-3 text-sm text-gray-700">' + escapeHtml(e.actionLabel || e.actionType) + '</td>' +
                    '<td class="px-6 py-3 text-sm text-gray-500">' + entityLabel + '</td>' +
                    '<td class="px-6 py-3 text-sm text-gray-400 font-mono">' + escapeHtml(e.ipAddress || '—') + '</td>' +
                    '</tr>';
            }).join('');
        }
        var start = items.length === 0 ? 0 : data.pageNumber * data.pageSize + 1;
        var end = items.length === 0 ? 0 : data.pageNumber * data.pageSize + items.length;
        if (info) info.textContent = 'Показано ' + start + '–' + end + ' из ' + data.totalElements;
        document.getElementById('auditPaginationPrev').disabled = data.pageNumber <= 0;
        document.getElementById('auditPaginationNext').disabled = data.pageNumber >= data.totalPages - 1;
        if (typeof lucide !== 'undefined') lucide.createIcons();
    } catch (e) {
        table.innerHTML = '<tr><td colspan="5" class="px-6 py-4 text-center text-red-600">' + escapeHtml(e.message || 'Ошибка') + '</td></tr>';
    }
}

// ─── Админка: пользователи ────────────────────────────────────────────────────

function safeText(v, fallback) {
    if (v == null) return fallback || '—';
    var t = String(v);
    if (!t.trim()) return fallback || '—';
    return t;
}

function setAdminUserFormError(msg) {
    var el = document.getElementById('adminUserFormError');
    if (!el) return;
    if (!msg) {
        el.classList.add('hidden');
        el.textContent = '';
        return;
    }
    el.textContent = msg;
    el.classList.remove('hidden');
}

function openAdminUserModal(mode, user) {
    var modal = document.getElementById('adminUserModal');
    if (!modal) return;
    setAdminUserFormError('');
    document.getElementById('adminUserModalTitle').textContent = mode === 'create' ? 'Создать пользователя' : 'Редактировать пользователя';
    document.getElementById('adminUserId').value = user && user.id != null ? String(user.id) : '';
    document.getElementById('adminUserUsername').value = user && user.username ? user.username : '';
    document.getElementById('adminUserPassword').value = '';
    document.getElementById('adminUserFullName').value = user && user.fullName ? user.fullName : '';
    document.getElementById('adminUserRole').value = user && user.role ? user.role : 'CUSTOMER';
    document.getElementById('adminUserEmail').value = user && user.email ? user.email : '';
    document.getElementById('adminUserActive').checked = user && user.active != null ? !!user.active : true;

    document.getElementById('adminUserUsername').disabled = mode !== 'create';
    document.getElementById('adminUserPassword').disabled = mode !== 'create';

    var resetBtn = document.getElementById('adminUserResetPasswordBtn');
    if (resetBtn) {
        resetBtn.classList.toggle('hidden', mode !== 'edit');
    }

    modal.classList.remove('hidden');
    if (typeof lucide !== 'undefined') lucide.createIcons();
}

function closeAdminUserModal() {
    var modal = document.getElementById('adminUserModal');
    if (!modal) return;
    modal.classList.add('hidden');
}

function renderAdminUserRow(u) {
    var idAttr = String(u.id).replace(/\\/g, '\\\\').replace(/'/g, "\\'");
    var activeBadge = u.active
        ? '<span class="status-badge status-valid">Да</span>'
        : '<span class="status-badge status-invalid">Нет</span>';
    return (
        '<tr class="hover:bg-gray-50">' +
        '<td class="px-6 py-4 whitespace-nowrap text-sm text-gray-700">' + escapeHtml(String(u.id)) + '</td>' +
        '<td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900 font-medium">' + escapeHtml(safeText(u.username)) + '</td>' +
        '<td class="px-6 py-4 whitespace-nowrap text-sm text-gray-700">' + escapeHtml(safeText(u.fullName)) + '</td>' +
        '<td class="px-6 py-4 whitespace-nowrap text-sm text-gray-700">' + escapeHtml(safeText(u.role)) + '</td>' +
        '<td class="px-6 py-4 whitespace-nowrap text-sm text-gray-700">' + escapeHtml(safeText(u.email)) + '</td>' +
        '<td class="px-6 py-4 whitespace-nowrap">' + activeBadge + '</td>' +
        '<td class="px-6 py-4 whitespace-nowrap">' +
        '<div class="flex items-center gap-2">' +
        '<button type="button" class="text-blue-600 hover:text-blue-800" title="Редактировать" onclick="openAdminUserEdit(\'' + idAttr + '\')"><i data-lucide="edit" class="w-5 h-5"></i></button>' +
        '<button type="button" class="text-red-600 hover:text-red-800" title="Деактивировать" onclick="adminUserDeactivate(\'' + idAttr + '\')"><i data-lucide="user-x" class="w-5 h-5"></i></button>' +
        '</div>' +
        '</td>' +
        '</tr>'
    );
}

async function loadAdminUsers() {
    var table = document.getElementById('adminUsersTable');
    var info = document.getElementById('adminUsersPageInfo');
    if (!table || !info) return;

    info.textContent = 'Загрузка…';
    table.innerHTML = '<tr><td colspan="7" class="px-6 py-8 text-center text-gray-500">Загрузка…</td></tr>';
    try {
        var page = await adminListUsers(adminUsersState.role, adminUsersState.page, adminUsersState.size);
        var items = page.content || [];
        adminUsersState.totalPages = page.totalPages || 0;

        if (items.length === 0) {
            table.innerHTML = '<tr><td colspan="7" class="px-6 py-8 text-center text-gray-500">Нет пользователей</td></tr>';
        } else {
            table.innerHTML = items.map(renderAdminUserRow).join('');
        }

        var pageNumber = page.number != null ? page.number : (page.pageNumber != null ? page.pageNumber : adminUsersState.page);
        var pageSize = page.size != null ? page.size : (page.pageSize != null ? page.pageSize : adminUsersState.size);
        var start = items.length === 0 ? 0 : pageNumber * pageSize + 1;
        var end = items.length === 0 ? 0 : pageNumber * pageSize + items.length;
        info.textContent = 'Показано ' + start + '–' + end + ' из ' + (page.totalElements || 0);

        document.getElementById('adminUsersPaginationPrev').disabled = pageNumber <= 0;
        document.getElementById('adminUsersPaginationNext').disabled =
            (page.totalPages || 0) <= 0 || pageNumber >= (page.totalPages || 0) - 1;
    } catch (e) {
        info.textContent = 'Ошибка: ' + (e && e.message ? e.message : 'неизвестная ошибка');
        table.innerHTML = '<tr><td colspan="7" class="px-6 py-8 text-center text-red-600">' + escapeHtml(e.message || 'Ошибка') + '</td></tr>';
    }
    if (typeof lucide !== 'undefined') lucide.createIcons();
}

window.openAdminUserEdit = async function (id) {
    try {
        var user = await adminGetUser(id);
        openAdminUserModal('edit', user);
    } catch (e) {
        showToast(e.message || 'Не удалось загрузить пользователя', 'error');
    }
};

window.adminUserDeactivate = async function (id) {
    if (!confirm('Деактивировать пользователя #' + id + '?')) return;
    try {
        await adminDeleteUser(id);
        showToast('Пользователь деактивирован');
        loadAdminUsers();
    } catch (e) {
        showToast(e.message || 'Ошибка', 'error');
    }
};

function initializeAdminUsers() {
    var roleFilter = document.getElementById('adminUsersRoleFilter');
    var createBtn = document.getElementById('adminUsersCreateBtn');
    var prev = document.getElementById('adminUsersPaginationPrev');
    var next = document.getElementById('adminUsersPaginationNext');

    if (roleFilter) {
        roleFilter.addEventListener('change', function () {
            adminUsersState.role = roleFilter.value || '';
            adminUsersState.page = 0;
            loadAdminUsers();
        });
    }
    if (createBtn) {
        createBtn.addEventListener('click', function () {
            openAdminUserModal('create', null);
        });
    }
    if (prev) {
        prev.addEventListener('click', function () {
            if (adminUsersState.page > 0) {
                adminUsersState.page -= 1;
                loadAdminUsers();
            }
        });
    }
    if (next) {
        next.addEventListener('click', function () {
            if (adminUsersState.totalPages > 0 && adminUsersState.page < adminUsersState.totalPages - 1) {
                adminUsersState.page += 1;
                loadAdminUsers();
            }
        });
    }

    var closeBtn = document.getElementById('adminUserModalClose');
    var cancelBtn = document.getElementById('adminUserCancelBtn');
    if (closeBtn) closeBtn.addEventListener('click', closeAdminUserModal);
    if (cancelBtn) cancelBtn.addEventListener('click', closeAdminUserModal);

    var modal = document.getElementById('adminUserModal');
    if (modal) {
        modal.addEventListener('click', function (e) {
            if (e.target === modal) closeAdminUserModal();
        });
    }

    var form = document.getElementById('adminUserForm');
    if (form) {
        // Частая проблема: пользователи вводят кириллические "похожие" буквы в email (например "с" вместо "c").
        // Браузерная валидация type="email" считает такие адреса невалидными. Нормализуем на лету.
        var emailInput = document.getElementById('adminUserEmail');
        if (emailInput) {
            emailInput.addEventListener('input', function () {
                var v = String(emailInput.value || '');
                // Замены кириллицы на латиницу для визуально похожих символов
                var map = {
                    'А': 'A', 'а': 'a',
                    'В': 'B', 'Е': 'E', 'е': 'e',
                    'К': 'K', 'М': 'M',
                    'Н': 'H', 'О': 'O', 'о': 'o',
                    'Р': 'P', 'р': 'p',
                    'С': 'C', 'с': 'c',
                    'Т': 'T', 'Х': 'X', 'х': 'x',
                    'У': 'Y', 'у': 'y'
                };
                var out = '';
                for (var i = 0; i < v.length; i++) {
                    var ch = v.charAt(i);
                    out += map[ch] || ch;
                }
                if (out !== v) {
                    var pos = emailInput.selectionStart;
                    emailInput.value = out;
                    try {
                        emailInput.setSelectionRange(pos, pos);
                    } catch (_) {
                        // ignore
                    }
                }
            });
        }

        form.addEventListener('submit', async function (e) {
            e.preventDefault();
            setAdminUserFormError('');
            try {
                var id = document.getElementById('adminUserId').value;
                var username = document.getElementById('adminUserUsername').value.trim();
                var password = document.getElementById('adminUserPassword').value;
                var fullName = document.getElementById('adminUserFullName').value.trim();
                var role = document.getElementById('adminUserRole').value;
                var email = document.getElementById('adminUserEmail').value.trim();
                var active = document.getElementById('adminUserActive').checked;

                if (!id) {
                    if (!username) throw new Error('Введите логин');
                    if (!password || String(password).length < 6) throw new Error('Пароль должен быть не короче 6 символов');
                    await adminCreateUser({
                        username: username,
                        password: password,
                        fullName: fullName || null,
                        role: role,
                        email: email || null
                    });
                    showToast('Пользователь создан');
                } else {
                    await adminUpdateUser(id, {
                        fullName: fullName || null,
                        role: role || null,
                        active: active,
                        email: email || null
                    });
                    showToast('Пользователь обновлён');
                }

                closeAdminUserModal();
                loadAdminUsers();
            } catch (ex) {
                setAdminUserFormError(ex.message || 'Ошибка сохранения');
            }
        });
    }

    var resetBtn = document.getElementById('adminUserResetPasswordBtn');
    if (resetBtn) {
        resetBtn.addEventListener('click', async function () {
            var id = document.getElementById('adminUserId').value;
            if (!id) return;
            var newPass = prompt('Новый пароль (мин. 6 символов):');
            if (newPass == null) return;
            if (String(newPass).length < 6) {
                showToast('Пароль слишком короткий', 'error');
                return;
            }
            try {
                await adminResetPassword(id, newPass);
                showToast('Пароль сброшен');
            } catch (e) {
                showToast(e.message || 'Ошибка', 'error');
            }
        });
    }
}

function setVersionsPanelVisible(show) {
    var panel = document.getElementById('versionsPanel');
    var label = document.getElementById('toggleVersionsBtnLabel');
    if (!panel || !label) return;
    if (show) {
        panel.classList.remove('hidden');
        label.textContent = 'Скрыть версии';
    } else {
        panel.classList.add('hidden');
        label.textContent = 'Показать версии';
    }
}

async function loadVersionsIntoModal(documentId) {
    var listEl = document.getElementById('versionsList');
    listEl.innerHTML = '<p class="text-sm text-gray-500">Загрузка версий…</p>';
    try {
        var versions = await getDocumentVersions(documentId);
        if (!versions.length) {
            listEl.innerHTML = '<p class="text-sm text-gray-500">Версий нет</p>';
            return;
        }
        var current = versions.find(function (v) {
            return !!v.isCurrent;
        });
        window.__modalCurrentVersionId = current ? current.versionId : null;
        listEl.innerHTML = versions
            .map(function (v, idx) {
                var isFirst = idx === 0;
                var st = apiStatusToUiClass(v.validationStatus);
                var downloadBtn =
                    '<button type="button" class="text-green-600 hover:text-green-800" ' +
                    'title="Скачать XML этой версии" ' +
                    "onclick=\"event.stopPropagation(); downloadVersionXml('" +
                    String(v.versionId).replace(/\\/g, '\\\\').replace(/'/g, "\\'") +
                    "')\">" +
                    '<i data-lucide="download" class="w-5 h-5"></i>' +
                    '</button>';
                return (
                    '<div class="border border-gray-200 rounded-lg p-4 ' +
                    (isFirst ? '' : 'opacity-90') +
                    '">' +
                    '<div class="flex items-center justify-between flex-wrap gap-2">' +
                    '<div><p class="font-medium text-gray-900">Версия ' +
                    escapeHtml(String(v.versionNumber)) +
                    '</p>' +
                    '<p class="text-sm text-gray-500">' +
                    escapeHtml(formatIsoDateTime(v.uploadedAt)) +
                    '</p></div>' +
                    '<div class="flex items-center gap-2">' +
                    downloadBtn +
                    (v.isCurrent ? '<span class="status-badge status-valid">Текущая</span>' : '') +
                    '<span class="status-badge status-' +
                    st +
                    '">' +
                    getStatusText(v.validationStatus) +
                    '</span>' +
                    '</div></div></div>'
                );
            })
            .join('');
    } catch (e) {
        listEl.innerHTML = '<p class="text-sm text-red-600">' + escapeHtml(e.message) + '</p>';
    }
    if (typeof lucide !== 'undefined') lucide.createIcons();
}

// Скачивание XML конкретной версии из списка версий (id = versionId)
window.downloadVersionXml = async function (versionId) {
    try {
        await downloadDocumentXmlByVersionId(versionId);
        showToast('Файл скачан');
    } catch (e) {
        showToast((e && e.message) || 'Ошибка скачивания', 'error');
    }
};

function initializeModal() {
    document.getElementById('closeModal').addEventListener('click', function () {
        document.getElementById('documentModal').classList.add('hidden');
        setVersionsPanelVisible(false);
        setHistoryPanelVisible(false);
        window.__modalDocumentId = null;
    });

    document.getElementById('documentModal').addEventListener('click', function (e) {
        if (e.target === document.getElementById('documentModal')) {
            document.getElementById('documentModal').classList.add('hidden');
            setVersionsPanelVisible(false);
            setHistoryPanelVisible(false);
            window.__modalDocumentId = null;
        }
    });

    document.getElementById('toggleVersionsBtn').addEventListener('click', async function () {
        var panel = document.getElementById('versionsPanel');
        var hidden = panel.classList.contains('hidden');
        setVersionsPanelVisible(hidden);
        if (hidden && window.__modalDocumentId) {
            await loadVersionsIntoModal(window.__modalDocumentId);
        }
        if (typeof lucide !== 'undefined') lucide.createIcons();
    });

    document.getElementById('modalDownloadBtn').addEventListener('click', async function () {
        if (!window.__modalDocumentId) return;
        try {
            await downloadLatestXml(window.__modalDocumentId);
            showToast('Файл скачан');
        } catch (e) {
            showToast(e.message || 'Ошибка скачивания', 'error');
        }
    });

    document.getElementById('modalNewVersionBtn').addEventListener('click', function () {
        window.__replaceBaseVersionId = window.__modalCurrentVersionId || null;
        document.getElementById('documentModal').classList.add('hidden');
        setVersionsPanelVisible(false);
        setHistoryPanelVisible(false);
        navigateTo('upload');
    });

    document.getElementById('toggleHistoryBtn').addEventListener('click', async function () {
        var panel = document.getElementById('historyPanel');
        var show = panel.classList.contains('hidden');
        setHistoryPanelVisible(show);
        if (show && window.__modalDocumentId) {
            historyState.page = 0;
            await loadHistoryIntoModal(window.__modalDocumentId, 0);
        }
        if (typeof lucide !== 'undefined') lucide.createIcons();
    });

    document.getElementById('historyPrev').addEventListener('click', async function () {
        if (historyState.page > 0 && window.__modalDocumentId) {
            historyState.page -= 1;
            await loadHistoryIntoModal(window.__modalDocumentId, historyState.page);
        }
    });

    document.getElementById('historyNext').addEventListener('click', async function () {
        if (historyState.page < historyState.totalPages - 1 && window.__modalDocumentId) {
            historyState.page += 1;
            await loadHistoryIntoModal(window.__modalDocumentId, historyState.page);
        }
    });
}

window.openDocumentModal = async function (docId) {
    var idStr = typeof docId === 'string' ? docId : String(docId);
    window.__modalDocumentId = idStr;
    document.getElementById('modalDocTitle').textContent = 'Загрузка…';
    document.getElementById('documentModal').classList.remove('hidden');
    setVersionsPanelVisible(false);
    document.getElementById('versionsList').innerHTML = '';

    try {
        var doc = await getDocumentById(idStr);
        document.getElementById('modalDocTitle').textContent = doc.documentNumber || 'Документ';
        document.getElementById('modalDocNumber').textContent = doc.documentNumber || '—';
        document.getElementById('modalDocDate').textContent = formatDateRu(doc.documentDate);
        document.getElementById('modalDocType').textContent = doc.docTypeName || doc.docType || '—';
        document.getElementById('modalDocObject').textContent =
            (doc.constructionObject && doc.constructionObject.name) || '—';
        var uploaderName =
            (doc.uploadedBy && (doc.uploadedBy.fullName || doc.uploadedBy.username)) || '—';
        var uploadedByEl = document.getElementById('modalUploadedBy');
        if (uploadedByEl) {
            uploadedByEl.textContent = formatFullNameToInitials(uploaderName);
        }
        var statusEl = document.getElementById('modalDocStatus');
        statusEl.textContent = getStatusText(doc.validationStatus);
        statusEl.className = 'status-badge status-' + apiStatusToUiClass(doc.validationStatus);
        var current = (doc.versions || []).find(function (v) {
            return !!v.isCurrent;
        });
        window.__modalCurrentVersionId = current ? current.versionId : null;

        var volumes = doc.workVolumes || [];
        var volumesPanel = document.getElementById('workVolumesPanel');
        var volumesList = document.getElementById('workVolumesList');
        if (volumesList) {
            volumesList.innerHTML = volumes.map(function (v) {
                var qty = v.quantity != null ? String(v.quantity) : '—';
                return '<tr class="border-b border-gray-100 last:border-0">' +
                    '<td class="py-2 pr-4 text-gray-800">' + escapeHtml(v.workType || '—') + '</td>' +
                    '<td class="py-2 text-right text-gray-700">' + escapeHtml(qty) + '</td>' +
                    '</tr>';
            }).join('');
        }
        if (volumesPanel) {
            if (volumes.length > 0) {
                volumesPanel.classList.remove('hidden');
            } else {
                volumesPanel.classList.add('hidden');
            }
        }
    } catch (e) {
        showToast(e.message || 'Не удалось загрузить карточку', 'error');
        document.getElementById('documentModal').classList.add('hidden');
        window.__modalDocumentId = null;
    }

    if (typeof lucide !== 'undefined') lucide.createIcons();
};

// Basic Auth больше не используется: перешли на session-based login (/api/auth/*)

function formatFullNameToInitials(fullName) {
    if (!fullName) return '—';
    var parts = String(fullName)
        .trim()
        .split(/\s+/)
        .filter(Boolean);
    if (parts.length === 0) return '—';
    var last = parts[0];
    var first = parts.length > 1 ? parts[1] : '';
    var middle = parts.length > 2 ? parts[2] : '';
    var initials = '';
    if (first) initials += ' ' + first.charAt(0).toUpperCase() + '.';
    if (middle) initials += middle.charAt(0).toUpperCase() + '.';
    return (last + initials).trim();
}

function escapeHtml(s) {
    if (s == null) return '';
    return String(s)
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;');
}

function showToast(message, type) {
    type = type || 'success';
    var toast = document.getElementById('toast');
    var toastMsg = document.getElementById('toastMessage');
    var toastIcon = document.getElementById('toastIcon');
    if (!toast || !toastMsg) {
        if (typeof console !== 'undefined' && console.warn) console.warn('Toast UI missing:', message);
        try {
            alert(message);
        } catch (_) {
            // ignore
        }
        return;
    }
    toastMsg.textContent = message;
    if (toastIcon) {
        if (type === 'error') {
            toastIcon.innerHTML = '<i data-lucide="alert-circle" class="w-5 h-5 text-red-400"></i>';
        } else {
            toastIcon.innerHTML = '<i data-lucide="check-circle" class="w-5 h-5 text-green-400"></i>';
        }
    }
    if (type === 'error') {
        // handled by toastIcon
    } else {
        // handled by toastIcon
    }
    if (typeof lucide !== 'undefined') {
        lucide.createIcons();
    }
    toast.classList.remove('hidden');
    setTimeout(function () {
        toast.classList.add('hidden');
    }, 3000);
}

window.showToast = showToast;

document.addEventListener('DOMContentLoaded', async function () {
    var tbl = document.getElementById('allDocsTable');
    if (tbl) {
        window.__staticDocsTableHtml = tbl.innerHTML;
    }
    if (typeof lucide !== 'undefined') {
        lucide.createIcons();
    }
    initializeNavigation();
    initializeAuthUi();
    initializeUpload();
    initializeDocumentsFilters();
    initializeAdminUsers();
    initializeModal();
    initializePagination();
    // Всегда требуем логин при запуске
    var ok = await ensureLoggedIn();
    if (ok) {
        if (window.__authUser && String(window.__authUser.role || '').toUpperCase() === 'ADMIN') {
            navigateTo('adminUsers');
        } else {
            loadDocumentList();
        }
    }
});

window.addEventListener('error', function (event) {
    reportClientError(event && event.error ? event.error : event, 'Ошибка JS');
});

window.addEventListener('unhandledrejection', function (event) {
    reportClientError(event && event.reason ? event.reason : event, 'Unhandled Promise');
});
