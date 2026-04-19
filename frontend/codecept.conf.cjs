exports.config = {
  tests: "./e2e/**/*_test.js",
  output: "./e2e/output",
  helpers: {
    Playwright: {
      browser: "chromium",
      url: process.env.BASE_URL || "http://127.0.0.1:4173",
      show: false,
      waitForNavigation: "domcontentloaded",
      waitForTimeout: 10000,
    },
  },
  include: {
    I: "./e2e/steps_file.cjs",
  },
  plugins: {
    screenshotOnFail: {
      enabled: true,
      fullPageScreenshots: true,
    },
    stepByStepReport: {
      enabled: true,
      fullPageScreenshots: true,
      deleteSuccessful: false,
    },
  },
  name: "ltjava-frontend-e2e",
};
