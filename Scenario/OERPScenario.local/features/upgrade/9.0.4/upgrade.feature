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

  @force_translations @slow
  Scenario: Force lang translations
    Given I update the module list
    When I update the following languages
         | lang  |
         | de_DE |
  @uom
  Scenario: update UOM translations
    Given I execute the SQL commands
    """;
    UPDATE ir_translation SET value='Stk' WHERE src like 'Unit' AND lang like 'de_DE' AND module like 'product';
    UPDATE ir_translation SET value='Pce' WHERE src like 'Unit' AND lang like 'fr_FR' AND module like 'product';
    UPDATE ir_translation SET value='Pzo' WHERE src like 'Unit' AND lang like 'it_IT' AND module like 'product';
    """


    Then I set the version of the instance to "9.0.4"
