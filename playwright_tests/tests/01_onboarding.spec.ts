import { test, expect } from '@playwright/test';
import {
  clearStorage,
  tapButton,
  waitForAppReady,
  waitForFlutter,
} from '../helpers/app';

test.describe('Onboarding', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('/');
    await clearStorage(page);
    await page.reload();
    await waitForAppReady(page);
  });

  // TC-001
  test('initial screen shows workspace name page', async ({ page }) => {
    await expect(
      page.locator('flt-semantics').filter({ hasText: 'Name your workspace' }).first()
    ).toBeAttached();
    // Next button exists
    await expect(
      page.locator('flt-semantics[role="button"]').filter({ hasText: /Next/i }).first()
    ).toBeAttached();
    // Back button must NOT be present on page 1
    await expect(
      page.locator('flt-semantics[role="button"]').filter({ hasText: /^Back$/i })
    ).not.toBeAttached();
  });

  // TC-002
  test('empty family name shows validation error', async ({ page }) => {
    await tapButton(page, /Next/i);
    await expect(
      page.locator('flt-semantics').filter({ hasText: 'Please enter a family name' }).first()
    ).toBeAttached();
    // Still on page 1
    await expect(
      page.locator('flt-semantics').filter({ hasText: 'Name your workspace' }).first()
    ).toBeAttached();
  });

  // TC-003
  test('valid family name advances to page 2', async ({ page }) => {
    await page.locator('input, textarea').first().fill('The Smiths');
    await tapButton(page, /Next/i);
    await expect(
      page.locator('flt-semantics').filter({ hasText: "What's your name?" }).first()
    ).toBeAttached();
    await expect(
      page.locator('flt-semantics').filter({ hasText: 'Auto Admin' }).first()
    ).toBeAttached();
  });

  // TC-004
  test('empty admin name shows validation error', async ({ page }) => {
    await page.locator('input, textarea').first().fill('The Smiths');
    await tapButton(page, /Next/i);
    // Don't fill name, click Next
    await tapButton(page, /Next/i);
    await expect(
      page.locator('flt-semantics').filter({ hasText: 'Please enter your name' }).first()
    ).toBeAttached();
  });

  // TC-005
  test('invalid PIN length shows validation error', async ({ page }) => {
    await page.locator('input, textarea').first().fill('The Smiths');
    await tapButton(page, /Next/i);
    // Fill name
    await page.locator('input, textarea').nth(0).fill('Alex');
    // Click the PIN field's tappable area to make Flutter focus it, then fill.
    // Without this click, Flutter's text-editing bridge stays on the name field
    // and the password input value never reaches _pinCtrl.
    const pinArea = page
      .locator('flt-semantics[style*="pointer-events: all"]')
      .filter({ hasNot: page.locator('[role="button"]') })
      .nth(1);
    await pinArea.click({ force: true });
    await waitForFlutter(page, 400);
    await page.locator('input[type="password"]').fill('123');
    await tapButton(page, /Next/i);
    await expect(
      page.locator('flt-semantics').filter({ hasText: 'PIN must be exactly 4 digits' }).first()
    ).toBeAttached();
  });

  // TC-006
  test('valid name advances to icon picker page', async ({ page }) => {
    await page.locator('input, textarea').first().fill('The Smiths');
    await tapButton(page, /Next/i);
    await page.locator('input, textarea').first().fill('Alex');
    await tapButton(page, /Next/i);
    await expect(
      page.locator('flt-semantics').filter({ hasText: 'Pick a family icon' }).first()
    ).toBeAttached();
  });

  // TC-008
  test('page 3 Next advances to Add Family page', async ({ page }) => {
    await page.locator('input, textarea').first().fill('The Smiths');
    await tapButton(page, /Next/i);
    await page.locator('flt-semantics').filter({ hasText: "What's your name?" }).first().waitFor({ state: 'attached', timeout: 10_000 });
    await page.locator('input, textarea').first().fill('Alex');
    await tapButton(page, /Next/i);
    await tapButton(page, /Next/i);
    await expect(
      page.locator('flt-semantics').filter({ hasText: 'Add your family' }).first()
    ).toBeAttached({ timeout: 10_000 });
    await expect(
      page.locator('flt-semantics[role="button"]').filter({ hasText: /Go to Board/i }).first()
    ).toBeAttached();
  });

  // TC-009
  test('add a family member shows chip in list', async ({ page }) => {
    await page.locator('input, textarea').first().fill('The Smiths');
    await tapButton(page, /Next/i);
    await page.locator('flt-semantics').filter({ hasText: "What's your name?" }).first().waitFor({ state: 'attached', timeout: 10_000 });
    await page.locator('input, textarea').first().fill('Alex');
    await tapButton(page, /Next/i);
    await tapButton(page, /Next/i);
    await page.locator('flt-semantics[role="button"]').filter({ hasText: /Go to Board/i }).first().waitFor({ state: 'attached', timeout: 10_000 });

    // Fill member name then blur before clicking
    await page.locator('input, textarea').first().fill('Emma');
    await page.keyboard.press('Tab');
    await waitForFlutter(page, 200);
    await tapButton(page, /Add Member/i);
    await waitForFlutter(page);

    await expect(
      page.locator('flt-semantics').filter({ hasText: 'Emma' }).first()
    ).toBeAttached();
  });

  // TC-011
  test('empty member name shows validation error', async ({ page }) => {
    await page.locator('input, textarea').first().fill('The Smiths');
    await tapButton(page, /Next/i);
    await page.locator('flt-semantics').filter({ hasText: "What's your name?" }).first().waitFor({ state: 'attached', timeout: 10_000 });
    await page.locator('input, textarea').first().fill('Alex');
    await tapButton(page, /Next/i);
    await tapButton(page, /Next/i);
    await page.locator('flt-semantics[role="button"]').filter({ hasText: /Go to Board/i }).first().waitFor({ state: 'attached', timeout: 10_000 });

    await tapButton(page, /Add Member/i);
    await expect(
      page.locator('flt-semantics').filter({ hasText: 'Enter a name' }).first()
    ).toBeAttached();
  });

  // TC-012
  test('Go to Board completes onboarding and shows home screen', async ({ page }) => {
    await page.locator('input, textarea').first().fill('The Smiths');
    await tapButton(page, /Next/i);
    await page.locator('flt-semantics').filter({ hasText: "What's your name?" }).first().waitFor({ state: 'attached', timeout: 10_000 });
    await page.locator('input, textarea').first().fill('Alex');
    await tapButton(page, /Next/i);
    await tapButton(page, /Next/i);
    await page.locator('flt-semantics[role="button"]').filter({ hasText: /Go to Board/i }).first().waitFor({ state: 'attached', timeout: 10_000 });
    await tapButton(page, /Go to Board/i);
    await waitForFlutter(page, 1000);

    // Home screen should have Add Task button and Dashboard tab
    await expect(
      page.locator('flt-semantics[role="button"]').filter({ hasText: /Add Task/i }).first()
    ).toBeAttached();
  });

  // Screenshot smoke
  test('onboarding page 1 screenshot', async ({ page }) => {
    await expect(page).toHaveScreenshot('onboarding-page1.png', { maxDiffPixels: 300 });
  });
});
