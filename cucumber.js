// Two profiles so each run only loads the step definitions for one platform -
// this keeps "I launch the app" etc. from colliding as an ambiguous step
// between android.steps.js and ios.steps.js.
const common = [
  '--require step_definitions/support/**/*.js',
  '--format progress',
].join(' ');

// No default feature path here on purpose: HyperExecute's run scripts always
// pass one discovered .feature file explicitly, and `npm run test:*` passes
// the full features/<platform> glob itself (see package.json). Baking a
// default path in here would make cucumber-js run it *in addition to* any
// path passed on the command line, defeating per-file fan-out.
module.exports = {
  android: [
    common,
    '--require step_definitions/android/android.steps.js',
  ].join(' '),
  ios: [
    common,
    '--require step_definitions/ios/ios.steps.js',
  ].join(' '),
};
