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
