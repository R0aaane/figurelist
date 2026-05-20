const http = require('node:http');
const fs = require('node:fs');
const path = require('node:path');
const crypto = require('node:crypto');
const { URL } = require('node:url');
const { DatabaseSync } = require('node:sqlite');

const rootDir = __dirname;
const publicDir = path.join(rootDir, 'public');
const uploadDir = path.join(publicDir, 'uploads');
const dataDir = path.join(rootDir, 'data');
const dbPath = path.join(dataDir, 'figurelist.sqlite');
const port = Number(process.env.PORT || 4173);

fs.mkdirSync(dataDir, { recursive: true });
fs.mkdirSync(uploadDir, { recursive: true });

const db = new DatabaseSync(dbPath);
db.exec('PRAGMA foreign_keys = ON');
db.exec('PRAGMA journal_mode = WAL');

const statuses = new Set(['unowned', 'owned', 'reserved', 'skipped', 'hidden']);

const samplePrizes = [
  {
    title: 'To LOVEる-とらぶる-ダークネス Aqua Float Girls フィギュア ララ',
    workTitle: 'To LOVEる-とらぶる-ダークネス',
    characterName: 'ララ',
    seriesName: 'Aqua Float Girls',
    maker: 'タイトー',
    releaseText: '2026年5月下旬',
    releaseYear: 2026,
    releaseMonth: 5,
    sourceUrl: 'https://www.taito.co.jp/taito-prize/0452036800',
    imageUrl: 'https://www.taito.co.jp/Content/images/zone/2/item/201407/bfdd698a-de04-475a-b4c7-0510ded9e3c8_p_01_ja.jpg'
  },
  {
    title: 'To LOVEる-とらぶる-ダークネス Desktop Cute フィギュア モモ ルームウェアver.',
    workTitle: 'To LOVEる-とらぶる-ダークネス',
    characterName: 'モモ',
    seriesName: 'Desktop Cute',
    maker: 'タイトー',
    releaseText: '2026年5月下旬',
    releaseYear: 2026,
    releaseMonth: 5,
    sourceUrl: 'https://www.taito.co.jp/taito-prize/0452036900',
    imageUrl: 'https://www.taito.co.jp/Content/images/zone/2/item/201407/1607416d-b053-4d17-91cd-7d94e64d250a_p_01_ja.jpg'
  },
  {
    title: 'To LOVEる-とらぶる-ダークネス BiCute Bunnies Figure モモ white ver.',
    workTitle: 'To LOVEる-とらぶる-ダークネス',
    characterName: 'モモ',
    seriesName: 'BiCute Bunnies',
    maker: 'フリュー',
    releaseText: '2026年5月 第4週',
    releaseYear: 2026,
    releaseMonth: 5,
    sourceUrl: 'https://charahiroba.com/prize/item/detail?id=16028',
    imageUrl: 'https://file.charahiroba.com/img/trans/contents/18461_p_thu.jpg'
  },
  {
    title: 'To LOVEる-とらぶる-ダークネス Desktop Cute フィギュア 金色の闇 チャイナドレスver. Renewal',
    workTitle: 'To LOVEる-とらぶる-ダークネス',
    characterName: '金色の闇',
    seriesName: 'Desktop Cute',
    maker: 'タイトー',
    releaseText: '2026年4月下旬',
    releaseYear: 2026,
    releaseMonth: 4,
    sourceUrl: 'https://www.taito.co.jp/taito-prize/0452027900',
    imageUrl: 'https://www.taito.co.jp/Content/images/zone/2/item/201407/03c54252-dd66-4fb6-a57b-47f3a0283989_p_01_ja.jpg'
  },
  {
    title: 'To LOVEる-とらぶる-ダークネス Trio-Try-iT Figure 結城美柑',
    workTitle: 'To LOVEる-とらぶる-ダークネス',
    characterName: '結城美柑',
    seriesName: 'Trio-Try-iT',
    maker: 'フリュー',
    releaseText: '2026年4月 第2週',
    releaseYear: 2026,
    releaseMonth: 4,
    sourceUrl: 'https://charahiroba.com/prize/item/detail?id=15814',
    imageUrl: 'https://file.charahiroba.com/img/trans/contents/18139_p_thu.jpg'
  },
  {
    title: 'To LOVEる-とらぶる-ダークネス Desktop Cute フィギュア 西連寺春菜 チャイナドレスver.',
    workTitle: 'To LOVEる-とらぶる-ダークネス',
    characterName: '西連寺春菜',
    seriesName: 'Desktop Cute',
    maker: 'タイトー',
    releaseText: '2026年3月下旬',
    releaseYear: 2026,
    releaseMonth: 3,
    sourceUrl: 'https://www.taito.co.jp/taito-prize/0452014500',
    imageUrl: 'https://www.taito.co.jp/Content/images/zone/2/item/201407/2a38ce37-2aaa-4ebe-bf4f-c80d027e0a98_p_01_ja.jpg'
  },
  {
    title: 'To LOVEる-とらぶる-ダークネス Desktop Cute フィギュア 古手川唯 ルームウェアver.',
    workTitle: 'To LOVEる-とらぶる-ダークネス',
    characterName: '古手川唯',
    seriesName: 'Desktop Cute',
    maker: 'タイトー',
    releaseText: '2026年2月中旬',
    releaseYear: 2026,
    releaseMonth: 2,
    sourceUrl: 'https://www.taito.co.jp/taito-prize/0451997100',
    imageUrl: 'https://www.taito.co.jp/Content/images/zone/2/item/201407/488c6437-883d-4f52-bfd5-ab7531b36874_p_01_ja.jpg'
  },
  {
    title: 'To LOVEる-とらぶる-ダークネス Desktop Cute フィギュア ララ ルームウェアver.',
    workTitle: 'To LOVEる-とらぶる-ダークネス',
    characterName: 'ララ',
    seriesName: 'Desktop Cute',
    maker: 'タイトー',
    releaseText: '2025年12月中旬',
    releaseYear: 2025,
    releaseMonth: 12,
    sourceUrl: 'https://www.taito.co.jp/taito-prize/0451971500',
    imageUrl: 'https://www.taito.co.jp/Content/images/zone/2/item/201407/a2f82b2f-c752-4c46-8207-d0e3b2bd8262_p_01_ja.jpg'
  }
];

const supplementalPrizes = [
  {
    title: 'To LOVEる-とらぶる-ダークネス BiCute Bunnies Figure 金色の闇',
    workTitle: 'To LOVEる-とらぶる-ダークネス',
    characterName: '金色の闇',
    seriesName: 'BiCute Bunnies',
    maker: 'フリュー',
    releaseText: '2026年4月 第2週',
    releaseYear: 2026,
    releaseMonth: 4,
    sourceUrl: 'https://charahiroba.com/prize/item/detail?id=15815',
    imageUrl: 'https://file.charahiroba.com/img/trans/contents/18140_p_thu.jpg'
  },
  {
    title: 'To LOVEる-とらぶる-ダークネス Aqua Float Girls フィギュア モモ',
    workTitle: 'To LOVEる-とらぶる-ダークネス',
    characterName: 'モモ',
    seriesName: 'Aqua Float Girls',
    maker: 'タイトー',
    releaseText: '2026年3月中旬',
    releaseYear: 2026,
    releaseMonth: 3,
    sourceUrl: 'https://www.taito.co.jp/taito-prize/0452014400',
    imageUrl: 'https://www.taito.co.jp/Content/images/zone/2/item/201407/6699f430-3673-4da5-87f2-e1ec294ef8d8_p_01_ja.jpg'
  },
  {
    title: 'To LOVEる-とらぶる-ダークネス Trio-Try-iT Figure モモ・ベリア・デビルーク',
    workTitle: 'To LOVEる-とらぶる-ダークネス',
    characterName: 'モモ',
    seriesName: 'Trio-Try-iT',
    maker: 'フリュー',
    releaseText: '2026年3月 第3週',
    releaseYear: 2026,
    releaseMonth: 3,
    sourceUrl: 'https://charahiroba.com/prize/item/detail?id=15681',
    imageUrl: 'https://file.charahiroba.com/img/trans/contents/17970_p_thu.jpg'
  },
  {
    title: 'To LOVEる-とらぶる-ダークネス Trio-Try-iT Figure ララ・サタリン・デビルーク',
    workTitle: 'To LOVEる-とらぶる-ダークネス',
    characterName: 'ララ',
    seriesName: 'Trio-Try-iT',
    maker: 'フリュー',
    releaseText: '2026年2月 第3週',
    releaseYear: 2026,
    releaseMonth: 2,
    sourceUrl: 'https://charahiroba.com/prize/item/detail?id=15517',
    imageUrl: 'https://file.charahiroba.com/img/trans/contents/17697_p_thu.jpg'
  },
  {
    title: 'To LOVEる-とらぶる-ダークネス Trio-Try-iT Figure 古手川唯',
    workTitle: 'To LOVEる-とらぶる-ダークネス',
    characterName: '古手川唯',
    seriesName: 'Trio-Try-iT',
    maker: 'フリュー',
    releaseText: '2026年2月 第3週',
    releaseYear: 2026,
    releaseMonth: 2,
    sourceUrl: 'https://charahiroba.com/prize/item/detail?id=15516',
    imageUrl: 'https://file.charahiroba.com/img/trans/contents/17696_p_thu.jpg'
  },
  {
    title: 'To LOVEる-とらぶる-ダークネス Aqua Float Girls フィギュア 結城美柑',
    workTitle: 'To LOVEる-とらぶる-ダークネス',
    characterName: '結城美柑',
    seriesName: 'Aqua Float Girls',
    maker: 'タイトー',
    releaseText: '2026年1月下旬',
    releaseYear: 2026,
    releaseMonth: 1,
    sourceUrl: 'https://www.taito.co.jp/taito-prize/0451992700',
    imageUrl: 'https://www.taito.co.jp/Content/images/zone/2/item/201407/ba25c024-ae95-4691-b7ac-aa60d81ba974_p_01_ja.jpg'
  },
  {
    title: 'To LOVEる-とらぶる-ダークネス Desktop Cute フィギュア ナナ チャイナドレスver.',
    workTitle: 'To LOVEる-とらぶる-ダークネス',
    characterName: 'ナナ',
    seriesName: 'Desktop Cute',
    maker: 'タイトー',
    releaseText: '2026年1月中旬',
    releaseYear: 2026,
    releaseMonth: 1,
    sourceUrl: 'https://www.taito.co.jp/taito-prize/0451993200',
    imageUrl: 'https://www.taito.co.jp/Content/images/zone/2/item/201407/23cfc56b-2d83-42d1-99ff-bdd85ba2da68_p_01_ja.jpg'
  },
  {
    title: 'To LOVEる-とらぶる-ダークネス BiCute Bunnies Figure モモ・ベリア・デビルーク',
    workTitle: 'To LOVEる-とらぶる-ダークネス',
    characterName: 'モモ',
    seriesName: 'BiCute Bunnies',
    maker: 'フリュー',
    releaseText: '2025年12月 第3週',
    releaseYear: 2025,
    releaseMonth: 12,
    sourceUrl: 'https://charahiroba.com/prize/item/detail?id=15153',
    imageUrl: 'https://file.charahiroba.com/img/trans/contents/18460_p_thu.jpg'
  },
  {
    title: 'To LOVEる-とらぶる-ダークネス Desktop Cute フィギュア 金色の闇 ルームウェアver.',
    workTitle: 'To LOVEる-とらぶる-ダークネス',
    characterName: '金色の闇',
    seriesName: 'Desktop Cute',
    maker: 'タイトー',
    releaseText: '2025年11月下旬',
    releaseYear: 2025,
    releaseMonth: 11,
    sourceUrl: 'https://www.taito.co.jp/taito-prize/0451955000',
    imageUrl: 'https://www.taito.co.jp/Content/images/zone/2/item/201407/726d90df-87a2-4cd7-8da5-90049aefba35_p_01_ja.jpg'
  },
  {
    title: 'To LOVEる-とらぶる-ダークネス Desktop Cute フィギュア 結城美柑 チャイナドレスver.',
    workTitle: 'To LOVEる-とらぶる-ダークネス',
    characterName: '結城美柑',
    seriesName: 'Desktop Cute',
    maker: 'タイトー',
    releaseText: '2025年10月中旬',
    releaseYear: 2025,
    releaseMonth: 10,
    sourceUrl: 'https://www.taito.co.jp/taito-prize/0451947500',
    imageUrl: 'https://www.taito.co.jp/Content/images/zone/2/item/201407/845df675-3cf4-4f86-a747-319fb1ae13d9_p_01_ja.jpg'
  },
  {
    title: 'To LOVEる-とらぶる-ダークネス Desktop Cute フィギュア 古手川唯 チャイナドレスver.',
    workTitle: 'To LOVEる-とらぶる-ダークネス',
    characterName: '古手川唯',
    seriesName: 'Desktop Cute',
    maker: 'タイトー',
    releaseText: '2025年7月中旬',
    releaseYear: 2025,
    releaseMonth: 7,
    sourceUrl: 'https://www.taito.co.jp/taito-prize/0451904800',
    imageUrl: 'https://www.taito.co.jp/Content/images/zone/2/item/201407/c76cea0a-43a5-48ba-acc8-fb8d518ab72b_p_01_ja.jpg'
  }
];

const allSamplePrizes = [...samplePrizes, ...supplementalPrizes];

const sampleStores = [
  { name: 'タイトーステーション 名古屋名駅店', area: '名古屋駅', address: '愛知県名古屋市中村区', sourceUrl: 'https://www.taito.co.jp/store/00002253' },
  { name: 'タイトーステーション 大須店', area: '大須', address: null, sourceUrl: 'https://www.taito.co.jp/store/00002035' },
  { name: 'GiGO 金山', area: '金山', address: '愛知県名古屋市熱田区金山1-19-2', sourceUrl: 'https://tempo.gendagigo.jp/am/kanayama' },
  { name: 'namco名古屋駅前店', area: '名古屋駅', address: null, sourceUrl: 'https://bandainamco-am.co.jp/game_center/loc/nagoyaekimae/index.html?p=prize_info' },
  { name: 'ラウンドワン 千種店', area: '千種', address: '愛知県名古屋市千種区新栄3-20-17', sourceUrl: 'https://www.round1.co.jp/service/amuse/news/crane.html' }
];

function migrate() {
  db.exec(`
    CREATE TABLE IF NOT EXISTS prize_items (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      workTitle TEXT NOT NULL,
      characterName TEXT NOT NULL,
      seriesName TEXT NOT NULL,
      maker TEXT NOT NULL,
      releaseText TEXT NOT NULL,
      releaseYear INTEGER,
      releaseMonth INTEGER,
      sourceUrl TEXT,
      imageUrl TEXT,
      status TEXT NOT NULL DEFAULT 'unowned',
      memo TEXT,
      acquiredAtEpochMs INTEGER,
      createdAtEpochMs INTEGER NOT NULL,
      updatedAtEpochMs INTEGER NOT NULL
    );
    CREATE TABLE IF NOT EXISTS prize_acquisition_logs (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      prizeId INTEGER NOT NULL REFERENCES prize_items(id) ON DELETE CASCADE,
      method TEXT,
      place TEXT,
      costYen INTEGER,
      memo TEXT,
      createdAtEpochMs INTEGER NOT NULL
    );
    CREATE TABLE IF NOT EXISTS prize_stores (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      area TEXT NOT NULL,
      address TEXT,
      sourceUrl TEXT,
      isRegistered INTEGER NOT NULL DEFAULT 0,
      createdAtEpochMs INTEGER NOT NULL,
      updatedAtEpochMs INTEGER NOT NULL
    );
    CREATE TABLE IF NOT EXISTS prize_store_appearances (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      prizeId INTEGER NOT NULL REFERENCES prize_items(id) ON DELETE CASCADE,
      storeId INTEGER NOT NULL REFERENCES prize_stores(id) ON DELETE CASCADE,
      appearanceText TEXT NOT NULL,
      appearanceDateEpochMs INTEGER,
      sourceUrl TEXT,
      memo TEXT,
      createdAtEpochMs INTEGER NOT NULL,
      updatedAtEpochMs INTEGER NOT NULL,
      UNIQUE(prizeId, storeId)
    );
    CREATE TABLE IF NOT EXISTS audit_logs (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      userId INTEGER,
      tableName TEXT NOT NULL,
      rowId INTEGER,
      action TEXT NOT NULL,
      beforeJson TEXT,
      afterJson TEXT,
      createdAtEpochMs INTEGER NOT NULL
    );
    CREATE TABLE IF NOT EXISTS users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      username TEXT NOT NULL UNIQUE,
      passwordSalt TEXT NOT NULL,
      passwordHash TEXT NOT NULL,
      createdAtEpochMs INTEGER NOT NULL
    );
    CREATE TABLE IF NOT EXISTS sessions (
      id TEXT PRIMARY KEY,
      userId INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
      createdAtEpochMs INTEGER NOT NULL,
      expiresAtEpochMs INTEGER NOT NULL
    );
    CREATE TABLE IF NOT EXISTS user_prize_states (
      userId INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
      prizeId INTEGER NOT NULL REFERENCES prize_items(id) ON DELETE CASCADE,
      status TEXT NOT NULL DEFAULT 'unowned',
      memo TEXT,
      acquiredAtEpochMs INTEGER,
      createdAtEpochMs INTEGER NOT NULL,
      updatedAtEpochMs INTEGER NOT NULL,
      PRIMARY KEY (userId, prizeId)
    );
    CREATE TABLE IF NOT EXISTS user_acquisition_logs (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      userId INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
      prizeId INTEGER NOT NULL REFERENCES prize_items(id) ON DELETE CASCADE,
      method TEXT,
      place TEXT,
      costYen INTEGER,
      memo TEXT,
      createdAtEpochMs INTEGER NOT NULL
    );
  `);
  ensureColumn('audit_logs', 'userId', 'INTEGER');
}

function now() {
  return Date.now();
}

function getRow(table, id) {
  return db.prepare(`SELECT * FROM ${table} WHERE id = ?`).get(id) || null;
}

function ensureColumn(tableName, columnName, definition) {
  const columns = db.prepare(`PRAGMA table_info(${tableName})`).all();
  if (!columns.some((column) => column.name === columnName)) {
    db.exec(`ALTER TABLE ${tableName} ADD COLUMN ${columnName} ${definition}`);
  }
}

function recordAudit(tableName, rowId, action, before, after, userId = null) {
  db.prepare(`
    INSERT INTO audit_logs (userId, tableName, rowId, action, beforeJson, afterJson, createdAtEpochMs)
    VALUES (?, ?, ?, ?, ?, ?, ?)
  `).run(userId, tableName, rowId, action, before ? JSON.stringify(before) : null, after ? JSON.stringify(after) : null, now());
}

function seed() {
  db.exec('BEGIN');
  try {
    for (const item of allSamplePrizes) {
      const existing = item.sourceUrl
        ? db.prepare('SELECT * FROM prize_items WHERE sourceUrl = ?').get(item.sourceUrl)
        : null;
      if (existing) {
        const before = { ...existing };
        db.prepare(`
          UPDATE prize_items SET title = ?, workTitle = ?, characterName = ?, seriesName = ?, maker = ?,
          releaseText = ?, releaseYear = ?, releaseMonth = ?, imageUrl = COALESCE(imageUrl, ?), updatedAtEpochMs = ?
          WHERE id = ?
        `).run(item.title, item.workTitle, item.characterName, item.seriesName, item.maker, item.releaseText, item.releaseYear, item.releaseMonth, item.imageUrl, now(), existing.id);
        recordAudit('prize_items', existing.id, 'sync_update', before, getRow('prize_items', existing.id));
      } else {
        const created = now();
        const result = db.prepare(`
          INSERT INTO prize_items (title, workTitle, characterName, seriesName, maker, releaseText, releaseYear, releaseMonth, sourceUrl, imageUrl, createdAtEpochMs, updatedAtEpochMs)
          VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        `).run(item.title, item.workTitle, item.characterName, item.seriesName, item.maker, item.releaseText, item.releaseYear, item.releaseMonth, item.sourceUrl, item.imageUrl, created, created);
        recordAudit('prize_items', result.lastInsertRowid, 'sync_insert', null, getRow('prize_items', result.lastInsertRowid));
      }
    }

    for (const store of sampleStores) {
      const existing = db.prepare('SELECT * FROM prize_stores WHERE name = ? AND area = ?').get(store.name, store.area);
      if (existing) {
        const before = { ...existing };
        db.prepare('UPDATE prize_stores SET address = ?, sourceUrl = ?, updatedAtEpochMs = ? WHERE id = ?')
          .run(store.address, store.sourceUrl, now(), existing.id);
        recordAudit('prize_stores', existing.id, 'sync_update', before, getRow('prize_stores', existing.id));
      } else {
        const created = now();
        const result = db.prepare(`
          INSERT INTO prize_stores (name, area, address, sourceUrl, createdAtEpochMs, updatedAtEpochMs)
          VALUES (?, ?, ?, ?, ?, ?)
        `).run(store.name, store.area, store.address, store.sourceUrl, created, created);
        recordAudit('prize_stores', result.lastInsertRowid, 'sync_insert', null, getRow('prize_stores', result.lastInsertRowid));
      }
    }

    syncAppearances(false);
    db.exec('COMMIT');
  } catch (error) {
    db.exec('ROLLBACK');
    throw error;
  }
}

function syncAppearances(createAudit = true) {
  const prizes = db.prepare('SELECT * FROM prize_items').all();
  const stores = db.prepare('SELECT * FROM prize_stores WHERE isRegistered = 1').all();
  const statement = db.prepare(`
    INSERT INTO prize_store_appearances (prizeId, storeId, appearanceText, appearanceDateEpochMs, sourceUrl, memo, createdAtEpochMs, updatedAtEpochMs)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?)
    ON CONFLICT(prizeId, storeId) DO UPDATE SET
      appearanceText = excluded.appearanceText,
      sourceUrl = excluded.sourceUrl,
      memo = COALESCE(prize_store_appearances.memo, excluded.memo),
      updatedAtEpochMs = excluded.updatedAtEpochMs
  `);

  for (const store of stores) {
    for (const prize of prizes) {
      const before = db.prepare('SELECT * FROM prize_store_appearances WHERE prizeId = ? AND storeId = ?').get(prize.id, store.id) || null;
      const created = now();
      const text = `${prize.releaseText} / メーカー登場時期ベース`;
      statement.run(prize.id, store.id, text, null, store.sourceUrl, '店舗の実入荷は未検出。公式情報・店舗告知で確認してください', created, created);
      const after = db.prepare('SELECT * FROM prize_store_appearances WHERE prizeId = ? AND storeId = ?').get(prize.id, store.id);
      if (createAudit) recordAudit('prize_store_appearances', after.id, before ? 'sync_update' : 'sync_insert', before, after);
    }
  }
}

function readJson(req) {
  return new Promise((resolve, reject) => {
    let body = '';
    req.on('data', chunk => {
      body += chunk;
      if (body.length > 1_000_000) req.destroy();
    });
    req.on('end', () => {
      if (!body) return resolve({});
      try {
        resolve(JSON.parse(body));
      } catch (error) {
        reject(error);
      }
    });
  });
}

function send(res, status, value) {
  res.writeHead(status, { 'content-type': 'application/json; charset=utf-8' });
  res.end(JSON.stringify(value));
}

function sendError(res, status, message) {
  send(res, status, { error: message });
}

function toBool(value) {
  return value === 1 || value === true;
}

function parseCookies(req) {
  const header = req.headers.cookie || '';
  return Object.fromEntries(
    header
      .split(';')
      .map((part) => part.trim())
      .filter(Boolean)
      .map((part) => {
        const index = part.indexOf('=');
        return index === -1
          ? [part, '']
          : [part.slice(0, index), decodeURIComponent(part.slice(index + 1))];
      })
  );
}

function hashPassword(password, salt = crypto.randomBytes(16).toString('hex')) {
  const hash = crypto.pbkdf2Sync(password, salt, 120000, 32, 'sha256').toString('hex');
  return { salt, hash };
}

function verifyPassword(password, salt, expectedHash) {
  const actualHash = hashPassword(password, salt).hash;
  return crypto.timingSafeEqual(Buffer.from(actualHash, 'hex'), Buffer.from(expectedHash, 'hex'));
}

function createSession(userId) {
  const id = crypto.randomBytes(32).toString('hex');
  const createdAt = now();
  const expiresAt = createdAt + 1000 * 60 * 60 * 24 * 30;
  db.prepare('INSERT INTO sessions (id, userId, createdAtEpochMs, expiresAtEpochMs) VALUES (?, ?, ?, ?)')
    .run(id, userId, createdAt, expiresAt);
  return { id, expiresAt };
}

function sessionCookie(session) {
  const maxAge = Math.floor((session.expiresAt - now()) / 1000);
  return `figurelist_session=${encodeURIComponent(session.id)}; Path=/; HttpOnly; SameSite=Lax; Max-Age=${maxAge}`;
}

function clearSessionCookie() {
  return 'figurelist_session=; Path=/; HttpOnly; SameSite=Lax; Max-Age=0';
}

function currentUser(req) {
  const sessionId = parseCookies(req).figurelist_session;
  if (!sessionId) return null;
  const row = db.prepare(`
    SELECT u.id, u.username
    FROM sessions s
    JOIN users u ON u.id = s.userId
    WHERE s.id = ? AND s.expiresAtEpochMs > ?
  `).get(sessionId, now());
  return row || null;
}

function isAdmin(user) {
  return user?.username === 'admin';
}

function getUserState(userId, prizeId) {
  return db.prepare('SELECT * FROM user_prize_states WHERE userId = ? AND prizeId = ?').get(userId, prizeId) || null;
}

function getPrizeForUser(userId, prizeId) {
  return db.prepare(`
    SELECT p.*,
      COALESCE(s.status, p.status) AS status,
      COALESCE(s.memo, p.memo) AS memo,
      COALESCE(s.acquiredAtEpochMs, p.acquiredAtEpochMs) AS acquiredAtEpochMs,
      COALESCE(s.updatedAtEpochMs, p.updatedAtEpochMs) AS updatedAtEpochMs
    FROM prize_items p
    LEFT JOIN user_prize_states s ON s.prizeId = p.id AND s.userId = ?
    WHERE p.id = ? AND (s.status IS NULL OR s.status <> 'hidden')
  `).get(userId, prizeId) || null;
}

function normalizePrize(row) {
  return row ? { ...row, isRegistered: undefined } : null;
}

async function handleApi(req, res, url) {
  const method = req.method || 'GET';
  const segments = url.pathname.split('/').filter(Boolean).slice(1);

  if (method === 'GET' && segments[0] === 'auth' && segments[1] === 'session') {
    const user = currentUser(req);
    return send(res, 200, {
      user: user == null ? null : {...user, isAdmin: isAdmin(user)},
    });
  }

  if (method === 'POST' && segments[0] === 'auth' && segments[1] === 'register') {
    const body = await readJson(req);
    const username = blank(body.username);
    const password = typeof body.password === 'string' ? body.password : '';
    if (!username || username.length < 3 || username.length > 32) {
      return sendError(res, 400, 'Username must be 3-32 characters');
    }
    if (password.length < 6) {
      return sendError(res, 400, 'Password must be at least 6 characters');
    }
    const passwordData = hashPassword(password);
    try {
      const result = db.prepare(`
        INSERT INTO users (username, passwordSalt, passwordHash, createdAtEpochMs)
        VALUES (?, ?, ?, ?)
      `).run(username, passwordData.salt, passwordData.hash, now());
      const session = createSession(result.lastInsertRowid);
      res.setHeader('set-cookie', sessionCookie(session));
      return send(res, 201, {
        user: {
          id: result.lastInsertRowid,
          username,
          isAdmin: username === 'admin',
        },
      });
    } catch (error) {
      return sendError(res, 409, 'Username already exists');
    }
  }

  if (method === 'POST' && segments[0] === 'auth' && segments[1] === 'login') {
    const body = await readJson(req);
    const username = blank(body.username);
    const password = typeof body.password === 'string' ? body.password : '';
    const user = username
      ? db.prepare('SELECT * FROM users WHERE username = ?').get(username)
      : null;
    if (!user || !verifyPassword(password, user.passwordSalt, user.passwordHash)) {
      return sendError(res, 401, 'Invalid username or password');
    }
    const session = createSession(user.id);
    res.setHeader('set-cookie', sessionCookie(session));
    return send(res, 200, {
      user: {
        id: user.id,
        username: user.username,
        isAdmin: user.username === 'admin',
      },
    });
  }

  if (method === 'POST' && segments[0] === 'auth' && segments[1] === 'logout') {
    const sessionId = parseCookies(req).figurelist_session;
    if (sessionId) {
      db.prepare('DELETE FROM sessions WHERE id = ?').run(sessionId);
    }
    res.setHeader('set-cookie', clearSessionCookie());
    return send(res, 200, { ok: true });
  }

  const user = currentUser(req);
  if (!user) {
    return sendError(res, 401, 'Authentication required');
  }

  if (method === 'GET' && segments[0] === 'prizes' && segments.length === 1) {
    const includeHidden = url.searchParams.get('includeHidden') === '1';
    const where = [];
    const params = [];
    if (!includeHidden) {
      where.push('(s.status IS NULL OR s.status <> ?)');
      params.push('hidden');
    }
    const status = url.searchParams.get('status');
    const character = url.searchParams.get('character');
    const series = url.searchParams.get('series');
    const storeId = url.searchParams.get('storeId');
    if (status) {
      where.push('COALESCE(s.status, p.status) = ?');
      params.push(status);
    }
    if (character) {
      where.push('p.characterName LIKE ?');
      params.push(`%${character}%`);
    }
    if (series) {
      where.push('p.seriesName LIKE ?');
      params.push(`%${series}%`);
    }
    if (storeId) {
      where.push('EXISTS (SELECT 1 FROM prize_store_appearances a WHERE a.prizeId = p.id AND a.storeId = ?)');
      params.push(Number(storeId));
    }
    const sql = `
      SELECT p.*,
        COALESCE(s.status, p.status) AS status,
        COALESCE(s.memo, p.memo) AS memo,
        COALESCE(s.acquiredAtEpochMs, p.acquiredAtEpochMs) AS acquiredAtEpochMs,
        COALESCE(s.updatedAtEpochMs, p.updatedAtEpochMs) AS updatedAtEpochMs
      FROM prize_items p
      LEFT JOIN user_prize_states s ON s.prizeId = p.id AND s.userId = ?
      ${where.length ? `WHERE ${where.join(' AND ')}` : ''}
      ORDER BY p.releaseYear DESC NULLS LAST, p.releaseMonth DESC NULLS LAST, COALESCE(s.updatedAtEpochMs, p.updatedAtEpochMs) DESC
    `;
    return send(res, 200, db.prepare(sql).all(user.id, ...params).map(normalizePrize));
  }

  if (method === 'GET' && segments[0] === 'prizes' && segments.length === 2) {
    const id = Number(segments[1]);
    const prize = normalizePrize(getPrizeForUser(user.id, id));
    if (!prize) return sendError(res, 404, 'Prize not found');
    const logs = db.prepare('SELECT * FROM user_acquisition_logs WHERE userId = ? AND prizeId = ? ORDER BY createdAtEpochMs DESC').all(user.id, id);
    const appearances = db.prepare(`
      SELECT a.*, s.name AS storeName, s.area AS storeArea, s.address AS storeAddress, s.isRegistered AS storeIsRegistered
      FROM prize_store_appearances a
      JOIN prize_stores s ON s.id = a.storeId
      WHERE a.prizeId = ? AND s.isRegistered = 1
      ORDER BY s.area, s.name
    `).all(id);
    return send(res, 200, { prize, logs, appearances });
  }

  if (method === 'GET' && segments[0] === 'figure-search') {
    const query = url.searchParams.get('q') || '';
    return send(res, 200, await searchFigureCandidates(query));
  }

  if (method === 'POST' && segments[0] === 'prizes' && segments.length === 1) {
    const body = await readJson(req);
    const title = blank(body.title);
    if (!title) return sendError(res, 400, 'Title is required');
    const createdAt = now();
    const result = db.prepare(`
      INSERT INTO prize_items (
        title, workTitle, characterName, seriesName, maker, releaseText,
        releaseYear, releaseMonth, sourceUrl, imageUrl, createdAtEpochMs, updatedAtEpochMs
      )
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    `).run(
      title,
      blank(body.workTitle) || title,
      blank(body.characterName) || title,
      blank(body.seriesName) || '手動追加',
      blank(body.maker) || '未設定',
      blank(body.releaseText) || '未設定',
      Number.isInteger(body.releaseYear) ? body.releaseYear : null,
      Number.isInteger(body.releaseMonth) ? body.releaseMonth : null,
      blank(body.sourceUrl),
      blank(body.imageUrl),
      createdAt,
      createdAt
    );
    const after = getRow('prize_items', result.lastInsertRowid);
    recordAudit('prize_items', result.lastInsertRowid, 'manual_insert', null, after, user.id);
    return send(res, 201, getPrizeForUser(user.id, result.lastInsertRowid));
  }

  if (method === 'PATCH' && segments[0] === 'prizes' && segments[2] === 'status') {
    const id = Number(segments[1]);
    const body = await readJson(req);
    if (!statuses.has(body.status)) return sendError(res, 400, 'Unknown status');
    if (!getRow('prize_items', id)) return sendError(res, 404, 'Prize not found');
    const before = getUserState(user.id, id);
    const acquired = body.status === 'owned' ? now() : null;
    const updatedAt = now();
    db.prepare(`
      INSERT INTO user_prize_states (userId, prizeId, status, memo, acquiredAtEpochMs, createdAtEpochMs, updatedAtEpochMs)
      VALUES (?, ?, ?, NULL, ?, ?, ?)
      ON CONFLICT(userId, prizeId) DO UPDATE SET
        status = excluded.status,
        acquiredAtEpochMs = excluded.acquiredAtEpochMs,
        updatedAtEpochMs = excluded.updatedAtEpochMs
    `).run(user.id, id, body.status, acquired, updatedAt, updatedAt);
    const after = getUserState(user.id, id);
    recordAudit('user_prize_states', id, 'status_update', before, after, user.id);
    return send(res, 200, getPrizeForUser(user.id, id));
  }

  if (method === 'PATCH' && segments[0] === 'prizes' && segments[2] === 'memo') {
    const id = Number(segments[1]);
    const body = await readJson(req);
    if (!getRow('prize_items', id)) return sendError(res, 404, 'Prize not found');
    const before = getUserState(user.id, id);
    const memo = typeof body.memo === 'string' && body.memo.trim() ? body.memo.trim() : null;
    const existing = getUserState(user.id, id);
    const updatedAt = now();
    db.prepare(`
      INSERT INTO user_prize_states (userId, prizeId, status, memo, acquiredAtEpochMs, createdAtEpochMs, updatedAtEpochMs)
      VALUES (?, ?, ?, ?, NULL, ?, ?)
      ON CONFLICT(userId, prizeId) DO UPDATE SET
        memo = excluded.memo,
        updatedAtEpochMs = excluded.updatedAtEpochMs
    `).run(user.id, id, existing?.status || 'unowned', memo, updatedAt, updatedAt);
    const after = getUserState(user.id, id);
    recordAudit('user_prize_states', id, 'memo_update', before, after, user.id);
    return send(res, 200, getPrizeForUser(user.id, id));
  }

  if (method === 'PATCH' && segments[0] === 'prizes' && segments[2] === 'image') {
    const id = Number(segments[1]);
    const body = await readJson(req);
    const before = getRow('prize_items', id);
    if (!before) return sendError(res, 404, 'Prize not found');
    const imageUrl = blank(body.imageUrl);
    db.prepare('UPDATE prize_items SET imageUrl = ?, updatedAtEpochMs = ? WHERE id = ?').run(imageUrl, now(), id);
    const after = getRow('prize_items', id);
    recordAudit('prize_items', id, 'image_update', before, after, user.id);
    return send(res, 200, getPrizeForUser(user.id, id));
  }

  if (method === 'POST' && segments[0] === 'prizes' && segments[2] === 'box-image') {
    const id = Number(segments[1]);
    const before = getRow('prize_items', id);
    if (!before) return sendError(res, 404, 'Prize not found');
    const body = await readJson(req);
    const dataUrl = typeof body.dataUrl === 'string' ? body.dataUrl : '';
    const match = dataUrl.match(/^data:(image\/(?:png|jpeg|webp|gif));base64,([A-Za-z0-9+/=]+)$/);
    if (!match) return sendError(res, 400, 'Unsupported image data');

    const extByMime = {
      'image/png': 'png',
      'image/jpeg': 'jpg',
      'image/webp': 'webp',
      'image/gif': 'gif'
    };
    const bytes = Buffer.from(match[2], 'base64');
    if (bytes.length > 5 * 1024 * 1024) {
      return sendError(res, 400, 'Image must be 5MB or smaller');
    }

    const filename = `prize-${id}-${now()}-${crypto.randomBytes(4).toString('hex')}.${extByMime[match[1]]}`;
    fs.writeFileSync(path.join(uploadDir, filename), bytes);
    const imageUrl = `/uploads/${filename}`;
    db.prepare('UPDATE prize_items SET imageUrl = ?, updatedAtEpochMs = ? WHERE id = ?').run(imageUrl, now(), id);
    const after = getRow('prize_items', id);
    recordAudit('prize_items', id, 'box_image_upload', before, after, user.id);
    return send(res, 200, getPrizeForUser(user.id, id));
  }

  if (method === 'POST' && segments[0] === 'prizes' && segments[2] === 'logs') {
    const prizeId = Number(segments[1]);
    if (!getRow('prize_items', prizeId)) return sendError(res, 404, 'Prize not found');
    const body = await readJson(req);
    const result = db.prepare(`
      INSERT INTO user_acquisition_logs (userId, prizeId, method, place, costYen, memo, createdAtEpochMs)
      VALUES (?, ?, ?, ?, ?, ?, ?)
    `).run(user.id, prizeId, blank(body.method), blank(body.place), body.costYen || null, blank(body.memo), now());
    const after = getRow('user_acquisition_logs', result.lastInsertRowid);
    recordAudit('user_acquisition_logs', result.lastInsertRowid, 'insert', null, after, user.id);
    return send(res, 201, after);
  }

  if (method === 'DELETE' && segments[0] === 'prizes' && segments.length === 2) {
    const id = Number(segments[1]);
    if (!getRow('prize_items', id)) return sendError(res, 404, 'Prize not found');
    const before = getUserState(user.id, id);
    const updatedAt = now();
    db.prepare(`
      INSERT INTO user_prize_states (userId, prizeId, status, memo, acquiredAtEpochMs, createdAtEpochMs, updatedAtEpochMs)
      VALUES (?, ?, 'hidden', NULL, NULL, ?, ?)
      ON CONFLICT(userId, prizeId) DO UPDATE SET
        status = 'hidden',
        updatedAtEpochMs = excluded.updatedAtEpochMs
    `).run(user.id, id, updatedAt, updatedAt);
    const after = getUserState(user.id, id);
    recordAudit('user_prize_states', id, 'hide', before, after, user.id);
    return send(res, 204, {});
  }

  if (method === 'GET' && segments[0] === 'stores') {
    const stores = db.prepare('SELECT * FROM prize_stores ORDER BY isRegistered DESC, area, name').all()
      .map(store => ({ ...store, isRegistered: toBool(store.isRegistered) }));
    return send(res, 200, stores);
  }

  if (method === 'PATCH' && segments[0] === 'stores' && segments[2] === 'registration') {
    const id = Number(segments[1]);
    const body = await readJson(req);
    const before = getRow('prize_stores', id);
    if (!before) return sendError(res, 404, 'Store not found');
    db.prepare('UPDATE prize_stores SET isRegistered = ?, updatedAtEpochMs = ? WHERE id = ?').run(body.isRegistered ? 1 : 0, now(), id);
    const after = getRow('prize_stores', id);
    recordAudit('prize_stores', id, 'registration_update', before, after, user.id);
    if (body.isRegistered) syncAppearances();
    return send(res, 200, { ...after, isRegistered: toBool(after.isRegistered) });
  }

  if (method === 'PATCH' && segments[0] === 'appearances' && segments.length === 2) {
    const id = Number(segments[1]);
    const body = await readJson(req);
    const before = getRow('prize_store_appearances', id);
    if (!before) return sendError(res, 404, 'Appearance not found');
    const dateMs = body.appearanceDateEpochMs == null ? null : Number(body.appearanceDateEpochMs);
    db.prepare('UPDATE prize_store_appearances SET appearanceText = ?, appearanceDateEpochMs = ?, memo = ?, updatedAtEpochMs = ? WHERE id = ?')
      .run(String(body.appearanceText || '').trim(), dateMs, blank(body.memo), now(), id);
    const after = getRow('prize_store_appearances', id);
    recordAudit('prize_store_appearances', id, 'manual_update', before, after, user.id);
    return send(res, 200, after);
  }

  if (method === 'GET' && segments[0] === 'members' && segments[1] === 'prizes') {
    if (!isAdmin(user)) return sendError(res, 403, 'Admin only');
    const users = db.prepare('SELECT id, username FROM users ORDER BY username').all();
    const rows = db.prepare(`
      SELECT s.userId, s.status, p.id AS prizeId, p.title, p.characterName, p.seriesName, p.imageUrl, s.updatedAtEpochMs
      FROM user_prize_states s
      JOIN prize_items p ON p.id = s.prizeId
      WHERE s.status IN ('owned', 'reserved', 'skipped')
      ORDER BY s.updatedAtEpochMs DESC
    `).all();
    const byUser = new Map(users.map((member) => [
      member.id,
      {
        id: member.id,
        username: member.username,
        counts: { owned: 0, reserved: 0, skipped: 0 },
        items: []
      }
    ]));
    for (const row of rows) {
      const member = byUser.get(row.userId);
      if (!member) continue;
      member.counts[row.status] += 1;
      if (member.items.length < 20) {
        member.items.push({
          prizeId: row.prizeId,
          title: row.title,
          characterName: row.characterName,
          seriesName: row.seriesName,
          imageUrl: row.imageUrl,
          status: row.status,
          updatedAtEpochMs: row.updatedAtEpochMs
        });
      }
    }
    return send(res, 200, [...byUser.values()]);
  }

  if (method === 'GET' && segments[0] === 'audit-logs') {
    if (!isAdmin(user)) return sendError(res, 403, 'Admin only');
    const limit = Math.min(Number(url.searchParams.get('limit') || 100), 500);
    return send(res, 200, db.prepare(`
      SELECT a.*, u.username
      FROM audit_logs a
      LEFT JOIN users u ON u.id = a.userId
      ORDER BY a.createdAtEpochMs DESC
      LIMIT ?
    `).all(limit));
  }

  if (method === 'POST' && segments[0] === 'sync') {
    seed();
    return send(res, 200, { ok: true });
  }

  if (method === 'GET' && segments[0] === 'admin' && segments[1] === 'status') {
    if (!isAdmin(user)) return sendError(res, 403, 'Admin only');
    return send(res, 200, {
      running: true,
      port,
      dbPath,
      pid: process.pid
    });
  }

  if (method === 'POST' && segments[0] === 'admin' && segments[1] === 'shutdown') {
    if (!isAdmin(user)) return sendError(res, 403, 'Admin only');
    send(res, 200, { ok: true, message: 'Server is stopping' });
    setTimeout(() => {
      try {
        db.close();
      } catch (_) {
        // Ignore close errors during shutdown.
      }
      server.close(() => process.exit(0));
    }, 100);
    return;
  }

  sendError(res, 404, 'API not found');
}

function blank(value) {
  if (typeof value !== 'string') return null;
  const trimmed = value.trim();
  return trimmed ? trimmed : null;
}

function htmlDecode(value) {
  return value
    .replace(/&amp;/g, '&')
    .replace(/&quot;/g, '"')
    .replace(/&#39;/g, "'")
    .replace(/&lt;/g, '<')
    .replace(/&gt;/g, '>')
    .replace(/<[^>]+>/g, '')
    .replace(/\s+/g, ' ')
    .trim();
}

function isPrizeCandidate(candidate) {
  const text = `${candidate.title} ${candidate.snippet || ''} ${candidate.sourceUrl || ''}`.toLowerCase();
  return [
    'プライズ',
    'prize',
    '景品',
    'クレーン',
    'ufoキャッチャー',
    'taito-prize',
    'charahiroba',
    'segaplaza',
    'sega.jp/prize',
    'bsp-prize',
  ].some((term) => text.includes(term.toLowerCase()));
}

function resolveMaybeUrl(value, baseUrl) {
  if (!value || value.startsWith('data:')) return null;
  try {
    return new URL(htmlDecode(value), baseUrl).href;
  } catch (_) {
    return null;
  }
}

async function findPageImage(sourceUrl) {
  if (!sourceUrl) return null;
  const controller = new AbortController();
  const timeout = setTimeout(() => controller.abort(), 4000);
  try {
    const response = await fetch(sourceUrl, {
      signal: controller.signal,
      headers: {
        'user-agent': 'FigureList/1.0 prize image lookup',
        accept: 'text/html,*/*',
      },
    });
    const html = await response.text();
    const meta = html.match(/<meta[^>]+(?:property|name)=["'](?:og:image|twitter:image)["'][^>]+content=["']([^"']+)["'][^>]*>/i)
      || html.match(/<meta[^>]+content=["']([^"']+)["'][^>]+(?:property|name)=["'](?:og:image|twitter:image)["'][^>]*>/i);
    const image = resolveMaybeUrl(meta?.[1], sourceUrl);
    if (image) return image;
    const img = html.match(/<img[^>]+(?:src|data-src)=["']([^"']+)["'][^>]*>/i);
    return resolveMaybeUrl(img?.[1], sourceUrl);
  } catch (_) {
    return null;
  } finally {
    clearTimeout(timeout);
  }
}

async function searchPrizeCandidates(trimmed) {
  const searchUrl = `https://duckduckgo.com/html/?q=${encodeURIComponent(`${trimmed} プライズ フィギュア`)}`;
  try {
    const response = await fetch(searchUrl, {
      headers: {
        'user-agent': 'FigureList/1.0 prize search',
        accept: 'text/html,*/*',
      },
    });
    const html = await response.text();
    const candidates = [];
    const resultPattern = /<a[^>]+class="result__a"[^>]+href="([^"]+)"[^>]*>([\s\S]*?)<\/a>[\s\S]*?<a[^>]+class="result__snippet"[^>]*>([\s\S]*?)<\/a>/g;
    for (const match of html.matchAll(resultPattern)) {
      const url = new URL(htmlDecode(match[1]), searchUrl);
      const redirect = url.searchParams.get('uddg');
      const candidate = {
        title: htmlDecode(match[2]),
        sourceUrl: redirect ? decodeURIComponent(redirect) : url.href,
        snippet: htmlDecode(match[3]),
      };
      if (!isPrizeCandidate(candidate)) continue;
      candidates.push(candidate);
      if (candidates.length >= 8) break;
    }
    if (candidates.length > 0) {
      return await Promise.all(candidates.map(async (candidate) => ({
        ...candidate,
        imageUrl: await findPageImage(candidate.sourceUrl),
      })));
    }
  } catch (_) {
    // Fall through to a manual candidate.
  }
  return [
    {
      title: trimmed,
      sourceUrl: searchUrl,
      snippet: 'プライズ候補を取得できませんでした。手動追加用の候補です。',
      imageUrl: null,
    },
  ];
}

async function searchFigureCandidates(query) {
  const trimmed = blank(query);
  if (!trimmed) return [];
  return searchPrizeCandidates(trimmed);
}

function serveStatic(res, pathname) {
  const relative = pathname === '/' ? 'index.html' : pathname.slice(1);
  const filePath = path.normalize(path.join(publicDir, relative));
  if (!filePath.startsWith(publicDir)) {
    res.writeHead(403);
    return res.end('Forbidden');
  }
  if (!fs.existsSync(filePath) || fs.statSync(filePath).isDirectory()) {
    res.writeHead(404);
    return res.end('Not found');
  }
  const ext = path.extname(filePath);
  const types = {
    '.html': 'text/html; charset=utf-8',
    '.css': 'text/css; charset=utf-8',
    '.js': 'text/javascript; charset=utf-8',
    '.png': 'image/png',
    '.jpg': 'image/jpeg',
    '.jpeg': 'image/jpeg',
    '.webp': 'image/webp',
    '.gif': 'image/gif',
    '.ico': 'image/x-icon'
  };
  res.writeHead(200, { 'content-type': types[ext] || 'application/octet-stream' });
  fs.createReadStream(filePath).pipe(res);
}

migrate();
seed();

const server = http.createServer(async (req, res) => {
  try {
    const url = new URL(req.url || '/', `http://${req.headers.host || 'localhost'}`);
    if (url.pathname.startsWith('/api/')) {
      await handleApi(req, res, url);
    } else {
      serveStatic(res, url.pathname);
    }
  } catch (error) {
    console.error(error);
    sendError(res, 500, error.message || 'Internal server error');
  }
});

server.listen(port, () => {
  console.log(`FigureList web server running at http://localhost:${port}`);
  console.log(`SQLite database: ${dbPath}`);
});
