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
     | name                 | value                     |
     | default_sale_tax_id  | __export__.account_tax_13 |     
    Then execute the setup