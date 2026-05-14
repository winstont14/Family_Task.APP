const { DatabaseSync } = require('node:sqlite');
const path = require('path');
const fs = require('fs');

const dbPath = process.env.DB_PATH || './data/todo_app.db';
const dir = path.dirname(dbPath);
if (!fs.existsSync(dir)) fs.mkdirSync(dir, { recursive: true });

const db = new DatabaseSync(dbPath);

db.exec('PRAGMA journal_mode = WAL');
db.exec('PRAGMA foreign_keys = ON');

db.exec(`
  CREATE TABLE IF NOT EXISTS family (
    id      INTEGER PRIMARY KEY CHECK (id = 1),
    name    TEXT NOT NULL DEFAULT 'My Family',
    created_at TEXT NOT NULL,
    updated_at TEXT NOT NULL
  );

  CREATE TABLE IF NOT EXISTS members (
    id         TEXT PRIMARY KEY,
    name       TEXT NOT NULL,
    role       TEXT NOT NULL DEFAULT 'child',
    pin        TEXT,
    created_at TEXT NOT NULL,
    updated_at TEXT NOT NULL
  );

  CREATE TABLE IF NOT EXISTS todos (
    id            TEXT PRIMARY KEY,
    title         TEXT NOT NULL,
    is_done       INTEGER NOT NULL DEFAULT 0,
    created_at    TEXT NOT NULL,
    due_date      TEXT,
    color_value   INTEGER,
    assigned_to   TEXT REFERENCES members(id) ON DELETE SET NULL,
    reward        TEXT,
    star_rating   INTEGER,
    is_suggestion INTEGER NOT NULL DEFAULT 0,
    completed_at  TEXT,
    updated_at    TEXT NOT NULL
  );
`);

module.exports = db;
