import { defineConfig, devices } from '@playwright/test';

/**
 * Run the app first:
 *   flutter build web --web-renderer html
 *   cd build/web && python3 -m http.server 8080
 *
 * Then run tests:
 *   cd playwright_tests && npm test
 */
export default defineConfig({
  testDir: './tests',
  fullyParallel: false, // run sequentially — Flutter web boots slowly
  retries: 1,
  workers: 1,
  reporter: [['html', { open: 'never' }], ['list']],

  use: {
    baseURL: 'http://localhost:8080',
    // Flutter web needs longer timeouts for first paint
    actionTimeout: 15_000,
    navigationTimeout: 30_000,
    screenshot: 'only-on-failure',
    video: 'retain-on-failure',
    trace: 'on-first-retry',
  },

  projects: [
    {
      name: 'chromium',
      use: { ...devices['Desktop Chrome'] },
    },
    {
      name: 'mobile-safari',
      use: { ...devices['iPhone 14'] },
    },
  ],
});
