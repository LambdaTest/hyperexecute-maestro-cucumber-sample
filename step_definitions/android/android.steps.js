const { Given, When, Then } = require('@cucumber/cucumber');
const { runFlow } = require('../support/maestro');

Given('the Wikipedia app is installed', function () {
  // No-op: HyperExecute's `pre` step installs apps/sample.apk before the suite runs.
});

When('I launch the app', function () {
  runFlow('android/launch_app.yaml');
});

When('I step through the onboarding carousel', function () {
  runFlow('android/complete_onboarding.yaml');
});

When('I skip onboarding if shown', function () {
  runFlow('android/skip_onboarding_if_shown.yaml');
});

When('I tap the search icon', function () {
  runFlow('android/tap_search_icon.yaml');
});

Then('I should see the Wikipedia home screen', function () {
  runFlow('android/assert_home_visible.yaml');
});

Then('I should land on the home screen', function () {
  runFlow('android/assert_onboarding_complete.yaml');
});

Then('the search input should be visible', function () {
  runFlow('android/assert_search_input_visible.yaml');
});
