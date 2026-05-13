import { test, expect } from '@playwright/test';
import {
  clearStorage,
  completeOnboarding,
  tapButton,
  waitForFlutter,
} from '../helpers/app';

test.describe('Home Navigation', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('/');
    await clearStorage(page);
    await page.reload();
    await completeOnboarding(page);
  });

  // TC-013
  test('Dashboard is the default tab after onboarding', async ({ page }) => {
    await expect(
      page.locator('flt-semantics').filter({ hasText: 'Active Tasks' }).first()
    ).toBeAttached();
  });

  // TC-014
  test('navigating to List tab shows filter chips', async ({ page }) => {
    await page
      .locator('flt-semantics[role="button"]')
      .filter({ hasText: 'List' })
      .click({ force: true });
    await waitForFlutter(page);

    await expect(
      page.locator('flt-semantics').filter({ hasText: 'All' }).first()
    ).toBeAttached();
    await expect(
      page.locator('flt-semantics').filter({ hasText: 'Today' }).first()
    ).toBeAttached();
    await expect(
      page.locator('flt-semantics').filter({ hasText: 'Pending' }).first()
    ).toBeAttached();
  });

  // TC-014 — empty state
  test('List tab shows empty state when no tasks exist', async ({ page }) => {
    await page
      .locator('flt-semantics[role="button"]')
      .filter({ hasText: 'List' })
      .click({ force: true });
    await waitForFlutter(page);

    await expect(
      page.locator('flt-semantics').filter({ hasText: 'No active tasks' }).first()
    ).toBeAttached();
  });

  // TC-015
  test('navigating to Family Feed tab does not crash', async ({ page }) => {
    await page
      .locator('flt-semantics[role="button"]')
      .filter({ hasText: 'Family Feed' })
      .click({ force: true });
    await waitForFlutter(page);

    // Tab is accessible and app didn't crash
    await expect(
      page.locator('flt-semantics[role="button"]').filter({ hasText: 'Family Feed' }).first()
    ).toBeAttached();
  });

  test('can navigate back to Dashboard from List tab', async ({ page }) => {
    await page
      .locator('flt-semantics[role="button"]')
      .filter({ hasText: 'List' })
      .click({ force: true });
    await waitForFlutter(page);
    await page
      .locator('flt-semantics[role="button"]')
      .filter({ hasText: 'Dashboard' })
      .click({ force: true });
    await waitForFlutter(page);

    await expect(
      page.locator('flt-semantics').filter({ hasText: 'Active Tasks' }).first()
    ).toBeAttached();
  });

  test('Add Task FAB is visible on home screen', async ({ page }) => {
    await expect(
      page.locator('flt-semantics[role="button"]').filter({ hasText: /Add Task/i }).first()
    ).toBeAttached();
  });

  // Screenshot smoke
  test('home dashboard screenshot', async ({ page }) => {
    await expect(page).toHaveScreenshot('home-dashboard.png', { maxDiffPixels: 300 });
  });
});
