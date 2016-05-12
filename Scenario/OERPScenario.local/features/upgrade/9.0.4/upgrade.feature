# -*- coding: utf-8 -*-
@upgrade_from_9.0.3
Feature: upgrade to 9.0.4

  Scenario: upgrade
    Given I update the module list
    Given I install the required modules with dependencies:
      | name                       |
      | specific_building_project  |
      | specific_invoice           |
      | specific_reports           |
      | specific_account           |
    Then my modules should have been installed and models reloaded
    Given I need a "invoice.bank.rule" with oid: scenario.invoice_bank_rule_swiss
    And having:
      | key             | value                     |
      | name            | Bank for swiss customers  |
      | partner_bank_id | by oid: scenario.bank_2   |
      | country_id      | by code: CH               |
      | company_id      | by oid: base.main_company |
    Given I find a "res.company" with oid: base.main_company
    And having:
      | key                | value |
      | bvr_scan_line_horz | 0.00  |
      | bvr_scan_line_vert | 0.00  |
    Then I set the version of the instance to "9.0.4"

  @force_translations @slow
  Scenario: Force lang translations
    Given I update the module list
    When I update the following languages
         | lang  |
         | de_DE |
