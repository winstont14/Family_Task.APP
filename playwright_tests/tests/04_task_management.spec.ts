import { test, expect } from '@playwright/test';
import {
  addTask,
  clearStorage,
  completeOnboarding,
  waitForFlutter,
} from '../helpers/app';

test.describe('Task Management', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('/');
    await clearStorage(page);
    await page.reload();
    await completeOnboarding(page);
  });

  // TC-028
  test('task appears in List tab after being added', async ({ page }) => {
    await addTask(page, 'Walk the dog');

    await page
      .locator('flt-semantics[role="button"]')
      .filter({ hasText: 'List' })
      .click({ force: true });
    await waitForFlutter(page);

    await expect(
      page.locator('flt-semantics').filter({ hasText: 'Walk the dog' }).first()
    ).toBeAttached();
  });

  // TC-028 — multiple tasks
  test('multiple tasks all appear in the list', async ({ page }) => {
    await addTask(page, 'Task Alpha');
    await addTask(page, 'Task Beta');
    await addTask(page, 'Task Gamma');

    await page
      .locator('flt-semantics[role="button"]')
      .filter({ hasText: 'List' })
      .click({ force: true });
    await waitForFlutter(page);

    for (const label of ['Task Alpha', 'Task Beta', 'Task Gamma']) {
      await expect(
        page.locator('flt-semantics').filter({ hasText: label }).first()
      ).toBeAttached();
    }
  });

  // TC-029 — Today filter
  test('Today filter chip is clickable and does not crash', async ({ page }) => {
    await addTask(page, 'Buy milk');

    await page
      .locator('flt-semantics[role="button"]')
      .filter({ hasText: 'List' })
      .click({ force: true });
    await waitForFlutter(page);

    await page
      .locator('flt-semantics')
      .filter({ hasText: /^Today$/ })
      .first()
      .click({ force: true });
    await waitForFlutter(page);

    // App should not crash — List tab still present
    await expect(
      page.locator('flt-semantics[role="button"]').filter({ hasText: 'List' }).first()
    ).toBeAttached();
  });

  // TC-030 — Pending filter
  test('Pending filter chip is clickable', async ({ page }) => {
    await addTask(page, 'Exercise');

    await page
      .locator('flt-semantics[role="button"]')
      .filter({ hasText: 'List' })
      .click({ force: true });
    await waitForFlutter(page);

    await page
      .locator('flt-semantics')
      .filter({ hasText: /^Pending$/ })
      .first()
      .click({ force: true });
    await waitForFlutter(page);

    await expect(
      page.locator('flt-semantics').filter({ hasText: 'Exercise' }).first()
    ).toBeAttached();
  });

  // TC-031 — Toggle complete
  test('toggling task complete shows completed section', async ({ page }) => {
    await addTask(page, 'Clean room');

    await page
      .locator('flt-semantics[role="button"]')
      .filter({ hasText: 'List' })
      .click({ force: true });
    await waitForFlutter(page);

    // Checkbox has role="checkbox" in Flutter semantics
    const checkbox = page.locator('flt-semantics[role="checkbox"]').first();
    if (await checkbox.isVisible({ timeout: 3000 }).catch(() => false)) {
      await checkbox.click({ force: true });
    } else {
      // Fallback: click via aria-checked attribute target
      await page
        .locator('flt-semantics[aria-checked]')
        .first()
        .click({ force: true });
    }
    await waitForFlutter(page);

    // Completed section should appear
    await expect(
      page.locator('flt-semantics').filter({ hasText: 'COMPLETED' }).first()
    ).toBeAttached();
  });

  // TC-035 — Dashboard progress card
  test('Dashboard shows Active Tasks section', async ({ page }) => {
    await addTask(page, 'Water plants');
    await expect(
      page.locator('flt-semantics').filter({ hasText: 'Active Tasks' }).first()
    ).toBeAttached();
  });

  // Empty state disappears after first task
  test('empty state disappears once first task is added', async ({ page }) => {
    await page
      .locator('flt-semantics[role="button"]')
      .filter({ hasText: 'List' })
      .click({ force: true });
    await waitForFlutter(page);

    await expect(
      page.locator('flt-semantics').filter({ hasText: 'No active tasks' }).first()
    ).toBeAttached();

    await addTask(page, 'First task ever');

    await page
      .locator('flt-semantics[role="button"]')
      .filter({ hasText: 'List' })
      .click({ force: true });
    await waitForFlutter(page);

    await expect(
      page.locator('flt-semantics').filter({ hasText: 'No active tasks' }).first()
    ).not.toBeAttached();
    await expect(
      page.locator('flt-semantics').filter({ hasText: 'First task ever' }).first()
    ).toBeAttached();
  });

  // Screenshot
  test('task list with items screenshot', async ({ page }) => {
    await addTask(page, 'Screenshot task');
    await page
      .locator('flt-semantics[role="button"]')
      .filter({ hasText: 'List' })
      .click({ force: true });
    await waitForFlutter(page);
    await expect(page).toHaveScreenshot('task-list.png', { maxDiffPixels: 300 });
  });
});
