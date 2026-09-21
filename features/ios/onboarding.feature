@ios @onboarding
Feature: Onboarding

  @smoke
  Scenario: App launches successfully
    Given the QA test app is installed
    When I launch the app
    Then I should see the Home tab
