# -*- coding: utf-8 -*-
###############################################################################
#
#    oerpscenario, openerp functional tests
#    copyright 2015 camptocamp sa
#
##############################################################################
@swisslux @setup @purchases

Feature: Configure Purchases

  @default_tax
  Scenario: Default tax for purchases
    Given I need a "account.config.settings" with oid: scenario.account_settings
     And having:
     | name                     | value                     |
     | default_purchase_tax_id  | __export__.account_tax_15 |     
    Then execute the setup