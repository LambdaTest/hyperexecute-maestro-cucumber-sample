@ios @navigation
Feature: Navigation

  @regression
  Scenario: User walks through the Home, Live, Browser and GPS tabs
    Given the QA test app is installed
    When I launch the app
    And I browse through the Home, Live, Browser and GPS tabs
    Then the GPS tab should be visible
