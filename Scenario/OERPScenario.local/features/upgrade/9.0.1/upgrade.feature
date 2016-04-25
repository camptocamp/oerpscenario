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
      | specific_reports           |
    Then my modules should have been installed and models reloaded

  @bom_setting
  Scenario: setup of bom dismantling
    Given I need a "ir.config_parameter" with key: mrp.bom.dismantling.product_choice
    And having:
      | key   | value                              |
      | key   | mrp.bom.dismantling.product_choice |
      | value | 1                                  |

  @slow
  Scenario: update products
    Given "product.product" is imported from CSV "setup/product.product.csv" using delimiter ","

  @slow
  Scenario: update specific orderpoint
    Given "stock.warehouse.orderpoint" is imported from CSV "setup/stock.warehouse.orderpoint.csv" using delimiter ","

  @slow
  Scenario: import specific supplierinfo
    Given "product.supplierinfo" is imported from CSV "setup/product.supplierinfo.csv" using delimiter ","

  Scenario: I configure postlogistics authentification
    Given I need a "res.company" with oid: base.main_company
    And having:
      | name                                | value                       |
      | postlogistics_username              | TUW003693                   |
      | postlogistics_password              | 8cB{0tHf))C%                |
      | postlogistics_office                |                             |
      | postlogistics_default_label_layout  | by code: A7                 |
      | postlogistics_default_output_format | by code: PDF                |
      | postlogistics_default_resolution    | by code: 300                |

  Scenario Outline: I configure postlogistics frankling licenses
    Given I need a "postlogistics.license" with oid: <oid>
    And having:
      | name       | value                     |
      | name       | <name>                    |
      | number     | <number>                  |
      | company_id | by oid: base.main_company |
      | sequence   | <sequence>                |

    Examples:
      | sequence | name      | number   | oid                             |
      | 1        | License 1 | 42133507 | scenario.postlogistics_license1 |
      | 2        | License 2 | 60004890 | scenario.postlogistics_license2 |

  Scenario: I update postlogistics services (It will take 1 minute)
    Given I am configuring the company with ref "base.main_company"
    And I update postlogistics services

  @version
  Scenario: setup application version
    Given I set the version of the instance to "9.0.1"
