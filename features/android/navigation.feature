@android @navigation
Feature: Navigation

  @regression
  Scenario: User opens search from the home screen
    Given the Wikipedia app is installed
    When I launch the app
    And I skip onboarding if shown
    And I tap the search icon
    Then the search input should be visible
