# API Path Design — Family Todo App

Designed to replace the current Hive local storage with a RESTful backend.
All endpoints are prefixed with `/api/v1`.

---

## Base URL

```
https://api.familytodo.app/api/v1
```

---

## Authentication

JWT-based. Every protected route requires:

```
Authorization: Bearer <access_token>
```

Tokens expire in 1 hour. Refresh via `/auth/refresh`.

---

## 1. Auth

### POST `/auth/login`
Log in with family member credentials (PIN-based).

**Request**
```json
{
  "familyId": "string",
  "memberId": "string",
  "pin": "string"          // optional — null if member has no PIN
}
```

**Response `200`**
```json
{
  "accessToken": "string",
  "refreshToken": "string",
  "member": {
    "id": "string",
    "name": "string",
    "role": "admin | parent | child",
    "emoji": "string | null"
  }
}
```

**Errors**
| Code | Reason |
|------|--------|
| 401  | Wrong PIN |
| 404  | Member not found |

---

### POST `/auth/refresh`
Exchange a refresh token for a new access token.

**Request**
```json
{
  "refreshToken": "string"
}
```

**Response `200`**
```json
{
  "accessToken": "string"
}
```

---

### POST `/auth/logout`
Invalidate the current session.

**Response `204`** — no body.

---

## 2. Family

### POST `/families`
Create a new family (first-time onboarding).

**Request**
```json
{
  "name": "string",
  "icon": "string | null"
}
```

**Response `201`**
```json
{
  "id": "string",
  "name": "string",
  "icon": "string | null",
  "createdAt": "ISO 8601"
}
```

---

### GET `/families/me`
Get the current family's profile.

**Response `200`**
```json
{
  "id": "string",
  "name": "string",
  "icon": "string | null",
  "weeklyGoal": 10,
  "createdAt": "ISO 8601"
}
```

---

### PATCH `/families/me`
Update family settings (admin only).

**Request** _(all fields optional)_
```json
{
  "name": "string",
  "icon": "string | null",
  "weeklyGoal": 10
}
```

**Response `200`** — returns updated family object.

---

## 3. Family Members

### GET `/members`
List all members in the family.

**Response `200`**
```json
[
  {
    "id": "string",
    "name": "string",
    "role": "admin | parent | child",
    "emoji": "string | null",
    "hasPin": true
  }
]
```

---

### POST `/members`
Add a new family member (admin/parent only).

**Request**
```json
{
  "name": "string",
  "role": "parent | child",
  "emoji": "string | null",
  "pin": "string | null"
}
```

**Response `201`**
```json
{
  "id": "string",
  "name": "string",
  "role": "string",
  "emoji": "string | null",
  "hasPin": true
}
```

---

### GET `/members/:memberId`
Get a single member's profile.

**Response `200`**
```json
{
  "id": "string",
  "name": "string",
  "role": "string",
  "emoji": "string | null",
  "hasPin": true,
  "xp": 120,
  "level": 2,
  "streakDays": 3
}
```

---

### PATCH `/members/:memberId`
Update a member (admin/parent only, or self for non-sensitive fields).

**Request** _(all fields optional)_
```json
{
  "name": "string",
  "emoji": "string | null",
  "pin": "string | null",
  "role": "parent | child"
}
```

**Response `200`** — returns updated member object.

---

### DELETE `/members/:memberId`
Remove a member (admin only). Unassigns their tasks.

**Response `204`** — no body.

---

## 4. Todos

### GET `/todos`
List todos. Supports filtering and pagination.

**Query params**

| Param | Type | Description |
|-------|------|-------------|
| `assignedTo` | `string` | Filter by member ID |
| `status` | `active \| completed \| suggested` | Filter by status |
| `dueBefore` | `ISO 8601 date` | Filter by due date |
| `dueAfter` | `ISO 8601 date` | Filter by due date |
| `page` | `int` | Page number (default 1) |
| `limit` | `int` | Items per page (default 50) |

**Response `200`**
```json
{
  "data": [
    {
      "id": "string",
      "title": "string",
      "isDone": false,
      "isSuggestion": false,
      "createdAt": "ISO 8601",
      "dueDate": "ISO 8601 | null",
      "completedAt": "ISO 8601 | null",
      "colorValue": 4294967295,
      "assignedTo": "memberId | null",
      "reward": "string | null",
      "starRating": 3
    }
  ],
  "total": 42,
  "page": 1,
  "limit": 50
}
```

---

### POST `/todos`
Create a new todo (admin/parent only; children use `/todos/suggest`).

**Request**
```json
{
  "title": "string",
  "dueDate": "ISO 8601 | null",
  "colorValue": 4294967295,
  "assignedTo": "memberId | null",
  "reward": "string | null",
  "starRating": 3
}
```

**Response `201`** — returns the created todo object.

---

### GET `/todos/:todoId`
Get a single todo.

**Response `200`** — returns the todo object.

---

### PATCH `/todos/:todoId`
Update a todo (admin/parent only).

**Request** _(all fields optional)_
```json
{
  "title": "string",
  "dueDate": "ISO 8601 | null",
  "colorValue": 4294967295,
  "assignedTo": "memberId | null",
  "reward": "string | null",
  "starRating": 3
}
```

**Response `200`** — returns updated todo object.

---

### DELETE `/todos/:todoId`
Delete a todo (admin/parent only).

**Response `204`** — no body.

---

### PATCH `/todos/:todoId/toggle`
Toggle `isDone` for a todo. Sets or clears `completedAt`.

**Response `200`**
```json
{
  "id": "string",
  "isDone": true,
  "completedAt": "ISO 8601 | null"
}
```

---

### POST `/todos/suggest`
Child submits a task suggestion (sets `isSuggestion = true`).

**Request**
```json
{
  "title": "string",
  "dueDate": "ISO 8601 | null"
}
```

**Response `201`** — returns the created suggestion todo object.

---

### PATCH `/todos/:todoId/approve`
Parent/admin approves a child's suggestion (clears `isSuggestion`).

**Response `200`** — returns updated todo object.

---

## 5. Activity Log

### GET `/activity`
Retrieve the audit log for the family (admin/parent only).

**Query params**

| Param | Type | Description |
|-------|------|-------------|
| `userId` | `string` | Filter by member ID |
| `event` | `string` | e.g. `login_success`, `logout`, `login_failed` |
| `from` | `ISO 8601 date` | Start of range |
| `to` | `ISO 8601 date` | End of range |
| `page` | `int` | Default 1 |
| `limit` | `int` | Default 100 |

**Response `200`**
```json
{
  "data": [
    {
      "id": "string",
      "event": "login_success",
      "userId": "string | null",
      "username": "string | null",
      "success": true,
      "source": "login_screen",
      "reason": "string | null",
      "createdAt": "ISO 8601"
    }
  ],
  "total": 120,
  "page": 1,
  "limit": 100
}
```

---

## 6. Stats

### GET `/stats/members/:memberId`
XP, level, streak, and weekly completion for a member.

**Response `200`**
```json
{
  "memberId": "string",
  "xp": 120,
  "level": 2,
  "xpInCurrentLevel": 20,
  "xpToNextLevel": 100,
  "streakDays": 3,
  "completedThisWeek": 5,
  "weeklyGoal": 10
}
```

---

### GET `/stats/family`
Aggregate stats for the whole family.

**Response `200`**
```json
{
  "completedThisWeek": 18,
  "weeklyGoal": 10,
  "totalTodos": 42,
  "memberStats": [
    {
      "memberId": "string",
      "name": "string",
      "xp": 120,
      "level": 2,
      "completedThisWeek": 5
    }
  ]
}
```

---

## 7. Claude AI Integration

### POST `/ai/parse-task`
Send raw text → Claude parses and returns structured todo fields.

**Request**
```json
{
  "text": "Buy groceries tomorrow at 5pm"
}
```

**Response `200`**
```json
{
  "title": "Buy groceries",
  "dueDate": "2026-05-14T17:00:00Z"
}
```

---

### POST `/ai/suggest-tasks`
Request 4 task suggestions based on existing todos.

**Request**
```json
{
  "existingTasks": ["Buy groceries", "Clean room"]
}
```

**Response `200`**
```json
{
  "suggestions": [
    "Take out the trash",
    "Do the laundry",
    "Vacuum the living room",
    "Wash the dishes"
  ]
}
```

---

## Error Schema

All errors return this shape:

```json
{
  "error": {
    "code": "UNAUTHORIZED",
    "message": "Human-readable description"
  }
}
```

**Standard codes**

| HTTP | Code | Meaning |
|------|------|---------|
| 400  | `BAD_REQUEST` | Invalid request body / params |
| 401  | `UNAUTHORIZED` | Missing or expired token |
| 403  | `FORBIDDEN` | Insufficient role permissions |
| 404  | `NOT_FOUND` | Resource does not exist |
| 409  | `CONFLICT` | Duplicate resource |
| 422  | `VALIDATION_ERROR` | Field-level validation failure |
| 500  | `INTERNAL_ERROR` | Unexpected server error |

---

## Role Permissions Matrix

| Action | admin | parent | child |
|--------|:-----:|:------:|:-----:|
| Create / edit / delete todo | ✓ | ✓ | — |
| Toggle todo (own) | ✓ | ✓ | ✓ |
| Submit suggestion | ✓ | ✓ | ✓ |
| Approve suggestion | ✓ | ✓ | — |
| Add / edit / delete member | ✓ | — | — |
| Update family settings | ✓ | — | — |
| View activity log | ✓ | ✓ | — |
| View own stats | ✓ | ✓ | ✓ |
| View all member stats | ✓ | ✓ | — |

---

## Database Tables (reference)

```
families        id, name, icon, weekly_goal, created_at
members         id, family_id, name, role, emoji, pin_hash, created_at
todos           id, family_id, title, is_done, is_suggestion, created_at,
                due_date, completed_at, color_value, assigned_to (→ members.id),
                reward, star_rating
activity_log    id, family_id, event, user_id (→ members.id), username,
                success, source, reason, created_at
```
