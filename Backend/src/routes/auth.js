const express = require('express');
const bcrypt = require('bcryptjs');
const router = express.Router();
const db = require('../db/database');
const { sign } = require('../utils/jwt');
const { authenticate } = require('../middleware/auth');

// POST /api/auth/setup — first-run: create admin + family name
router.post('/setup', (req, res) => {
  const existing = db.prepare('SELECT id FROM members WHERE role = ?').get('admin');
  if (existing) return res.status(409).json({ error: 'Admin already exists' });

  const { familyName, adminName, pin } = req.body;
  if (!adminName) return res.status(400).json({ error: 'adminName required' });

  const now = new Date().toISOString();
  const id = Date.now().toString();

  const hashedPin = pin ? bcrypt.hashSync(String(pin), 10) : null;

  db.prepare(`
    INSERT INTO members (id, name, role, pin, created_at, updated_at)
    VALUES (?, ?, 'admin', ?, ?, ?)
  `).run(id, adminName, hashedPin, now, now);

  const familyExists = db.prepare('SELECT id FROM family WHERE id = 1').get();
  if (!familyExists) {
    db.prepare(`
      INSERT INTO family (id, name, created_at, updated_at) VALUES (1, ?, ?, ?)
    `).run(familyName || 'My Family', now, now);
  } else if (familyName) {
    db.prepare('UPDATE family SET name = ?, updated_at = ? WHERE id = 1').run(familyName, now);
  }

  const token = sign({ id, name: adminName, role: 'admin' });
  res.status(201).json({ token, member: { id, name: adminName, role: 'admin' } });
});

// POST /api/auth/login — member login with PIN
router.post('/login', (req, res) => {
  const { memberId, pin } = req.body;
  if (!memberId) return res.status(400).json({ error: 'memberId required' });

  const member = db.prepare('SELECT * FROM members WHERE id = ?').get(memberId);
  if (!member) return res.status(404).json({ error: 'Member not found' });

  if (member.pin) {
    if (!pin) return res.status(401).json({ error: 'PIN required' });
    if (!bcrypt.compareSync(String(pin), member.pin)) {
      return res.status(401).json({ error: 'Incorrect PIN' });
    }
  }

  const token = sign({ id: member.id, name: member.name, role: member.role });
  res.json({ token, member: { id: member.id, name: member.name, role: member.role } });
});

// POST /api/auth/logout — client discards token; server-side is stateless
router.post('/logout', authenticate, (_req, res) => {
  res.json({ message: 'Logged out' });
});

// GET /api/auth/me — return current session info
router.get('/me', authenticate, (req, res) => {
  const member = db.prepare('SELECT id, name, role FROM members WHERE id = ?').get(req.user.id);
  if (!member) return res.status(404).json({ error: 'Member not found' });
  res.json(member);
});

module.exports = router;
