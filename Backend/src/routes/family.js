const express = require('express');
const router = express.Router();
const db = require('../db/database');
const { authenticate, requireRole } = require('../middleware/auth');

// GET /api/family — get family name + member count
router.get('/', authenticate, (_req, res) => {
  const family = db.prepare('SELECT * FROM family WHERE id = 1').get();
  const memberCount = db.prepare('SELECT COUNT(*) as count FROM members').get().count;
  const hasAdmin = !!db.prepare("SELECT id FROM members WHERE role = 'admin' LIMIT 1").get();

  if (!family) {
    return res.json({ name: 'My Family', memberCount, hasAdmin });
  }
  res.json({ name: family.name, memberCount, hasAdmin });
});

// PUT /api/family — update family name (admin only)
router.put('/', authenticate, requireRole('admin'), (req, res) => {
  const { name } = req.body;
  if (!name) return res.status(400).json({ error: 'name required' });

  const now = new Date().toISOString();
  const existing = db.prepare('SELECT id FROM family WHERE id = 1').get();
  if (existing) {
    db.prepare('UPDATE family SET name = ?, updated_at = ? WHERE id = 1').run(name, now);
  } else {
    db.prepare('INSERT INTO family (id, name, created_at, updated_at) VALUES (1, ?, ?, ?)').run(name, now, now);
  }
  res.json({ name });
});

module.exports = router;
