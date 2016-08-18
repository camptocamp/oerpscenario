# -*- coding: utf-8 -*-
@upgrade_from_9.0.10
Feature: upgrade to 9.0.11

  Scenario: upgrade
    Given I update the module list
    Given I install the required modules with dependencies:
      | name                                          |
      | specific_building_project                     |
      | specific_pad                                  |
    Then my modules should have been installed and models reloaded

  Scenario: remove modules
    Given I uninstall the following modules:
      | name                      |
      | specific_project          |

    Then I set the version of the instance to "9.0.11"
