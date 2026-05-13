# Playwright E2E Tests

End-to-end tests for the Family ToDoApp Flutter web build.

## Prerequisites

- Node.js 18+
- Flutter SDK (for building the web target)

## Setup

```bash
# 1. Build Flutter web with the HTML renderer (required for DOM access)
cd ..   # project root
flutter build web --web-renderer html

# 2. Serve the build locally
cd build/web
python3 -m http.server 8080
# or: npx serve -l 8080 .

# 3. Install Playwright and its browsers
cd ../../playwright_tests
npm install
npx playwright install --with-deps chromium
```

## Run Tests

```bash
# All tests (headless)
npm test

# Headed mode (watch the browser)
npm run test:headed

# Interactive UI mode
npm run test:ui

# Debug a single file
npm run test:debug -- tests/01_onboarding.spec.ts

# View HTML report after a run
npm run report
```

## Test Files

| File | TCs covered | What it tests |
|------|-------------|---------------|
| `tests/01_onboarding.spec.ts` | TC-001 – TC-012 | 4-step onboarding wizard, validation, complete setup |
| `tests/02_home_navigation.spec.ts` | TC-013 – TC-016 | Bottom-nav tabs, empty states, FAB visibility |
| `tests/03_add_task.spec.ts` | TC-017 – TC-027 | Add Task sheet: templates, title, date, stars, reward, colour |
| `tests/04_task_management.spec.ts` | TC-028 – TC-035 | Task list, filters, toggle complete, edit, dashboard sync |

## Helpers

`helpers/app.ts` contains shared utilities:

- `waitForFlutter(page)` — waits for Flutter animations to settle
- `waitForAppReady(page)` — waits for `flt-glass-pane` mount
- `completeOnboarding(page, opts)` — runs through all 4 onboarding steps
- `openAddTaskSheet(page)` — taps the Add Task FAB
- `addTask(page, title)` — opens sheet, fills title, saves
- `goToTab(page, tab)` — clicks a bottom-nav tab

## Flutter Web Selector Notes

Flutter with `--web-renderer html` exposes an accessibility tree via
`flt-semantics` elements with ARIA attributes. Playwright queries use:

- `page.getByRole('button', { name: '…' })` — for buttons
- `page.getByText('…')` — for text nodes in the semantic tree
- `page.locator('input')` — for native text inputs (Flutter renders real
  `<input>` elements inside `flt-text-editing-host` shadow DOM)
- `page.locator('flt-semantics[role="checkbox"]')` — for task checkboxes

If selectors break, inspect the semantic tree in DevTools:
  DevTools → Accessibility panel → enable "Full-page accessibility tree".
