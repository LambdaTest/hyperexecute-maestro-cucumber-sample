const { Given, When, Then } = require('@cucumber/cucumber');
const { runFlow } = require('../support/maestro');

Given('the QA test app is installed', function () {
  // No-op: HyperExecute's `pre` step installs apps/Proverbial_ios.ipa before the suite runs.
});

When('I launch the app', function () {
  runFlow('ios/launch_app.yaml');
});

When('I browse through the Home, Live, Browser and GPS tabs', function () {
  runFlow('ios/browse_tabs.yaml');
});

Then('I should see the Home tab', function () {
  runFlow('ios/assert_home_tab_visible.yaml');
});

Then('the GPS tab should be visible', function () {
  runFlow('ios/assert_gps_tab_visible.yaml');
});
