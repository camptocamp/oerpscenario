# -*- coding: utf-8 -*-
@swisslux @setup @followup

Feature: Initial setup of the account_operation_rule

  Scenario: create account operation rule
    Given I need a "account.account" with oid: scenario.account_4090
    And having:
      | key             | value                                      |
      | name            | Skonti                                     |
      | code            | 4090                                       |
      | user_type_id    | by oid: account.data_account_type_expenses |
      | internal_type   | other                                      |
    
    Given I need a "account.operation.template" with oid: scenario.account_operation_template_skonto
    And having:
      | key          | value                                   |
      | name         | Skonto                                  |
      | label        | Skonto                                  |
      | company_id   | by oid: base.main_company               |
      | account_id   | by oid: scenario.account_4090           |
      | journal_id   | by oid: scenario.journal_ZKB1           |
      | amount_type  | percentage                              |
      | amount       | 100                                     |
      | tax_id       | by name: TVA due à 8.0% (Incl. TN)      |
      
    Given I need a "account.operation.rule" with oid: scenario.account_operation_rule_skonto
    And having:
      | key          | value                                              |
      | name         | Skonto                                             |
      | rule_type    | early_payment_discount                             |
      | operations   | by oid: scenario.account_operation_template_skonto |

