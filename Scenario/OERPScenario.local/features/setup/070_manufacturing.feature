# -*- coding: utf-8 -*-
@swisslux @setup @manufacturing

Feature: Configure manufacturing

  @routings
  Scenario: Configure general settings
    Given I set "Routings" to "Manage production by work orders" in "Manufacturing" settings menu

  @bom_setting
  Scenario: setup of bom dismantling
    Given I need a "ir.config_parameter" with key: mrp.bom.dismantling.product_choice
    And having:
      | key   | value                              |
      | key   | mrp.bom.dismantling.product_choice |
      | value | 1                                  |

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
      
      
