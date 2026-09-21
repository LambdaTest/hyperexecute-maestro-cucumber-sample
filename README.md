# Run Maestro Cucumber (BDD) Tests with HyperExecute on TestMu AI (Formerly LambdaTest)

<p align="center">
  <a href="https://www.testmuai.com/"><img src="https://img.shields.io/badge/MADE%20BY%20TestMu%20AI-000000.svg?style=for-the-badge&labelColor=000" alt="Made by TestMu AI"></a>
  <a href="https://github.com/mobile-dev-inc/maestro"><img src="https://img.shields.io/github/v/release/mobile-dev-inc/maestro.svg?style=for-the-badge&labelColor=000000" alt="Maestro version"></a>
  <a href="https://community.testmuai.com/"><img src="https://img.shields.io/badge/Join%20the%20community-blueviolet.svg?style=for-the-badge&labelColor=000000" alt="Community"></a>
</p>

## Getting Started

[TestMu AI](https://www.testmuai.com/) (Formerly LambdaTest) is the world's first full-stack AI Agentic Quality Engineering platform that empowers teams to test intelligently, smarter, and ship faster. Built for scale, it offers a full-stack testing cloud with 10K+ real devices and 3,000+ browsers. With AI-native test management, MCP servers, and agent-based automation, TestMu AI supports Selenium, Appium, Playwright, and all major frameworks. 

With TestMu AI (Formerly LambdaTest), you can run Maestro (with & without Cucumber BDD) mobile tests on real devices and emulators using HyperExecute. This sample shows how to configure Maestro + Cucumber + HyperExecute to run on the TestMu AI cloud.

- [Sign up on TestMu AI](https://www.testmuai.com/register/) (Formerly LambdaTest).
- Follow the [TestMu AI Documentation](https://www.testmuai.com/support/docs/) for the full setup walkthrough.

### Prerequisites

- A [TestMu AI](https://www.testmuai.com/) account with your username and access key
- [HyperExecute CLI](https://www.testmuai.com/support/docs/hyperexecute-cli-run-tests-on-hyperexecute-grid/) binary for your OS
- App uploaded to TestMu AI (`.apk` for Android or `.ipa`/`.zip` for iOS)

### Setup

Clone and install dependencies:

```bash
git clone https://github.com/LambdaTest/hyperexecute-maestro-cucumber-sample
chmod +x ./hyperexecute
```

Set your credentials as environment variables.

**macOS / Linux:**

```bash
export LT_USERNAME="YOUR_USERNAME"
export LT_ACCESS_KEY="YOUR_ACCESS_KEY"
export LT_TUNNEL="YOUR_TUNNEL_NAME"
```

**Windows:**

```bash
set LT_USERNAME="YOUR_USERNAME"
set LT_ACCESS_KEY="YOUR_ACCESS_KEY"
set LT_TUNNEL="YOUR_TUNNEL_NAME"
```

### Brief Walkthrough

Real Gherkin `.feature` files (`Given`/`When`/`Then`) drive Maestro mobile UI
flows, executed on HyperExecute (TestMu AI, formerly LambdaTest).

Maestro has no native Gherkin support — it only understands its own YAML flow
format — so [Cucumber.js](https://github.com/cucumber/cucumber-js) sits in
front of it as the actual test runner. Each Gherkin step's step definition
shells out to a small, single-purpose Maestro flow file. Maestro stays the
one driving the device/emulator; Cucumber owns parsing, step matching,
tagging, and JUnit/JSON reporting.

The implementation is adapted from [`LambdaTest/hyperexecute-maestro-sample-test`](https://github.com/LambdaTest/hyperexecute-maestro-sample-test).

### Structure

```
maestro-cucumber/
├── package.json / cucumber.js         # Cucumber.js dependency + android/ios profiles
├── features/                          # real Gherkin — what a non-technical stakeholder reads
│   ├── android/
│   │   ├── onboarding.feature         # @smoke, @regression scenarios
│   │   └── navigation.feature
│   └── ios/
│       ├── onboarding.feature
│       └── navigation.feature
├── step_definitions/                  # maps Gherkin steps -> a Maestro flow file
│   ├── android/android.steps.js
│   ├── ios/ios.steps.js
│   └── support/maestro.js             # shared runFlow() helper (spawns `maestro test ...`)
├── flows/                             # the actual Maestro YAML, one small flow per step
│   ├── android/*.yaml
│   └── ios/*.yaml
├── yaml/                              # HyperExecute job configs (one per platform x device type)
│   ├── android/
│   │   ├── android-emulator.yaml
│   │   └── android-realdevice.yaml
│   └── ios/
│       ├── ios-simulator.yaml
│       └── ios-realdevice.yaml
├── support/                           # setup + runner scripts HyperExecute's pre/testRunnerCommand call
│   ├── setup-android.sh / setup-ios-simulator.sh
│   ├── run-android-emulator.sh / run-android-realdevice.sh
│   ├── run-ios-simulator.sh / run-ios-realdevice.sh
│   └── run-maestro-jar.sh             # wraps `java -jar maestro.jar` for iOS real devices
├── discover/                          # test discovery: walks features/<platform>/*.feature at run time
│   ├── android.sh
│   └── ios.sh
└── apps/                              # drop your .apk / .ipa builds here
```

### Why one Maestro flow per Gherkin step

Each Maestro flow under `flows/` is intentionally tiny — one step, one flow
(e.g. `flows/android/launch_app.yaml` just does `launchApp`;
`flows/android/assert_home_visible.yaml` just does `assertVisible`). Only the
first `When` step in a scenario calls `launchApp`; later steps interact with
whatever's already on screen.

This keeps `Then` steps as real assertions
(Maestro fails the process, which fails the Cucumber step) instead of
Gherkin text glued on top of one big flow with no per-step feedback.

### How a run is wired together

Each `yaml/*/*.yaml` config:

1. **`pre`** — runs `npm install`, then `support/setup-*.sh` to install Maestro
   (and, for Android, a Maestro-compatible `adb`) on the grid node.
2. **`testDiscovery`** — runs `discover/<platform>.sh`, which does
   `find features/<platform> -name "*.feature"` so every feature file becomes
   its own HyperExecute test. Pass `TAGS=smoke` to scope discovery to feature
   files containing that tag.
3. **`testRunnerCommand`** — runs `support/run-*.sh $test`, which invokes
   `npx cucumber-js --profile <platform> <feature-file>` and writes a
   per-file JUnit report to `reports/`, which `partialReports` picks up.

Android and iOS each get their own Cucumber **profile** (`cucumber.js`) that
only `--require`s that platform's step definitions. That's deliberate: both
platforms have a step literally named `I launch the app`, and loading both
step files at once would make Cucumber report it as ambiguous.

### Run tests

Download the [HyperExecute CLI](https://www.testmuai.com/support/docs/hyperexecute-cli-run-tests-on-hyperexecute-grid/)
binary for your OS, save it as `hyperexecute` in the repo root, then:

```bash
chmod +x ./hyperexecute
export LT_USERNAME="YOUR_USERNAME"
export LT_ACCESS_KEY="YOUR_ACCESS_KEY"

./hyperexecute --user $LT_USERNAME --key $LT_ACCESS_KEY --config yaml/android/android-emulator.yaml
./hyperexecute --user $LT_USERNAME --key $LT_ACCESS_KEY --config yaml/android/android-realdevice.yaml
./hyperexecute --user $LT_USERNAME --key $LT_ACCESS_KEY --config yaml/ios/ios-simulator.yaml
```

There's no single config that runs every platform/device combination at once —
pick the `--config` that matches what you want to run.

Run tests on Android emulators:

```bash
./hyperexecute --user $LT_USERNAME --key $LT_ACCESS_KEY --config yaml/android/android-emulator.yaml
```

Results, videos, device logs, and Cucumber's JUnit report all show up on your
TestMu AI automation dashboard.

### Local testing with TestMu AI Tunnel

To test locally hosted apps, set up the TestMu AI tunnel. OS-specific guides:

- [Local Testing on Windows](https://www.testmuai.com/support/docs/local-testing-for-windows/)
- [Local Testing on macOS](https://www.testmuai.com/support/docs/local-testing-for-macos/)
- [Local Testing on Linux](https://www.testmuai.com/support/docs/local-testing-for-linux/)

Add the following to your capabilities:

```js
tunnel: true,
```

## Execution results

### HyperExecute job view

Each `.feature` file is discovered as its own test and distributed across
tasks, so features run in parallel. The job page shows per-task status and
duration, plus the live Maestro/Cucumber logs for each feature.

**Android (real device)** — job tagged `HYP`, `Maestro`, `Cucumber`, `Android-RD`.
Two tasks ran in parallel; `features/android/onboarding.feature` passed with the
Maestro `launch_app` flow reporting `1/1 Flow Passed`:

<img width="1493" height="810" alt="he-android-rd" src="https://github.com/user-attachments/assets/3abf7359-c445-4e52-8ee1-0727368709f3" />

**iOS (simulator)** — job tagged `HYP`, `Maestro`, `Cucumber`, `iOS`, `Simulator`.
Two tasks ran on macOS Sonoma; `features/ios/navigation.feature` passed with the
`launch_app` and `browse_tabs` flows each reporting `1/1 Flow Passed`:

<img width="1493" height="810" alt="he-ios-sim" src="https://github.com/user-attachments/assets/e5b91980-9e26-4ae8-864c-b4d444d3fdb8" />

### App Automation dashboard

Each feature file also appears as a test in App Automation, with the Maestro
commands executed (`Define variables`, `Apply configuration`, assertions),
device logs, network data, and a video recording. Use **View in HyperExecute**
to jump back to the parent job.

**iOS simulator** (iPhone SE 3rd generation, iOS 17.5) — both
`onboarding.feature` and `navigation.feature` completed:

<img width="1493" height="810" alt="automation-ios-sim" src="https://github.com/user-attachments/assets/b7cda351-6f6e-4569-a85e-19f75bcef639" />

**Android real device** (Pixel 6, Android 16) — both `onboarding.feature` and
`navigation.feature` completed:

<img width="1493" height="810" alt="automation-android-rd" src="https://github.com/user-attachments/assets/5eaae35f-df37-4a3c-927c-c8cb00014883" />

## Adding a new scenario

1. Write the `Given`/`When`/`Then` in the relevant `features/<platform>/*.feature` file.
2. Add matching Maestro flow(s) under `flows/<platform>/`, one action/assertion per step.
3. Wire the step text to the flow in `step_definitions/<platform>/<platform>.steps.js` via `runFlow(...)`.
4. Nothing else to register — `discover/<platform>.sh` and `testDiscovery` pick up new
   `.feature` files automatically on the next run.

## Contributions

Contributions are welcome. Open an issue to discuss your idea before submitting a pull request. When reporting bugs, include your Maestro version, OS, and HyperExecute CLI version.

## TestMu AI (Formerly LambdaTest) Community

Connect with testers and developers in the [TestMu AI Community](https://community.testmuai.com/). Ask questions, share what you are building, and discuss best practices in test automation and DevOps.
  
## TestMu AI (Formerly LambdaTest) Certifications

Earn free [TestMu AI Certifications](https://www.testmuai.com/certifications/) for testers, developers, and QA engineers. Validate your skills in Selenium, Cypress, Playwright, Appium, Espresso and more. Industry-recognized, shareable on LinkedIn, and built by practitioners, not marketers.

## Learning Resources by TestMu AI (Formerly LambdaTest)

Learn modern testing through tutorials, guides, videos, and weekly updates:

* [TestMu AI Blog](https://www.testmuai.com/blog/) - Tutorials, deep dives, and framework guides for testers and developers.
* [TestMu AI Learning Hub](https://www.testmuai.com/learning-hub/) - Long-form learning paths on Selenium, Cypress, Playwright, Appium, and AI-native testing.
* [TestMu AI Newsletter](https://www.testmuai.com/newsletter/) - Weekly roundup of what's new in testing, dev tools, and AI.
* [TestMu AI on YouTube](https://www.youtube.com/@TestMuAI) - Walkthroughs, product demos, and talks from TestMu Conference.
  
## LambdaTest is Now TestMu AI

On **January 12, 2026**, [LambdaTest evolved to TestMu AI](https://www.testmuai.com/lambdatest-is-now-testmuai/), the world's first fully autonomous **Agentic AI Quality Engineering Platform**.

Same team. Same infrastructure. Same customer accounts. All existing LambdaTest logins, scripts, capabilities, and integrations continue to work without change.

👉 Find the new home for [LambdaTest](https://www.testmuai.com).

### How LambdaTest Evolved into TestMu AI

In 2017, we launched LambdaTest with a simple mission: make testing fast, reliable, and accessible. As LambdaTest grew, we expanded into Test Intelligence, Visual Regression Testing, Accessibility Testing, API Testing, and Performance Testing, covering the full depth of the testing lifecycle.

As software development entered the AI era, testing had to evolve, too. We rebuilt the architecture to be AI-native from the ground up, with autonomous agents that **plan, author, execute, analyze, and optimize tests** while keeping humans in the loop. The platform integrates with your repos, CI, IDEs, and terminals, continuously learning from every code change and development signal.

That evolution earned a new name: **TestMu AI**, built for an AI-first future of quality engineering. TestMu is not a new name for us. It is the name of our annual community conference, which has brought together 100,000+ quality engineers to discuss how AI would reshape testing, long before that became an industry norm. TestMu AI reflects our commitment to community-driven innovation and AI-native architecture.

## Support

Got a question? Email [support@testmuai.com](mailto:support@testmuai.com) or chat with us 24x7 from our chat portal.