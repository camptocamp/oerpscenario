# -*- coding: utf-8 -*-
@upgrade_from_9.0.7
Feature: upgrade to 9.0.8

  Scenario: upgrade
    Given I update the module list
    Given I install the required modules with dependencies:
      | name                                          |
      | specific_project                              |
      | specific_building_project                     |
      | specific_product                              |
      | l10n_ch_pain_credit_transfer                  |
    Then my modules should have been installed and models reloaded

  @csv @product @slow
  Scenario: adapt account on product
    Given "product.product" is imported from CSV "setup/product.product.csv" using delimiter ","

  @csv @projects
  Scenario: import specific projects
    Given "project.project" is imported from CSV "setup/project.csv" using delimiter ","
  
  @csv @ts_activity
  Scenario: setup timesheet activities
    Given "hr.timesheet.sheet.activity" is imported from CSV "setup/hr_timesheet_activity.csv" using delimiter ","
  
  @csv @payment_term
  Scenario: update payment term
    Given I execute the SQL commands
       """;
         delete from account_payment_term_line;
       """
    Given "account.payment.term" is imported from CSV "setup/payment_term.csv" using delimiter ","

  @csv @pricelists
  Scenario: import specific pricelist
    Given "product.pricelist" is imported from CSV "setup/product.pricelist.csv" using delimiter ","

  @csv @pricelist_items @slow
  Scenario: import specific pricelist items
    Given "product.pricelist.item" is imported from CSV "setup/product.pricelist.item.csv" using delimiter ","
    
  @csv @partner @slow
  Scenario: import partner
    Given "res.partner" is imported from CSV "setup/res.partner.csv" using delimiter ","

  @update_reception_text_company
  Scenario: set default company reception text
    Given I execute the SQL commands
    """;
    update res_company set receipt_checklist = '
    _____ Anleitung Deutsch
    _____ Anleitung Franz.
    _____ Anleitung Ital.
    _____ Verpackung
    _____ Lieferumfang
    _____ Funktionstest

    Charge:  __________________________

    Technik:
    Produktenews: JA / NEIN
    Visum: ____________________________';
    """

  @configure_project
  Scenario: Activate time tracking on task
    Given I set "Time on Tasks" to "Manage time estimation on tasks" in "Project" settings menu


  @configure_sepa
  Scenario: modify pain value for Switzerland
    Given I find a "account.payment.method" with oid: account_banking_sepa_credit_transfer.sepa_credit_transfer
    And having:
      | key             | value                 |
      | pain_version    | pain.001.001.03.ch.02 |
      
    Given I need a "account.payment.mode" with oid: scenario.account_payment_mode_1
    And having:
      | key                         | value                         |
      | name                        | SEPA (ZKB)                    |
      | active                      | True                          |
      | no_debit_before_maturity    | False                         |
      | fixed_journal_id            | by oid: scenario.journal_ZKB1 |
      | generate_move               | True                          |
      | group_lines                 | True                          |
      | default_journal_ids         | add all by oid: scenario.expense_journal  |
      | default_journal_ids         | add all by oid: scenario.wage_journal     |
      | default_journal_ids         | add all by name: Vendor Bills             |
      | bank_account_link           | fixed                         |   
      | default_invoice             | False                         |
      | move_option                 | date                          |
      | offsetting_account          | bank_account                  |  
      | payment_method_id           | by oid: account_banking_sepa_credit_transfer.sepa_credit_transfer |
      | default_payment_mode        | same                          |
      | payment_order_ok            | True                          |
      | default_target_move         | posted                        |
      | default_date_type           | due                           |
  
  @remove_default_accounts_on_product
  Scenario: Remove the default account on product
  Given I execute the SQL commands
      """
      DELETE FROM ir_property WHERE name='property_account_expense_id' AND res_id IS NULL;
      DELETE FROM ir_property WHERE name='property_account_income_id' AND res_id IS NULL;
      """
  
  @force_translations @slow
  Scenario: Force lang translations
    Given I update the module list
    When I update the following languages
         | lang  |
         | de_DE |

    Then I set the version of the instance to "9.0.8"
