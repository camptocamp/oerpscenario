# -*- coding: utf-8 -*-
@upgrade_from_9.0.6
Feature: upgrade to 9.0.7

  Scenario: upgrade
    Given I update the module list
    Given I install the required modules with dependencies:
      | name                                          |
      | specific_reports                              |
      | specific_product                              |
      | specific_building_project                     |
    Then my modules should have been installed and models reloaded

  @account_chart_extended
  Scenario: Generate extended account chart for Swisslux AG
    Given "account.account" is imported from CSV "setup/account.account.csv" using delimiter ","

  @product_category
  Scenario: setup tmp corr for product category
    Given "product.category" is imported from CSV "setup/product.category.csv" using delimiter ","

  @external_location
  Scenario: Configure dedicated location for external manufacturer
    Given I need an "stock.location" with oid: scenario.location_vendor_fluora
    And having:
      | key             | value                                     |
      | name            | Fluora                                    |
      | usage           | supplier                                  |
      | location_id     | by oid: stock.stock_location_suppliers    |
      | active          | True                                      |
      | return_location | False                                     |
      | scrap_location  | False                                     |
    Given I need an "stock.location" with oid: scenario.location_vendor_poltera
    And having:
      | key             | value                                     |
      | name            | Poltera                                   |
      | usage           | supplier                                  |
      | location_id     | by oid: stock.stock_location_suppliers    |
      | active          | True                                      |
      | return_location | False                                     |
      | scrap_location  | False                                     |

  @mrp_routing
  Scenario: Configure dedicated MRP routing for external manufacturer
    Given I need an "mrp.routing" with oid: scenario.mrp_routing_fluora
    And having:
      | key             | value                                     |
      | code            | FLUO                                      |
      | name            | Fluora                                    |
      | location_id     | by oid: scenario.location_vendor_fluora   |
      | active          | True                                      |
    Given I need an "mrp.routing" with oid: scenario.mrp_routing_poltera
    And having:
      | key             | value                                     |
      | code            | POLT                                      |
      | name            | Poltera                                   |
      | location_id     | by oid: scenario.location_vendor_poltera  |
      | active          | True                                      |

  @decimal_precision
  Scenario: adjust decimal precision for product uom
    Given I need an "decimal.precision" with oid: product.decimal_product_uom
    And having:
      | key     | value |
      | digits  | 1     |

  @force_translations @slow
  Scenario: Force lang translations
    Given I update the module list
    When I update the following languages
         | lang  |
         | de_DE |
         | fr_FR |
         | it_IT |

    Then I set the version of the instance to "9.0.7"
