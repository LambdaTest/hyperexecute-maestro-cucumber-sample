@android @onboarding
Feature: Onboarding
  As a first-time Wikipedia app user
  I want to open the app and get past onboarding
  So that I can reach the home screen

  @smoke
  Scenario: App launches successfully
    Given the Wikipedia app is installed
    When I launch the app
    And I skip onboarding if shown
    Then I should see the Wikipedia home screen

  @regression
  Scenario: User completes the onboarding carousel
    Given the Wikipedia app is installed
    When I launch the app
    And I step through the onboarding carousel
    Then I should land on the home screen
