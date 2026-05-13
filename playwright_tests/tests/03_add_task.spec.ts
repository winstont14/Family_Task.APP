import { test, expect } from '@playwright/test';
import {
  clearStorage,
  completeOnboarding,
  openAddTaskSheet,
  tapButton,
  waitForFlutter,
} from '../helpers/app';

test.describe('Add Task', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('/');
    await clearStorage(page);
    await page.reload();
    await completeOnboarding(page);
  });

  // TC-017
  test('clicking Add Task FAB opens the bottom sheet', async ({ page }) => {
    await openAddTaskSheet(page);

    await expect(
      page.locator('flt-semantics').filter({ hasText: 'New Task' }).first()
    ).toBeAttached();
    await expect(
      page.locator('flt-semantics').filter({ hasText: 'Quick templates' }).first()
    ).toBeAttached();
    await expect(
      page.locator('flt-semantics').filter({ hasText: '📚 Homework' }).first()
    ).toBeAttached();
  });

  // TC-018
  test('saving with empty title keeps sheet open', async ({ page }) => {
    await openAddTaskSheet(page);
    // Click save without filling title
    await tapButton(page, /^Add Task$/i);
    await waitForFlutter(page);
    // Sheet still open
    await expect(
      page.locator('flt-semantics').filter({ hasText: 'New Task' }).first()
    ).toBeAttached();
  });

  // TC-019
  test('clicking a quick template fills the title', async ({ page }) => {
    await openAddTaskSheet(page);
    // Click Homework template
    await page
      .locator('flt-semantics')
      .filter({ hasText: '📚 Homework' })
      .first()
      .click({ force: true });
    await waitForFlutter(page, 300);
    // Title input should contain the template text
    const titleInput = page.locator('input, textarea').first();
    await expect(titleInput).toHaveValue(/Homework/i);
  });

  // TC-020
  test('entering a title and saving creates a task', async ({ page }) => {
    await openAddTaskSheet(page);
    await page.locator('input, textarea').first().fill('Buy groceries');
    await tapButton(page, /^Add Task$/i);
    await waitForFlutter(page);

    // Sheet should be gone
    await expect(
      page.locator('flt-semantics').filter({ hasText: 'New Task' }).first()
    ).not.toBeAttached();

    // Navigate to List and verify task
    await page
      .locator('flt-semantics[role="button"]')
      .filter({ hasText: 'List' })
      .click({ force: true });
    await waitForFlutter(page);
    await expect(
      page.locator('flt-semantics').filter({ hasText: 'Buy groceries' }).first()
    ).toBeAttached();
  });

  // TC-025
  test('typing in the reward field is accepted', async ({ page }) => {
    await openAddTaskSheet(page);
    // The reward field is the second input
    await page.locator('input, textarea').nth(1).fill('30 min screen time');
    await expect(page.locator('input, textarea').nth(1)).toHaveValue('30 min screen time');
  });

  // TC-019 variant — template then save
  test('using a template then saving creates the task', async ({ page }) => {
    await openAddTaskSheet(page);
    await page
      .locator('flt-semantics')
      .filter({ hasText: '🐕 Walk dog' })
      .first()
      .click({ force: true });
    await waitForFlutter(page, 300);
    await tapButton(page, /^Add Task$/i);
    await waitForFlutter(page);

    await page
      .locator('flt-semantics[role="button"]')
      .filter({ hasText: 'List' })
      .click({ force: true });
    await waitForFlutter(page);
    await expect(
      page.locator('flt-semantics').filter({ hasText: '🐕 Walk dog' }).first()
    ).toBeAttached();
  });

  // Screenshot
  test('add task sheet screenshot', async ({ page }) => {
    await openAddTaskSheet(page);
    await expect(page).toHaveScreenshot('add-task-sheet.png', { maxDiffPixels: 300 });
  });
});
