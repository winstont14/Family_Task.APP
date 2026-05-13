import { Page } from '@playwright/test';

/**
 * Flutter web (CanvasKit) accessibility notes
 * -------------------------------------------
 * - Visual rendering is on a <canvas> inside flt-glass-pane shadow root.
 * - Accessibility layer lives in:
 *     flutter-view > flt-semantics-host > flt-semantics  (regular DOM, NOT shadow)
 * - flt-semantics nodes have text in .textContent — page.getByText() works.
 * - All clicks need { force: true } — ancestor has filter:opacity(0%).
 * - Text inputs: clicking the area causes Flutter to inject a real <input>
 *   in flt-text-editing-host; fill that input afterwards.
 * - IndexedDB names used by Hive: "todos", "members", "settings".
 */

export async function waitForFlutter(page: Page, ms = 500): Promise<void> {
  await page.waitForTimeout(ms);
}

/** Wait for the Flutter accessibility tree to be present. */
export async function waitForAppReady(page: Page): Promise<void> {
  await page.waitForSelector('flutter-view flt-semantics-host', {
    state: 'attached',
    timeout: 30_000,
  });
  await waitForFlutter(page, 1200);
}

/** Clear all Hive boxes from IndexedDB so tests start fresh. */
export async function clearStorage(page: Page): Promise<void> {
  await page.evaluate(async () => {
    const dbs = ['todos', 'members', 'settings'];
    await Promise.all(
      dbs.map(
        (name) =>
          new Promise<void>((resolve) => {
            const req = indexedDB.deleteDatabase(name);
            req.onsuccess = () => resolve();
            req.onerror = () => resolve();
            req.onblocked = () => resolve();
          })
      )
    );
  });
}

/**
 * Click a Flutter button (force-click through the opacity layer).
 * Matches by role="button" and visible text label.
 */
export async function tapButton(
  page: Page,
  label: string | RegExp
): Promise<void> {
  await page
    .locator('flt-semantics[role="button"]')
    .filter({ hasText: label })
    .first()
    .click({ force: true });
  // 600ms > 320ms page-transition animation — ensures semantics settle before
  // the caller tries to fill inputs or locate elements on the new page.
  await waitForFlutter(page, 600);
}

/**
 * Click the nth text-input area in the current screen, then fill the
 * native <input> element Flutter injects into flt-text-editing-host.
 */
export async function fillInput(
  page: Page,
  nth: number,
  value: string
): Promise<void> {
  // Tappable non-button semantics nodes are the text-field hit areas
  const tapTargets = page
    .locator('flt-semantics[style*="pointer-events: all"]')
    .filter({ hasNot: page.locator('[role="button"]') });
  await tapTargets.nth(nth).click({ force: true });
  await waitForFlutter(page, 400);
  await page.locator('input, textarea').first().fill(value);
  await waitForFlutter(page, 200);
}

/**
 * Complete the full 4-step onboarding wizard.
 * Leaves you on the Home screen (Dashboard tab).
 *
 * Uses waitFor on known page-2/4 elements instead of fixed sleeps so the
 * helper is resilient to variable Flutter rendering speed across test runs.
 */
export async function completeOnboarding(
  page: Page,
  opts: { familyName?: string; adminName?: string } = {}
): Promise<void> {
  const { familyName = 'Test Family', adminName = 'Alex' } = opts;

  await waitForAppReady(page);

  // Page 1 — workspace name (Flutter auto-focuses this field on load)
  await page.locator('input, textarea').first().fill(familyName);
  await tapButton(page, /Next/i);

  // Page 2 — wait for it to appear before filling (transition can be slow)
  await page
    .locator('flt-semantics')
    .filter({ hasText: "What's your name?" })
    .first()
    .waitFor({ state: 'attached', timeout: 10_000 });
  await page.locator('input, textarea').first().fill(adminName);
  await tapButton(page, /Next/i);

  // Page 3 — icon (accept default)
  await tapButton(page, /Next/i);

  // Page 4 — wait for Go to Board button then click
  await page
    .locator('flt-semantics[role="button"]')
    .filter({ hasText: /Go to Board/i })
    .first()
    .waitFor({ state: 'attached', timeout: 10_000 });
  await tapButton(page, /Go to Board/i);
  await waitForFlutter(page, 1000);
}

/** Open the Add Task bottom sheet via the FAB. */
export async function openAddTaskSheet(page: Page): Promise<void> {
  await tapButton(page, /Add Task/i);
  await waitForFlutter(page);
}

/** Open the sheet, fill the title, and save. */
export async function addTask(page: Page, title: string): Promise<void> {
  await openAddTaskSheet(page);
  await page.locator('input, textarea').first().fill(title);
  // Blur the text field before clicking — keeps Flutter's event routing clean.
  await page.keyboard.press('Tab');
  await waitForFlutter(page, 200);
  await tapButton(page, /^Add Task$/i);
  await waitForFlutter(page);
}

/** Navigate to a bottom-nav tab by label. */
export async function goToTab(
  page: Page,
  tab: 'Dashboard' | 'List' | 'Family Feed'
): Promise<void> {
  await page
    .locator('flt-semantics[role="button"]')
    .filter({ hasText: tab })
    .click({ force: true });
  await waitForFlutter(page);
}
