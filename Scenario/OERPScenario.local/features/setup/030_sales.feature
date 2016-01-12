# -*- coding: utf-8 -*-
###############################################################################
#
#    oerpscenario, openerp functional tests
#    copyright 2016 camptocamp sa
#
##############################################################################
@swisslux @setup @sales

Feature: Configure Sales

  @default_tax
  Scenario: Default tax for sales
    Given I need a "account.config.settings" with oid: scenario.account_settings
     And having:
     | name                 | value                         |
     | default_sale_tax_id  | by name: TVA due a 8.0% (TN)  |     
    Then execute the setup
    
  @sales_config
  Scenario: Main config for sales
    Given I need a "sale.config.settings" with oid: scenario.sales_settings
     And having:
     | name                         | value     |
     | group_sale_delivery_address  | 0         |
     | group_route_so_lines         | 0         |
     | sale_pricelist_setting       | formula   |
    Then execute the setup