# -*- coding: utf-8 -*-
###############################################################################
#
#    oerpscenario, openerp functional tests
#    copyright 2015 camptocamp sa
#
##############################################################################
@swisslux @setup @analytic

Feature: Configure Analytic Accounting

  @analytic_settings
  Scenario: Analytic settings
    Given I need a "account.config.settings" with oid: scenario.account_settings
     And having:
     | name                                 | value |
     | group_analytic_accounting            | true  |
     | group_analytic_account_for_sales     | true  |
     | group_analytic_account_for_purchases | true  |
    Then execute the setup