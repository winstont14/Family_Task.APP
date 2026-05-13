const express = require('express');
const bcrypt = require('bcryptjs');
const router = express.Router();
const db = require('../db/database');
const { authenticate, requireRole } = require('../middleware/auth');

// GET /api/members — all members (authenticated)
router.get('/', authenticate, (_req, res) => {
  const members = db.prepare('SELECT id, name, role FROM members ORDER BY created_at').all();
  res.json(members);
});

// GET /api/members/:id
router.get('/:id', authenticate, (req, res) => {
  const member = db.prepare('SELECT id, name, role FROM members WHERE id = ?').get(req.params.id);
  if (!member) return res.status(404).json({ error: 'Member not found' });
  res.json(member);
});

// POST /api/members — create member (admin only)
router.post('/', authenticate, requireRole('admin'), (req, res) => {
  const { name, role = 'child', pin } = req.body;
  if (!name) return res.status(400).json({ error: 'name required' });
  if (!['admin', 'parent', 'child'].includes(role)) {
    return res.status(400).json({ error: 'role must be admin, parent, or child' });
  }

  const now = new Date().toISOString();
  const id = Date.now().toString();
  const hashedPin = pin ? bcrypt.hashSync(String(pin), 10) : null;

  db.prepare(`
    INSERT INTO members (id, name, role, pin, created_at, updated_at)
    VALUES (?, ?, ?, ?, ?, ?)
  `).run(id, name, role, hashedPin, now, now);

  res.status(201).json({ id, name, role });
});

// PUT /api/members/:id — update name, role, or PIN (admin only)
router.put('/:id', authenticate, requireRole('admin'), (req, res) => {
  const member = db.prepare('SELECT * FROM members WHERE id = ?').get(req.params.id);
  if (!member) return res.status(404).json({ error: 'Member not found' });

  const { name, role, pin } = req.body;
  const now = new Date().toISOString();

  const updatedName = name ?? member.name;
  const updatedRole = role ?? member.role;
  const updatedPin = pin !== undefined
    ? (pin ? bcrypt.hashSync(String(pin), 10) : null)
    : member.pin;

  if (updatedRole && !['admin', 'parent', 'child'].includes(updatedRole)) {
    return res.status(400).json({ error: 'role must be admin, parent, or child' });
  }

  db.prepare(`
    UPDATE members SET name = ?, role = ?, pin = ?, updated_at = ? WHERE id = ?
  `).run(updatedName, updatedRole, updatedPin, now, req.params.id);

  res.json({ id: req.params.id, name: updatedName, role: updatedRole });
});

// DELETE /api/members/:id (admin only; cannot delete self)
router.delete('/:id', authenticate, requireRole('admin'), (req, res) => {
  if (req.params.id === req.user.id) {
    return res.status(400).json({ error: 'Cannot delete your own account' });
  }
  const result = db.prepare('DELETE FROM members WHERE id = ?').run(req.params.id);
  if (result.changes === 0) return res.status(404).json({ error: 'Member not found' });
  res.json({ message: 'Member deleted' });
});

module.exports = router;
