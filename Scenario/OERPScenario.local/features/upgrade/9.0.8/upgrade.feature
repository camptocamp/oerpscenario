# -*- coding: utf-8 -*-
@upgrade_from_9.0.7
Feature: upgrade to 9.0.8

  Scenario: upgrade
    Given I update the module list
    Given I install the required modules with dependencies:
      | name                                          |
      | specific_project                              |
    Then my modules should have been installed and models reloaded
    Then I set the version of the instance to "9.0.8"
