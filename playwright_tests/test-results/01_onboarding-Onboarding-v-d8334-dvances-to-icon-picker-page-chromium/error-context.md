# Instructions

- Following Playwright test failed.
- Explain why, be concise, respect Playwright best practices.
- Provide a snippet of code with the fix, if possible.

# Test info

- Name: 01_onboarding.spec.ts >> Onboarding >> valid name advances to icon picker page
- Location: tests/01_onboarding.spec.ts:90:7

# Error details

```
Error: expect(locator).toBeAttached() failed

Locator: locator('flt-semantics').filter({ hasText: 'Pick a family icon' }).first()
Expected: attached
Timeout: 5000ms
Error: element(s) not found

Call log:
  - Expect "toBeAttached" with timeout 5000ms
  - waiting for locator('flt-semantics').filter({ hasText: 'Pick a family icon' }).first()

```

```yaml
- group:
  - text: 👑 Auto Admin What's your name? You'll be the Admin of this family workspace YOUR NAME
  - textbox "e.g. Alex"
  - text: Please enter your name PIN (OPTIONAL) Protects your Admin profile — exactly 4 digits
  - textbox "••••"
- button "Back"
- button "Next →"
```

# Test source

```ts
  1   | import { test, expect } from '@playwright/test';
  2   | import {
  3   |   clearStorage,
  4   |   tapButton,
  5   |   waitForAppReady,
  6   |   waitForFlutter,
  7   | } from '../helpers/app';
  8   | 
  9   | test.describe('Onboarding', () => {
  10  |   test.beforeEach(async ({ page }) => {
  11  |     await page.goto('/');
  12  |     await clearStorage(page);
  13  |     await page.reload();
  14  |     await waitForAppReady(page);
  15  |   });
  16  | 
  17  |   // TC-001
  18  |   test('initial screen shows workspace name page', async ({ page }) => {
  19  |     await expect(
  20  |       page.locator('flt-semantics').filter({ hasText: 'Name your workspace' }).first()
  21  |     ).toBeAttached();
  22  |     // Next button exists
  23  |     await expect(
  24  |       page.locator('flt-semantics[role="button"]').filter({ hasText: /Next/i }).first()
  25  |     ).toBeAttached();
  26  |     // Back button must NOT be present on page 1
  27  |     await expect(
  28  |       page.locator('flt-semantics[role="button"]').filter({ hasText: /^Back$/i })
  29  |     ).not.toBeAttached();
  30  |   });
  31  | 
  32  |   // TC-002
  33  |   test('empty family name shows validation error', async ({ page }) => {
  34  |     await tapButton(page, /Next/i);
  35  |     await expect(
  36  |       page.locator('flt-semantics').filter({ hasText: 'Please enter a family name' }).first()
  37  |     ).toBeAttached();
  38  |     // Still on page 1
  39  |     await expect(
  40  |       page.locator('flt-semantics').filter({ hasText: 'Name your workspace' }).first()
  41  |     ).toBeAttached();
  42  |   });
  43  | 
  44  |   // TC-003
  45  |   test('valid family name advances to page 2', async ({ page }) => {
  46  |     await page.locator('input, textarea').first().fill('The Smiths');
  47  |     await tapButton(page, /Next/i);
  48  |     await expect(
  49  |       page.locator('flt-semantics').filter({ hasText: "What's your name?" }).first()
  50  |     ).toBeAttached();
  51  |     await expect(
  52  |       page.locator('flt-semantics').filter({ hasText: 'Auto Admin' }).first()
  53  |     ).toBeAttached();
  54  |   });
  55  | 
  56  |   // TC-004
  57  |   test('empty admin name shows validation error', async ({ page }) => {
  58  |     await page.locator('input, textarea').first().fill('The Smiths');
  59  |     await tapButton(page, /Next/i);
  60  |     // Don't fill name, click Next
  61  |     await tapButton(page, /Next/i);
  62  |     await expect(
  63  |       page.locator('flt-semantics').filter({ hasText: 'Please enter your name' }).first()
  64  |     ).toBeAttached();
  65  |   });
  66  | 
  67  |   // TC-005
  68  |   test('invalid PIN length shows validation error', async ({ page }) => {
  69  |     await page.locator('input, textarea').first().fill('The Smiths');
  70  |     await tapButton(page, /Next/i);
  71  |     // Fill name
  72  |     await page.locator('input, textarea').nth(0).fill('Alex');
  73  |     // Click the PIN field's tappable area to make Flutter focus it, then fill.
  74  |     // Without this click, Flutter's text-editing bridge stays on the name field
  75  |     // and the password input value never reaches _pinCtrl.
  76  |     const pinArea = page
  77  |       .locator('flt-semantics[style*="pointer-events: all"]')
  78  |       .filter({ hasNot: page.locator('[role="button"]') })
  79  |       .nth(1);
  80  |     await pinArea.click({ force: true });
  81  |     await waitForFlutter(page, 400);
  82  |     await page.locator('input[type="password"]').fill('123');
  83  |     await tapButton(page, /Next/i);
  84  |     await expect(
  85  |       page.locator('flt-semantics').filter({ hasText: 'PIN must be exactly 4 digits' }).first()
  86  |     ).toBeAttached();
  87  |   });
  88  | 
  89  |   // TC-006
  90  |   test('valid name advances to icon picker page', async ({ page }) => {
  91  |     await page.locator('input, textarea').first().fill('The Smiths');
  92  |     await tapButton(page, /Next/i);
  93  |     await page.locator('input, textarea').first().fill('Alex');
  94  |     await tapButton(page, /Next/i);
  95  |     await expect(
  96  |       page.locator('flt-semantics').filter({ hasText: 'Pick a family icon' }).first()
> 97  |     ).toBeAttached();
      |       ^ Error: expect(locator).toBeAttached() failed
  98  |   });
  99  | 
  100 |   // TC-008
  101 |   test('page 3 Next advances to Add Family page', async ({ page }) => {
  102 |     await page.locator('input, textarea').first().fill('The Smiths');
  103 |     await tapButton(page, /Next/i);
  104 |     await page.locator('flt-semantics').filter({ hasText: "What's your name?" }).first().waitFor({ state: 'attached', timeout: 10_000 });
  105 |     await page.locator('input, textarea').first().fill('Alex');
  106 |     await tapButton(page, /Next/i);
  107 |     await tapButton(page, /Next/i);
  108 |     await expect(
  109 |       page.locator('flt-semantics').filter({ hasText: 'Add your family' }).first()
  110 |     ).toBeAttached({ timeout: 10_000 });
  111 |     await expect(
  112 |       page.locator('flt-semantics[role="button"]').filter({ hasText: /Go to Board/i }).first()
  113 |     ).toBeAttached();
  114 |   });
  115 | 
  116 |   // TC-009
  117 |   test('add a family member shows chip in list', async ({ page }) => {
  118 |     await page.locator('input, textarea').first().fill('The Smiths');
  119 |     await tapButton(page, /Next/i);
  120 |     await page.locator('flt-semantics').filter({ hasText: "What's your name?" }).first().waitFor({ state: 'attached', timeout: 10_000 });
  121 |     await page.locator('input, textarea').first().fill('Alex');
  122 |     await tapButton(page, /Next/i);
  123 |     await tapButton(page, /Next/i);
  124 |     await page.locator('flt-semantics[role="button"]').filter({ hasText: /Go to Board/i }).first().waitFor({ state: 'attached', timeout: 10_000 });
  125 | 
  126 |     // Fill member name then blur before clicking
  127 |     await page.locator('input, textarea').first().fill('Emma');
  128 |     await page.keyboard.press('Tab');
  129 |     await waitForFlutter(page, 200);
  130 |     await tapButton(page, /Add Member/i);
  131 |     await waitForFlutter(page);
  132 | 
  133 |     await expect(
  134 |       page.locator('flt-semantics').filter({ hasText: 'Emma' }).first()
  135 |     ).toBeAttached();
  136 |   });
  137 | 
  138 |   // TC-011
  139 |   test('empty member name shows validation error', async ({ page }) => {
  140 |     await page.locator('input, textarea').first().fill('The Smiths');
  141 |     await tapButton(page, /Next/i);
  142 |     await page.locator('flt-semantics').filter({ hasText: "What's your name?" }).first().waitFor({ state: 'attached', timeout: 10_000 });
  143 |     await page.locator('input, textarea').first().fill('Alex');
  144 |     await tapButton(page, /Next/i);
  145 |     await tapButton(page, /Next/i);
  146 |     await page.locator('flt-semantics[role="button"]').filter({ hasText: /Go to Board/i }).first().waitFor({ state: 'attached', timeout: 10_000 });
  147 | 
  148 |     await tapButton(page, /Add Member/i);
  149 |     await expect(
  150 |       page.locator('flt-semantics').filter({ hasText: 'Enter a name' }).first()
  151 |     ).toBeAttached();
  152 |   });
  153 | 
  154 |   // TC-012
  155 |   test('Go to Board completes onboarding and shows home screen', async ({ page }) => {
  156 |     await page.locator('input, textarea').first().fill('The Smiths');
  157 |     await tapButton(page, /Next/i);
  158 |     await page.locator('flt-semantics').filter({ hasText: "What's your name?" }).first().waitFor({ state: 'attached', timeout: 10_000 });
  159 |     await page.locator('input, textarea').first().fill('Alex');
  160 |     await tapButton(page, /Next/i);
  161 |     await tapButton(page, /Next/i);
  162 |     await page.locator('flt-semantics[role="button"]').filter({ hasText: /Go to Board/i }).first().waitFor({ state: 'attached', timeout: 10_000 });
  163 |     await tapButton(page, /Go to Board/i);
  164 |     await waitForFlutter(page, 1000);
  165 | 
  166 |     // Home screen should have Add Task button and Dashboard tab
  167 |     await expect(
  168 |       page.locator('flt-semantics[role="button"]').filter({ hasText: /Add Task/i }).first()
  169 |     ).toBeAttached();
  170 |   });
  171 | 
  172 |   // Screenshot smoke
  173 |   test('onboarding page 1 screenshot', async ({ page }) => {
  174 |     await expect(page).toHaveScreenshot('onboarding-page1.png', { maxDiffPixels: 300 });
  175 |   });
  176 | });
  177 | 
```