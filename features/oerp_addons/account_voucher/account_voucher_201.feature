###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Copyright 2009 Camptocamp SA
#
##############################################################################
##############################################################################
# Branch      # Module       # Processes     # System
@addons       @account_voucher       @2     @201

Feature: In order to validate multicurrency account_voucher behaviour as an admin user I do a reconciliation run.
         I want to create a customer invoice for 1000 USD (rate : 1.5) and pay it in full in EUR (rate : 1)
         with account_voucher. The Journal entries do not calculate currency gain/loss but a write off where you 
         must select the currency gain/loss account.

  @account_voucher_run
  Scenario: Create invoice 201
  Given I need a "account.invoice" with oid: scen.voucher_inv_201
    And having:
      | name               | value                              |
      | name               | SI_201                             |
      | date_invoice       | %Y-01-01                           |
      | date_due           | %Y-02-15                           |
      | address_invoice_id | by oid: scen.partner_1_add   |
      | partner_id         | by oid: scen.partner_1       |
      | account_id         | by name: Debtors                   |
      | journal_id         | by name: Sales                     |
      | currency_id        | by name: USD                       |
      | type               | out_invoice                        |


    Given I need a "account.invoice.line" with oid: scen.voucher_inv201_line201
    And having:
      | name       | value                           |
      | name       | invoice line 201                |
      | quantity   | 1                               |
      | price_unit | 1000                            |
      | account_id | by name: Sales                  |
      | invoice_id | by oid:scen.voucher_inv_201     |
    Given I find a "account.invoice" with oid: scen.voucher_inv_201
    And I open the credit invoice

  @account_voucher_run
  Scenario: Create Statement 201
    Given I need a "account.bank.statement" with oid: scen.voucher_statement_201
    And having:
     | name        | value                             |
     | name        | Bk.St.201                         |
     | date        | %Y-02-15                          |
     | currency_id | by name: EUR                      |
     | journal_id  | by oid:  scen.voucher_eur_journal |
    And the bank statement is linked to period "02/%Y"


 @account_voucher_run @account_voucher_import_invoice
  Scenario: Import invoice into statement
    Given I find a "account.bank.statement" with oid: scen.voucher_statement_201
    And I import invoice "SI_201" using import invoice button

  @account_voucher_run @account_voucher_confirm
  Scenario: confirm bank statement (/!\ Voucher payment options must be 'reconcile payment balance' by default )
    Given I find a "account.bank.statement" with oid: scen.voucher_statement_201
    And I set bank statement end-balance
    When I confirm bank statement

  @account_voucher_run @account_voucher_valid_201
  Scenario: validate voucher
    Given I find a "account.bank.statement" with oid: scen.voucher_statement_201
    Then I should have following journal entries in voucher:
      | date     | period  | account                        |  debit | credit | curr.amt | curr. | reconcile | partial |
      | %Y-02-15 | 02/%Y | Currency fx                      |        | 333.33 |          |       |           |         |    
      | %Y-02-15 | 02/%Y | Debtors                          |        | 666.67 | -1200.01 | USD   | yes       |         |
      | %Y-02-15 | 02/%Y | EUR bank account                 |1000.00 |        |          |       |           |         |


  @account_voucher_run @account_voucher_valid_invoice_201
  Scenario: validate voucher
    Given My invoice "SI_201" is in state "paid" reconciled with a residual amount of "0.0"
