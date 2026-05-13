# Test Cases — Family ToDoApp

## Scope
End-to-end test cases for the Flutter web build of the Family ToDo application.
Covers the four main user flows: Onboarding, Home navigation, Add Task, and Task Management.

---

## TC-001 · Onboarding — Initial screen loads

| Field | Value |
|---|---|
| **ID** | TC-001 |
| **Module** | Onboarding |
| **Priority** | High |
| **Type** | Smoke |

**Precondition:** App is freshly loaded with no persisted data.

**Steps:**
1. Open the app at `http://localhost:8080`.

**Expected Result:**
- Progress bar shows 4 steps, first step active.
- Workspace icon placeholder (🏠) is visible.
- Heading "Name your workspace" is visible.
- "Next →" button is visible and enabled.
- "Back" button is **not** visible on page 1.

---

## TC-002 · Onboarding — Family name validation (empty)

| Field | Value |
|---|---|
| **ID** | TC-002 |
| **Module** | Onboarding |
| **Priority** | High |
| **Type** | Negative |

**Precondition:** App on onboarding page 1.

**Steps:**
1. Leave the "Family Name" field empty.
2. Click "Next →".

**Expected Result:**
- App stays on page 1.
- Error message "Please enter a family name" appears below the input.
- Progress bar remains on step 1.

---

## TC-003 · Onboarding — Family name accepted and advance to page 2

| Field | Value |
|---|---|
| **ID** | TC-003 |
| **Module** | Onboarding |
| **Priority** | High |
| **Type** | Positive |

**Precondition:** App on onboarding page 1.

**Steps:**
1. Type `The Smiths` in the Family Name field.
2. Click "Next →".

**Expected Result:**
- App advances to page 2.
- Heading "What's your name?" is visible.
- "Auto Admin" badge is visible.
- "Back" button is now visible.

---

## TC-004 · Onboarding — Admin name validation (empty)

| Field | Value |
|---|---|
| **ID** | TC-004 |
| **Module** | Onboarding |
| **Priority** | High |
| **Type** | Negative |

**Precondition:** App on onboarding page 2.

**Steps:**
1. Leave the "Your Name" field empty.
2. Click "Next →".

**Expected Result:**
- App stays on page 2.
- Error "Please enter your name" appears under the name field.

---

## TC-005 · Onboarding — PIN validation (wrong length)

| Field | Value |
|---|---|
| **ID** | TC-005 |
| **Module** | Onboarding |
| **Priority** | Medium |
| **Type** | Negative |

**Precondition:** App on onboarding page 2, name field filled.

**Steps:**
1. Enter `Alex` in the name field.
2. Enter `123` (3 digits) in the PIN field.
3. Click "Next →".

**Expected Result:**
- App stays on page 2.
- Error "PIN must be exactly 4 digits" appears under the PIN field.

---

## TC-006 · Onboarding — Admin name and PIN accepted, advance to page 3

| Field | Value |
|---|---|
| **ID** | TC-006 |
| **Module** | Onboarding |
| **Priority** | High |
| **Type** | Positive |

**Precondition:** App on onboarding page 2.

**Steps:**
1. Enter `Alex` in the name field.
2. Enter `1234` in the PIN field.
3. Click "Next →".

**Expected Result:**
- App advances to page 3 (family icon picker).
- Heading "Pick a family icon" is visible.
- A 6-column grid of emoji icons is displayed.
- Default icon 🏠 is highlighted/selected.

---

## TC-007 · Onboarding — Select family icon

| Field | Value |
|---|---|
| **ID** | TC-007 |
| **Module** | Onboarding |
| **Priority** | Medium |
| **Type** | Positive |

**Precondition:** App on onboarding page 3.

**Steps:**
1. Click the 🚀 icon in the grid.

**Expected Result:**
- 🚀 becomes highlighted with a blue border.
- Large preview at the top updates to show 🚀.
- Previous selection (🏠) loses its highlight.

---

## TC-008 · Onboarding — Advance to page 4 (Add family)

| Field | Value |
|---|---|
| **ID** | TC-008 |
| **Module** | Onboarding |
| **Priority** | High |
| **Type** | Positive |

**Precondition:** App on onboarding page 3.

**Steps:**
1. Click "Next →".

**Expected Result:**
- App advances to page 4.
- Heading "Add your family 👨‍👩‍👧‍👦" is visible.
- Admin chip (with 👑 badge and the name entered in step 2) is already shown.
- "Add Member" form is visible.
- "Go to Board →" button is visible.

---

## TC-009 · Onboarding — Add a family member

| Field | Value |
|---|---|
| **ID** | TC-009 |
| **Module** | Onboarding |
| **Priority** | High |
| **Type** | Positive |

**Precondition:** App on onboarding page 4.

**Steps:**
1. Enter `Emma` in the member name field.
2. Click the "🌟 Kid" role toggle.
3. Click "Add Member".

**Expected Result:**
- A new chip labeled "Emma" with 🌟 appears in the members list.
- Name field is cleared.
- Role resets to Kid.

---

## TC-010 · Onboarding — Remove an added family member

| Field | Value |
|---|---|
| **ID** | TC-010 |
| **Module** | Onboarding |
| **Priority** | Medium |
| **Type** | Positive |

**Precondition:** App on onboarding page 4 with "Emma" already added (TC-009).

**Steps:**
1. Click the ✕ (close) icon on Emma's chip.

**Expected Result:**
- Emma's chip is removed from the list.
- Admin chip remains unchanged.

---

## TC-011 · Onboarding — Member name validation (empty)

| Field | Value |
|---|---|
| **ID** | TC-011 |
| **Module** | Onboarding |
| **Priority** | Medium |
| **Type** | Negative |

**Precondition:** App on onboarding page 4.

**Steps:**
1. Leave the member name field empty.
2. Click "Add Member".

**Expected Result:**
- Error "Enter a name" appears under the name field.
- No new chip is added.

---

## TC-012 · Onboarding — Complete full setup ("Go to Board")

| Field | Value |
|---|---|
| **ID** | TC-012 |
| **Module** | Onboarding |
| **Priority** | Critical |
| **Type** | End-to-End |

**Precondition:** App on onboarding page 4.

**Steps:**
1. Click "Go to Board →".

**Expected Result:**
- App navigates to the Home screen (Dashboard tab).
- Bottom navigation bar shows "Dashboard", "List", and "Family Feed" items.
- "Add Task" FAB is visible.

---

## TC-013 · Home — Dashboard tab is default

| Field | Value |
|---|---|
| **ID** | TC-013 |
| **Module** | Home |
| **Priority** | High |
| **Type** | Smoke |

**Precondition:** Onboarding completed, home screen visible.

**Steps:**
1. Observe the active tab in the bottom navigation bar.

**Expected Result:**
- "Dashboard" tab is selected (highlighted in primary blue).
- Dashboard content (progress card, "Active Tasks" section) is displayed.

---

## TC-014 · Home — Navigate to List tab

| Field | Value |
|---|---|
| **ID** | TC-014 |
| **Module** | Home |
| **Priority** | High |
| **Type** | Positive |

**Precondition:** Home screen on Dashboard tab.

**Steps:**
1. Click "List" in the bottom navigation bar.

**Expected Result:**
- "List" tab becomes active.
- Task list header (with All / Today / Pending filter chips) is visible.
- Empty state "No active tasks" message is shown (no tasks yet).

---

## TC-015 · Home — Navigate to Family Feed tab

| Field | Value |
|---|---|
| **ID** | TC-015 |
| **Module** | Home |
| **Priority** | Medium |
| **Type** | Positive |

**Precondition:** Home screen visible. User is admin (not a child).

**Steps:**
1. Click "Family Feed" in the bottom navigation bar.

**Expected Result:**
- "Family Feed" tab becomes active.
- Feed content area is displayed.

---

## TC-016 · Home — Logout

| Field | Value |
|---|---|
| **ID** | TC-016 |
| **Module** | Home |
| **Priority** | High |
| **Type** | Positive |

**Precondition:** Home screen visible.

**Steps:**
1. Tap the user avatar / menu icon in the header.
2. Select "Logout" (or equivalent).

**Expected Result:**
- App returns to the onboarding/login screen.

---

## TC-017 · Add Task — Open bottom sheet

| Field | Value |
|---|---|
| **ID** | TC-017 |
| **Module** | Add Task |
| **Priority** | High |
| **Type** | Smoke |

**Precondition:** Home screen visible, on Dashboard or List tab.

**Steps:**
1. Click the "Add Task" floating action button.

**Expected Result:**
- Bottom sheet slides up.
- Title "New Task" is visible.
- "Quick templates" row is visible with scrollable chips (📚 Homework, 🛏️ Make bed, …).
- Title input field is auto-focused.
- "Add Task" save button is at the bottom.

---

## TC-018 · Add Task — Validate empty title

| Field | Value |
|---|---|
| **ID** | TC-018 |
| **Module** | Add Task |
| **Priority** | High |
| **Type** | Negative |

**Precondition:** Add Task bottom sheet open.

**Steps:**
1. Leave the title input empty.
2. Click "Add Task".

**Expected Result:**
- Bottom sheet stays open.
- No task is added to the list.

---

## TC-019 · Add Task — Use a quick template

| Field | Value |
|---|---|
| **ID** | TC-019 |
| **Module** | Add Task |
| **Priority** | Medium |
| **Type** | Positive |

**Precondition:** Add Task bottom sheet open.

**Steps:**
1. Click the "📚 Homework" template chip.

**Expected Result:**
- Title input is populated with "📚 Homework".

---

## TC-020 · Add Task — Save a basic task

| Field | Value |
|---|---|
| **ID** | TC-020 |
| **Module** | Add Task |
| **Priority** | Critical |
| **Type** | Positive |

**Precondition:** Add Task bottom sheet open.

**Steps:**
1. Type `Buy groceries` in the title field.
2. Click "Add Task".

**Expected Result:**
- Bottom sheet dismisses.
- "Buy groceries" task appears in the task list.

---

## TC-021 · Add Task — Set a due date

| Field | Value |
|---|---|
| **ID** | TC-021 |
| **Module** | Add Task |
| **Priority** | Medium |
| **Type** | Positive |

**Precondition:** Add Task bottom sheet open, title filled.

**Steps:**
1. Click the "Set deadline (optional)" row.
2. Select a date in the date picker (tomorrow).
3. Select a time (e.g. 10:00 AM).

**Expected Result:**
- The deadline row updates to show the selected date and time (e.g. "May 13, 2026  10:00 AM").
- The clear (×) icon appears on the deadline row.

---

## TC-022 · Add Task — Clear due date

| Field | Value |
|---|---|
| **ID** | TC-022 |
| **Module** | Add Task |
| **Priority** | Low |
| **Type** | Positive |

**Precondition:** Due date has been set in the add task sheet.

**Steps:**
1. Click the × icon on the deadline row.

**Expected Result:**
- Deadline row resets to "Set deadline (optional)".

---

## TC-023 · Add Task — Set difficulty stars

| Field | Value |
|---|---|
| **ID** | TC-023 |
| **Module** | Add Task |
| **Priority** | Medium |
| **Type** | Positive |

**Precondition:** Add Task bottom sheet open.

**Steps:**
1. Click the 3rd star in the Difficulty row.

**Expected Result:**
- First 3 stars turn gold (filled).
- Stars 4 and 5 remain empty.

---

## TC-024 · Add Task — Toggle star off (deselect)

| Field | Value |
|---|---|
| **ID** | TC-024 |
| **Module** | Add Task |
| **Priority** | Low |
| **Type** | Positive |

**Precondition:** 3 stars selected in difficulty.

**Steps:**
1. Click the 3rd star again.

**Expected Result:**
- All stars become empty (rating resets to 0).

---

## TC-025 · Add Task — Enter a reward

| Field | Value |
|---|---|
| **ID** | TC-025 |
| **Module** | Add Task |
| **Priority** | Medium |
| **Type** | Positive |

**Precondition:** Add Task bottom sheet open.

**Steps:**
1. Type `30 min screen time` in the Reward field.

**Expected Result:**
- Text is accepted without error.
- Reward field displays the entered value.

---

## TC-026 · Add Task — Select a card colour

| Field | Value |
|---|---|
| **ID** | TC-026 |
| **Module** | Add Task |
| **Priority** | Low |
| **Type** | Positive |

**Precondition:** Add Task bottom sheet open.

**Steps:**
1. Click the sky-blue colour circle in the "Card colour" row.

**Expected Result:**
- The sky-blue circle shows a checkmark (selected state).
- Default (white/none) circle loses selection.

---

## TC-027 · Add Task — Assign to a family member

| Field | Value |
|---|---|
| **ID** | TC-027 |
| **Module** | Add Task |
| **Priority** | High |
| **Type** | Positive |

**Precondition:** Family has at least one member; Add Task sheet open.

**Steps:**
1. Click a member card in the "Assign to" section.

**Expected Result:**
- That member's card shows a coloured border and checkmark.
- "No one" card loses selection.

---

## TC-028 · Task List — Task appears after adding

| Field | Value |
|---|---|
| **ID** | TC-028 |
| **Module** | Task List |
| **Priority** | Critical |
| **Type** | Integration |

**Precondition:** Home screen, List tab active.

**Steps:**
1. Click "Add Task".
2. Enter `Walk the dog`.
3. Click "Add Task".
4. Navigate to List tab if not already there.

**Expected Result:**
- "Walk the dog" task card is visible in the task list.

---

## TC-029 · Task List — Filter by Today

| Field | Value |
|---|---|
| **ID** | TC-029 |
| **Module** | Task List |
| **Priority** | Medium |
| **Type** | Positive |

**Precondition:** At least one task with a today/overdue due date exists; List tab active.

**Steps:**
1. Click the "Today" filter chip in the task list header.

**Expected Result:**
- Only overdue and today-due tasks are shown.
- "Upcoming" section is hidden.
- Completed section is hidden.

---

## TC-030 · Task List — Filter by Pending

| Field | Value |
|---|---|
| **ID** | TC-030 |
| **Module** | Task List |
| **Priority** | Medium |
| **Type** | Positive |

**Precondition:** At least one active task exists; List tab active.

**Steps:**
1. Click the "Pending" filter chip.

**Expected Result:**
- Only active (not completed) tasks are shown.
- Completed section is hidden.

---

## TC-031 · Task List — Toggle task complete

| Field | Value |
|---|---|
| **ID** | TC-031 |
| **Module** | Task List |
| **Priority** | Critical |
| **Type** | Positive |

**Precondition:** At least one active task visible in the list.

**Steps:**
1. Click the checkbox on a task card.

**Expected Result:**
- Task moves out of the active section.
- "Completed" section header appears (or count increments).
- Dashboard progress card updates.

---

## TC-032 · Task List — Completed section expands / collapses

| Field | Value |
|---|---|
| **ID** | TC-032 |
| **Module** | Task List |
| **Priority** | Low |
| **Type** | Positive |

**Precondition:** At least one completed task; All filter selected.

**Steps:**
1. Click the "COMPLETED" section header to expand.
2. Click it again to collapse.

**Expected Result:**
- First click: completed task cards become visible.
- Second click: completed task cards are hidden.

---

## TC-033 · Task — Edit an existing task

| Field | Value |
|---|---|
| **ID** | TC-033 |
| **Module** | Task Management |
| **Priority** | High |
| **Type** | Positive |

**Precondition:** At least one task exists in the list.

**Steps:**
1. Long-press (or click the edit icon on) a task card.
2. Clear the title and type `Updated task name`.
3. Click "Save Changes".

**Expected Result:**
- Bottom sheet dismisses.
- Task card shows "Updated task name".

---

## TC-034 · Task — Delete a task (swipe)

| Field | Value |
|---|---|
| **ID** | TC-034 |
| **Module** | Task Management |
| **Priority** | High |
| **Type** | Positive |

**Precondition:** At least one task exists in the list.

**Steps:**
1. Swipe a task card to the left.

**Expected Result:**
- Task is removed from the list.
- Total task count decreases by one.

---

## TC-035 · Dashboard — Progress card reflects task stats

| Field | Value |
|---|---|
| **ID** | TC-035 |
| **Module** | Dashboard |
| **Priority** | Medium |
| **Type** | Integration |

**Precondition:** Dashboard tab; some tasks added.

**Steps:**
1. Note the "Active" count in the progress card.
2. Complete one task.
3. Return to Dashboard tab.

**Expected Result:**
- Progress bar percentage increases.
- "Done today" counter increments by 1.
- "Active" counter decrements by 1.

---

## Summary Table

| ID | Module | Priority | Type |
|---|---|---|---|
| TC-001 | Onboarding | High | Smoke |
| TC-002 | Onboarding | High | Negative |
| TC-003 | Onboarding | High | Positive |
| TC-004 | Onboarding | High | Negative |
| TC-005 | Onboarding | Medium | Negative |
| TC-006 | Onboarding | High | Positive |
| TC-007 | Onboarding | Medium | Positive |
| TC-008 | Onboarding | High | Positive |
| TC-009 | Onboarding | High | Positive |
| TC-010 | Onboarding | Medium | Positive |
| TC-011 | Onboarding | Medium | Negative |
| TC-012 | Onboarding | Critical | End-to-End |
| TC-013 | Home | High | Smoke |
| TC-014 | Home | High | Positive |
| TC-015 | Home | Medium | Positive |
| TC-016 | Home | High | Positive |
| TC-017 | Add Task | High | Smoke |
| TC-018 | Add Task | High | Negative |
| TC-019 | Add Task | Medium | Positive |
| TC-020 | Add Task | Critical | Positive |
| TC-021 | Add Task | Medium | Positive |
| TC-022 | Add Task | Low | Positive |
| TC-023 | Add Task | Medium | Positive |
| TC-024 | Add Task | Low | Positive |
| TC-025 | Add Task | Medium | Positive |
| TC-026 | Add Task | Low | Positive |
| TC-027 | Add Task | High | Positive |
| TC-028 | Task List | Critical | Integration |
| TC-029 | Task List | Medium | Positive |
| TC-030 | Task List | Medium | Positive |
| TC-031 | Task List | Critical | Positive |
| TC-032 | Task List | Low | Positive |
| TC-033 | Task Mgmt | High | Positive |
| TC-034 | Task Mgmt | High | Positive |
| TC-035 | Dashboard | Medium | Integration |
