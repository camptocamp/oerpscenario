# -*- coding: utf-8 -*-
@upgrade_from_9.0.0

Feature: upgrade to 9.0.1

  Scenario: upgrade application version

    Given I update the module list
    Given I install the required modules with dependencies:
      | name                       |
      | project                    |
      | specific_building_project  |
      | specific_stock             |
    Then my modules should have been installed and models reloaded
