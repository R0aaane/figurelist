const state = {
  prizes: [],
  stores: [],
  members: [],
  selectedStatus: '',
  selectedPrizeId: null,
  user: null
};

const statusLabels = {
  unowned: '未獲得',
  owned: '獲得済み',
  reserved: '獲得予定',
  skipped: '見送り'
};

const $ = (selector) => document.querySelector(selector);
const controlBaseUrl = 'http://localhost:4172';

async function api(path, options = {}) {
  const response = await fetch(path, {
    headers: { 'content-type': 'application/json' },
    credentials: 'same-origin',
    ...options
  });
  if (response.status === 401) {
    showAuth();
  }
  if (!response.ok) {
    const body = await response.json().catch(() => ({}));
    throw new Error(body.error || `HTTP ${response.status}`);
  }
  if (response.status === 204) return null;
  return response.json();
}

async function controlApi(path, options = {}) {
  const response = await fetch(`${controlBaseUrl}${path}`, {
    headers: { 'content-type': 'application/json' },
    ...options
  });
  if (!response.ok) throw new Error(`Control HTTP ${response.status}`);
  return response.json();
}

function escapeHtml(value) {
  return String(value ?? '').replace(/[&<>"']/g, (char) => ({
    '&': '&amp;',
    '<': '&lt;',
    '>': '&gt;',
    '"': '&quot;',
    "'": '&#39;'
  })[char]);
}

function formatDate(epochMs) {
  if (!epochMs) return '';
  return new Intl.DateTimeFormat('ja-JP', {
    dateStyle: 'medium',
    timeStyle: 'short'
  }).format(new Date(epochMs));
}

function statusChip(status) {
  return `<span class="chip ${escapeHtml(status)}">${statusLabels[status] || status}</span>`;
}

function showAuth(message = '') {
  $('#authPanel').classList.remove('hidden');
  document.querySelector('main').classList.add('hidden');
  $('#detailPanel').classList.add('hidden');
  $('#userStatus').textContent = 'Guest';
  $('#logoutButton').disabled = true;
  $('#authMessage').textContent = message;
  setAdminUi(false);
}

function showApp() {
  $('#authPanel').classList.add('hidden');
  document.querySelector('main').classList.remove('hidden');
  $('#userStatus').textContent = state.user ? `User: ${state.user.username}` : 'Guest';
  $('#logoutButton').disabled = !state.user;
  setAdminUi(Boolean(state.user?.isAdmin));
  if (!state.user?.isAdmin) {
    $('#membersView').classList.add('hidden');
    $('#auditView').classList.add('hidden');
    $('#prizesView').classList.remove('hidden');
    document.querySelectorAll('.tab').forEach((button) => {
      button.classList.toggle('active', button.dataset.view === 'prizes');
    });
  }
}

function setAdminUi(isAdmin) {
  document.querySelectorAll('.adminOnly').forEach((element) => {
    element.classList.toggle('hidden', !isAdmin);
  });
}

async function refreshServerStatus() {
  if (!state.user?.isAdmin) {
    setAdminUi(false);
    return;
  }
  const label = $('#serverStatus');
  if (!label) return;
  try {
    const status = await controlApi('/api/server/status');
    label.textContent = status.running ? `Server running :${status.appPort}` : 'Server stopped';
    $('#startServerButton').disabled = status.running;
    $('#stopServerButton').disabled = !status.running;
  } catch (_) {
    try {
      const status = await api('/api/admin/status');
      label.textContent = `Server running :${status.port}`;
      $('#startServerButton').disabled = true;
      $('#stopServerButton').disabled = false;
    } catch (error) {
      label.textContent = 'Control server offline';
      $('#startServerButton').disabled = true;
      $('#stopServerButton').disabled = true;
    }
  }
}

async function startServer() {
  if (!state.user?.isAdmin) return;
  await controlApi('/api/server/start', { method: 'POST' });
  await refreshServerStatus();
  await loadAll();
}

async function stopServer() {
  if (!state.user?.isAdmin) return;
  try {
    await controlApi('/api/server/stop', { method: 'POST' });
  } catch (_) {
    await api('/api/admin/shutdown', { method: 'POST', body: '{}' });
  }
  $('#dbStatus').textContent = 'Server stopped';
  await refreshServerStatus();
}

async function checkSession() {
  const session = await api('/api/auth/session');
  state.user = session.user;
  if (!state.user) {
    showAuth();
    return false;
  }
  showApp();
  return true;
}

async function loginOrRegister(mode) {
  const username = $('#authUsername').value.trim();
  const password = $('#authPassword').value;
  try {
    const result = await api(`/api/auth/${mode}`, {
      method: 'POST',
      body: JSON.stringify({ username, password })
    });
    state.user = result.user;
    showApp();
    await loadAll();
  } catch (error) {
    showAuth(error.message);
  }
}

async function logout() {
  await api('/api/auth/logout', { method: 'POST', body: '{}' });
  state.user = null;
  state.prizes = [];
  state.stores = [];
  showAuth();
}

async function loadAll() {
  await Promise.all([
    loadStores(),
    loadPrizes(),
    ...(state.user?.isAdmin ? [loadMembers(), loadAudit()] : []),
  ]);
  await refreshServerStatus();
  $('#dbStatus').textContent = `SQLite DB接続中 / ${state.prizes.length}件`;
}

async function loadPrizes() {
  const params = new URLSearchParams();
  if (state.selectedStatus) params.set('status', state.selectedStatus);
  const character = $('#characterFilter').value.trim();
  const series = $('#seriesFilter').value.trim();
  const storeId = $('#storeFilter').value;
  if (character) params.set('character', character);
  if (series) params.set('series', series);
  if (storeId) params.set('storeId', storeId);
  state.prizes = await api(`/api/prizes?${params.toString()}`);
  renderPrizes();
  renderSuggestions();
}

async function loadStores() {
  state.stores = await api('/api/stores');
  renderStoreFilter();
  renderStores();
}

async function loadMembers() {
  state.members = await api('/api/members/prizes');
  renderMembers();
}

async function loadAudit() {
  const logs = await api('/api/audit-logs?limit=80');
  renderAudit(logs);
}

async function searchFigures() {
  const query = $('#figureSearchInput').value.trim();
  if (!query) return;
  const results = await api(`/api/figure-search?q=${encodeURIComponent(query)}`);
  renderFigureSearchResults(results);
}

function renderFigureSearchResults(results) {
  const container = $('#figureSearchResults');
  if (!results.length) {
    container.innerHTML = '<div class="searchResult">候補が見つかりませんでした</div>';
    return;
  }
  container.innerHTML = results.map((result, index) => `
    <article class="searchResult">
      ${result.imageUrl ? `<img class="searchResultImage" src="${escapeHtml(result.imageUrl)}" alt="">` : '<div class="searchResultImage placeholder"></div>'}
      <div>
        <strong>${escapeHtml(result.title)}</strong>
        <div class="meta">
          ${escapeHtml(result.snippet || '')}<br>
          ${result.sourceUrl ? `<a href="${escapeHtml(result.sourceUrl)}" target="_blank" rel="noreferrer">${escapeHtml(result.sourceUrl)}</a>` : ''}
        </div>
      </div>
      <button class="actionButton primary" data-add-search-result="${index}">追加</button>
    </article>
  `).join('');
  container.dataset.results = JSON.stringify(results);
}

async function addFigureFromSearch(index) {
  const results = JSON.parse($('#figureSearchResults').dataset.results || '[]');
  const result = results[index];
  if (!result) return;
  await createFigure({
    title: result.title,
    workTitle: $('#figureSearchInput').value.trim() || result.title,
    characterName: $('#figureSearchInput').value.trim() || result.title,
    seriesName: '検索追加',
    maker: '未設定',
    releaseText: '未設定',
    sourceUrl: result.sourceUrl,
    imageUrl: result.imageUrl,
  });
}

async function addManualFigure() {
  const title = $('#figureSearchInput').value.trim() || prompt('追加するフィギュア名');
  if (!title) return;
  await createFigure({
    title,
    workTitle: title,
    characterName: title,
    seriesName: '手動追加',
    maker: '未設定',
    releaseText: '未設定',
  });
}

async function createFigure(payload) {
  await api('/api/prizes', {
    method: 'POST',
    body: JSON.stringify(payload),
  });
  $('#figureSearchResults').innerHTML = '';
  await loadAll();
}

function renderStoreFilter() {
  const select = $('#storeFilter');
  const current = select.value;
  select.innerHTML = '<option value="">店舗すべて</option>' + state.stores
    .filter(store => store.isRegistered)
    .map(store => `<option value="${store.id}">${escapeHtml(store.name)}</option>`)
    .join('');
  select.value = current;
}

function renderSuggestions() {
  const characters = [...new Set(state.prizes.map(prize => prize.characterName))].sort();
  const series = [...new Set(state.prizes.map(prize => prize.seriesName))].sort();
  $('#characterSuggestions').innerHTML = characters.map(value => `<option value="${escapeHtml(value)}"></option>`).join('');
  $('#seriesSuggestions').innerHTML = series.map(value => `<option value="${escapeHtml(value)}"></option>`).join('');
}

function renderPrizes() {
  const list = $('#prizeList');
  if (!state.prizes.length) {
    list.innerHTML = '<div class="prizeCard">該当するプライズはありません</div>';
    return;
  }
  list.innerHTML = state.prizes.map(prize => `
    <article class="prizeCard">
      ${prize.imageUrl ? `<img src="${escapeHtml(prize.imageUrl)}" alt="">` : '<div class="imageFallback">画像なし</div>'}
      <div>
        <div class="prizeTitle">${escapeHtml(prize.title)}</div>
        <div class="meta">
          ${escapeHtml(prize.characterName)} / ${escapeHtml(prize.seriesName)}<br>
          ${escapeHtml(prize.maker)} / ${escapeHtml(prize.releaseText)}
        </div>
        <div class="chips">${statusChip(prize.status)}</div>
      </div>
      <div class="cardActions">
        <button class="actionButton primary" data-open="${prize.id}">詳細</button>
        <select data-status-select="${prize.id}">
          ${Object.entries(statusLabels).map(([value, label]) => `<option value="${value}" ${prize.status === value ? 'selected' : ''}>${label}</option>`).join('')}
        </select>
        <button class="actionButton" data-delete="${prize.id}">削除</button>
      </div>
    </article>
  `).join('');
}

function renderStores() {
  const list = $('#storeList');
  list.innerHTML = state.stores.map(store => `
    <article class="storeCard">
      <div>
        <h3>${escapeHtml(store.name)}</h3>
        <div class="meta">
          ${escapeHtml(store.area)}
          ${store.address ? ` / ${escapeHtml(store.address)}` : ''}
          ${store.sourceUrl ? ` / <a href="${escapeHtml(store.sourceUrl)}" target="_blank" rel="noreferrer">店舗ページ</a>` : ''}
        </div>
      </div>
      <label class="switch">
        <input type="checkbox" data-store-register="${store.id}" ${store.isRegistered ? 'checked' : ''}>
        登録
      </label>
    </article>
  `).join('');
}

function renderMembers() {
  const list = $('#memberList');
  if (!state.members.length) {
    list.innerHTML = '<div class="storeCard">メンバーの獲得状況はまだありません</div>';
    return;
  }
  list.innerHTML = state.members.map(member => `
    <article class="storeCard">
      <div>
        <h3>${escapeHtml(member.username)}</h3>
        <div class="chips">
          <span class="chip owned">獲得済み ${member.counts.owned}</span>
          <span class="chip reserved">獲得予定 ${member.counts.reserved}</span>
          <span class="chip skipped">見送り ${member.counts.skipped}</span>
        </div>
        <div class="meta">
          ${member.items.length
            ? member.items.map(item => `${escapeHtml(statusLabels[item.status])}: ${escapeHtml(item.title)}`).join('<br>')
            : '登録済みの状態変更はありません'}
        </div>
      </div>
    </article>
  `).join('');
}

function renderAudit(logs) {
  const list = $('#auditList');
  if (!logs.length) {
    list.innerHTML = '<div class="auditItem">変更記録はまだありません</div>';
    return;
  }
  list.innerHTML = logs.map(log => `
    <article class="auditItem">
      <div>
        <strong>${escapeHtml(log.action)}</strong>
        <span class="meta">${escapeHtml(log.username || 'system')} / ${escapeHtml(log.tableName)} #${escapeHtml(log.rowId)} / ${formatDate(log.createdAtEpochMs)}</span>
      </div>
      <pre>${escapeHtml(JSON.stringify({
        before: log.beforeJson ? JSON.parse(log.beforeJson) : null,
        after: log.afterJson ? JSON.parse(log.afterJson) : null
      }, null, 2))}</pre>
    </article>
  `).join('');
}

async function openDetail(id) {
  state.selectedPrizeId = id;
  const detail = await api(`/api/prizes/${id}`);
  $('#detailTitle').textContent = detail.prize.characterName;
  $('#detailContent').innerHTML = detailTemplate(detail);
  $('#detailPanel').classList.remove('hidden');
}

function detailTemplate({ prize, logs, appearances }) {
  return `
    ${prize.imageUrl ? `<img class="detailImage" src="${escapeHtml(prize.imageUrl)}" alt="">` : '<div class="detailImage imageFallback">画像なし</div>'}
    <section class="formGrid">
      <h3>${escapeHtml(prize.title)}</h3>
      <div class="chips">
        ${statusChip(prize.status)}
        <span class="chip">${escapeHtml(prize.maker)}</span>
        <span class="chip">${escapeHtml(prize.releaseText)}</span>
        <span class="chip">${escapeHtml(prize.seriesName)}</span>
      </div>
      <div class="meta">
        作品: ${escapeHtml(prize.workTitle)}<br>
        キャラクター: ${escapeHtml(prize.characterName)}<br>
        ${prize.sourceUrl ? `<a href="${escapeHtml(prize.sourceUrl)}" target="_blank" rel="noreferrer">公式URLを開く</a>` : ''}
      </div>
      <label class="field">
        <span>箱画像URL</span>
        <input id="detailImageUrl" value="${escapeHtml(prize.imageUrl || '')}">
      </label>
      <div class="actions">
        <button class="actionButton" id="saveImageUrl">箱画像URLを保存</button>
        <label class="fileButton">
          画像ファイルを選択
          <input id="boxImageFile" type="file" accept="image/png,image/jpeg,image/webp,image/gif">
        </label>
        <button class="actionButton" id="uploadBoxImage">箱画像をアップロード</button>
      </div>
      <label class="field">
        <span>状態</span>
        <select id="detailStatus">
          ${Object.entries(statusLabels).map(([value, label]) => `<option value="${value}" ${prize.status === value ? 'selected' : ''}>${label}</option>`).join('')}
        </select>
      </label>
      <label class="field">
        <span>メモ</span>
        <textarea id="detailMemo" rows="4">${escapeHtml(prize.memo || '')}</textarea>
      </label>
      <button class="actionButton primary" id="saveMemo">メモを保存</button>
    </section>
    <section class="formGrid">
      <h3>登録店舗での登場予定</h3>
      ${appearances.length ? appearances.map(appearanceTemplate).join('') : '<p class="meta">登録店舗がないか、登場予定がまだ同期されていません</p>'}
    </section>
    <section class="formGrid">
      <h3>獲得ログ</h3>
      <div class="twoCols">
        <input id="logMethod" placeholder="方法">
        <input id="logPlace" placeholder="場所">
      </div>
      <div class="twoCols">
        <input id="logCost" type="number" min="0" placeholder="金額">
        <input id="logMemo" placeholder="メモ">
      </div>
      <button class="actionButton primary" id="addLog">ログ追加</button>
      ${logs.length ? logs.map(log => `
        <div class="logRow">
          <strong>${escapeHtml(log.method || '獲得')}</strong>
          <div class="meta">${[log.place, log.costYen ? `${log.costYen}円` : '', log.memo].filter(Boolean).map(escapeHtml).join(' / ')}</div>
        </div>
      `).join('') : '<p class="meta">獲得ログはまだありません</p>'}
    </section>
  `;
}

function appearanceTemplate(appearance) {
  const localValue = appearance.appearanceDateEpochMs
    ? new Date(appearance.appearanceDateEpochMs - new Date().getTimezoneOffset() * 60000).toISOString().slice(0, 16)
    : '';
  return `
    <div class="appearanceRow" data-appearance="${appearance.id}">
      <strong>${escapeHtml(appearance.storeName)}</strong>
      <div class="meta">${escapeHtml(appearance.storeArea)} / ${escapeHtml(appearance.appearanceText)}</div>
      <label class="field">
        <span>実入荷日時</span>
        <input type="datetime-local" data-appearance-date value="${localValue}">
      </label>
      <label class="field">
        <span>メモ</span>
        <input data-appearance-memo value="${escapeHtml(appearance.memo || '')}">
      </label>
      <button class="actionButton" data-save-appearance="${appearance.id}">保存</button>
    </div>
  `;
}

async function updatePrizeStatus(id, status) {
  await api(`/api/prizes/${id}/status`, {
    method: 'PATCH',
    body: JSON.stringify({ status })
  });
  await loadAll();
  if (state.selectedPrizeId === id) await openDetail(id);
}

async function deletePrize(id) {
  if (!confirm('このプライズと関連する全ユーザーの情報を削除します。')) return;
  await api(`/api/prizes/${id}`, { method: 'DELETE' });
  $('#detailPanel').classList.add('hidden');
  state.selectedPrizeId = null;
  await loadAll();
}

function bindEvents() {
  document.body.addEventListener('click', async (event) => {
    const target = event.target;
    if (!(target instanceof HTMLElement)) return;

    const tab = target.closest('.tab');
    if (tab) {
      if ((tab.dataset.view === 'members' || tab.dataset.view === 'audit') && !state.user?.isAdmin) {
        return;
      }
      document.querySelectorAll('.tab').forEach(button => button.classList.toggle('active', button === tab));
      document.querySelectorAll('.view').forEach(view => view.classList.add('hidden'));
      $(`#${tab.dataset.view}View`).classList.remove('hidden');
      if (tab.dataset.view === 'audit') await loadAudit();
      if (tab.dataset.view === 'members') await loadMembers();
      return;
    }

    if (target.matches('[data-status]')) {
      document.querySelectorAll('#statusFilter button').forEach(button => button.classList.toggle('active', button === target));
      state.selectedStatus = target.dataset.status || '';
      await loadPrizes();
      return;
    }

    const open = target.closest('[data-open]');
    if (open) return openDetail(Number(open.dataset.open));

    const del = target.closest('[data-delete]');
    if (del) return deletePrize(Number(del.dataset.delete));

    if (target.id === 'closeDetail') {
      $('#detailPanel').classList.add('hidden');
      return;
    }

    if (target.id === 'loginButton') return loginOrRegister('login');
    if (target.id === 'registerButton') return loginOrRegister('register');
    if (target.id === 'logoutButton') return logout();

    if (target.id === 'syncButton') {
      await api('/api/sync', { method: 'POST', body: '{}' });
      await loadAll();
      return;
    }

    if (target.id === 'figureSearchButton') {
      await searchFigures();
      return;
    }

    if (target.id === 'manualAddButton') {
      await addManualFigure();
      return;
    }

    const addSearchResult = target.closest('[data-add-search-result]');
    if (addSearchResult) {
      await addFigureFromSearch(Number(addSearchResult.dataset.addSearchResult));
      return;
    }

    if (target.id === 'startServerButton' && state.user?.isAdmin) return startServer();
    if (target.id === 'stopServerButton' && state.user?.isAdmin) return stopServer();

    if (target.id === 'saveImageUrl' && state.selectedPrizeId) {
      await api(`/api/prizes/${state.selectedPrizeId}/image`, {
        method: 'PATCH',
        body: JSON.stringify({ imageUrl: $('#detailImageUrl').value })
      });
      await loadAll();
      await openDetail(state.selectedPrizeId);
      return;
    }

    if (target.id === 'uploadBoxImage' && state.selectedPrizeId) {
      const file = $('#boxImageFile').files[0];
      if (!file) {
        alert('アップロードする画像ファイルを選択してください。');
        return;
      }
      const dataUrl = await readFileAsDataUrl(file);
      await api(`/api/prizes/${state.selectedPrizeId}/box-image`, {
        method: 'POST',
        body: JSON.stringify({ dataUrl, filename: file.name })
      });
      await loadAll();
      await openDetail(state.selectedPrizeId);
      return;
    }

    if (target.id === 'saveMemo' && state.selectedPrizeId) {
      await api(`/api/prizes/${state.selectedPrizeId}/memo`, {
        method: 'PATCH',
        body: JSON.stringify({ memo: $('#detailMemo').value })
      });
      await loadAll();
      await openDetail(state.selectedPrizeId);
      return;
    }

    if (target.id === 'addLog' && state.selectedPrizeId) {
      await api(`/api/prizes/${state.selectedPrizeId}/logs`, {
        method: 'POST',
        body: JSON.stringify({
          method: $('#logMethod').value,
          place: $('#logPlace').value,
          costYen: $('#logCost').value ? Number($('#logCost').value) : null,
          memo: $('#logMemo').value
        })
      });
      await loadMembers();
      await loadAudit();
      await openDetail(state.selectedPrizeId);
      return;
    }

    const saveAppearance = target.closest('[data-save-appearance]');
    if (saveAppearance) {
      const row = saveAppearance.closest('[data-appearance]');
      const dateValue = row.querySelector('[data-appearance-date]').value;
      const memo = row.querySelector('[data-appearance-memo]').value;
      const epoch = dateValue ? new Date(dateValue).getTime() : null;
      await api(`/api/appearances/${saveAppearance.dataset.saveAppearance}`, {
        method: 'PATCH',
        body: JSON.stringify({
          appearanceText: epoch ? `${formatDate(epoch)} / 手動入力` : row.querySelector('.meta').textContent.split(' / ').slice(1).join(' / '),
          appearanceDateEpochMs: epoch,
          memo
        })
      });
      await loadAudit();
      await openDetail(state.selectedPrizeId);
    }
  });

  document.body.addEventListener('change', async (event) => {
    const target = event.target;
    if (!(target instanceof HTMLElement)) return;

    if (target.matches('[data-status-select]')) {
      await updatePrizeStatus(Number(target.dataset.statusSelect), target.value);
      return;
    }

    if (target.id === 'detailStatus' && state.selectedPrizeId) {
      await updatePrizeStatus(state.selectedPrizeId, target.value);
      return;
    }

    if (target.matches('[data-store-register]')) {
      await api(`/api/stores/${target.dataset.storeRegister}/registration`, {
        method: 'PATCH',
        body: JSON.stringify({ isRegistered: target.checked })
      });
      await loadAll();
      return;
    }

    if (target.id === 'storeFilter') {
      await loadPrizes();
    }
  });

  $('#authPassword').addEventListener('keydown', (event) => {
    if (event.key === 'Enter') loginOrRegister('login');
  });
  $('#figureSearchInput').addEventListener('keydown', (event) => {
    if (event.key === 'Enter') searchFigures();
  });
  $('#characterFilter').addEventListener('input', debounce(loadPrizes, 180));
  $('#seriesFilter').addEventListener('input', debounce(loadPrizes, 180));
}

function debounce(fn, wait) {
  let timer;
  return (...args) => {
    clearTimeout(timer);
    timer = setTimeout(() => fn(...args), wait);
  };
}

function readFileAsDataUrl(file) {
  return new Promise((resolve, reject) => {
    const reader = new FileReader();
    reader.onload = () => resolve(reader.result);
    reader.onerror = () => reject(reader.error);
    reader.readAsDataURL(file);
  });
}

bindEvents();
refreshServerStatus();
checkSession()
  .then((hasSession) => {
    if (hasSession) return loadAll();
    return null;
  })
  .catch((error) => {
    showAuth(error.message);
    console.error(error);
  });
