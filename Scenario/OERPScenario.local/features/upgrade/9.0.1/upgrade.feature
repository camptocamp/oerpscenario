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

  @bom_setting
  Scenario: setup of bom dismantling
    Given I need a "ir.config_parameter" with key: mrp.bom.dismantling.product_choice
    And having:
      | key   | value                              |
      | key   | mrp.bom.dismantling.product_choice |
      | value | 1                                  |

  @version
  Scenario: setup application version
    Given I set the version of the instance to "9.0.1"
