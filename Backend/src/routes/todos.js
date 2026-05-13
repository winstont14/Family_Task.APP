const express = require('express');
const router = express.Router();
const db = require('../db/database');
const { authenticate, requireRole } = require('../middleware/auth');

function rowToTodo(row) {
  if (!row) return null;
  return {
    id: row.id,
    title: row.title,
    isDone: row.is_done === 1,
    createdAt: row.created_at,
    dueDate: row.due_date || null,
    colorValue: row.color_value || null,
    assignedTo: row.assigned_to || null,
    reward: row.reward || null,
    starRating: row.star_rating || null,
    isSuggestion: row.is_suggestion === 1,
    completedAt: row.completed_at || null,
    updatedAt: row.updated_at,
  };
}

// GET /api/todos
// - admin/parent: all todos
// - child: only todos assigned to them (or suggestions they created)
router.get('/', authenticate, (req, res) => {
  let rows;
  if (req.user.role === 'child') {
    rows = db.prepare(`
      SELECT * FROM todos
      WHERE assigned_to = ? OR (is_suggestion = 1 AND assigned_to = ?)
      ORDER BY created_at DESC
    `).all(req.user.id, req.user.id);
  } else {
    rows = db.prepare('SELECT * FROM todos ORDER BY created_at DESC').all();
  }
  res.json(rows.map(rowToTodo));
});

// GET /api/todos/:id
router.get('/:id', authenticate, (req, res) => {
  const row = db.prepare('SELECT * FROM todos WHERE id = ?').get(req.params.id);
  if (!row) return res.status(404).json({ error: 'Todo not found' });

  if (req.user.role === 'child' && row.assigned_to !== req.user.id) {
    return res.status(403).json({ error: 'Access denied' });
  }
  res.json(rowToTodo(row));
});

// POST /api/todos — create (parent/admin) or suggest (child)
router.post('/', authenticate, (req, res) => {
  const { title, dueDate, colorValue, assignedTo, reward, starRating } = req.body;
  if (!title) return res.status(400).json({ error: 'title required' });

  const now = new Date().toISOString();
  const id = Date.now().toString();
  // Children can only create suggestions assigned to themselves
  const isSuggestion = req.user.role === 'child' ? 1 : 0;
  const effectiveAssignedTo = req.user.role === 'child' ? req.user.id : (assignedTo || null);

  db.prepare(`
    INSERT INTO todos
      (id, title, is_done, created_at, due_date, color_value, assigned_to,
       reward, star_rating, is_suggestion, completed_at, updated_at)
    VALUES (?, ?, 0, ?, ?, ?, ?, ?, ?, ?, NULL, ?)
  `).run(id, title, now, dueDate || null, colorValue || null, effectiveAssignedTo,
         reward || null, starRating || null, isSuggestion, now);

  const row = db.prepare('SELECT * FROM todos WHERE id = ?').get(id);
  res.status(201).json(rowToTodo(row));
});

// PUT /api/todos/:id — update todo
// - child: can only toggle isDone on their own tasks
// - parent/admin: full edit
router.put('/:id', authenticate, (req, res) => {
  const row = db.prepare('SELECT * FROM todos WHERE id = ?').get(req.params.id);
  if (!row) return res.status(404).json({ error: 'Todo not found' });

  if (req.user.role === 'child') {
    if (row.assigned_to !== req.user.id) {
      return res.status(403).json({ error: 'Access denied' });
    }
    // Child can only toggle completion
    const isDone = req.body.isDone ?? (row.is_done === 1);
    const completedAt = isDone ? (row.completed_at || new Date().toISOString()) : null;
    const now = new Date().toISOString();
    db.prepare(`
      UPDATE todos SET is_done = ?, completed_at = ?, updated_at = ? WHERE id = ?
    `).run(isDone ? 1 : 0, completedAt, now, req.params.id);
    return res.json(rowToTodo(db.prepare('SELECT * FROM todos WHERE id = ?').get(req.params.id)));
  }

  // parent / admin: full edit
  const { title, isDone, dueDate, colorValue, assignedTo, reward, starRating, isSuggestion } = req.body;
  const now = new Date().toISOString();
  const newDone = isDone ?? (row.is_done === 1);
  const completedAt = newDone
    ? (row.completed_at || now)
    : null;

  db.prepare(`
    UPDATE todos SET
      title         = ?,
      is_done       = ?,
      due_date      = ?,
      color_value   = ?,
      assigned_to   = ?,
      reward        = ?,
      star_rating   = ?,
      is_suggestion = ?,
      completed_at  = ?,
      updated_at    = ?
    WHERE id = ?
  `).run(
    title ?? row.title,
    newDone ? 1 : 0,
    dueDate !== undefined ? dueDate : row.due_date,
    colorValue !== undefined ? colorValue : row.color_value,
    assignedTo !== undefined ? assignedTo : row.assigned_to,
    reward !== undefined ? reward : row.reward,
    starRating !== undefined ? starRating : row.star_rating,
    isSuggestion !== undefined ? (isSuggestion ? 1 : 0) : row.is_suggestion,
    completedAt,
    now,
    req.params.id
  );

  res.json(rowToTodo(db.prepare('SELECT * FROM todos WHERE id = ?').get(req.params.id)));
});

// DELETE /api/todos/:id (parent/admin only)
router.delete('/:id', authenticate, requireRole('admin', 'parent'), (req, res) => {
  const result = db.prepare('DELETE FROM todos WHERE id = ?').run(req.params.id);
  if (result.changes === 0) return res.status(404).json({ error: 'Todo not found' });
  res.json({ message: 'Todo deleted' });
});

module.exports = router;
