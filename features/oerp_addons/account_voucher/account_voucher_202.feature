###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Copyright 2009 Camptocamp SA
#
##############################################################################
##############################################################################
# Branch      # Module       # Processes     # System
@addons       @account_voucher       @account_voucher_run   @account_voucher_test

Feature: In order to validate multicurrency account_voucher behaviour as an admin user I do a reconciliation run.
         I want to create a customer invoice for 1000 USD (rate : 1.8) and pay it in full in EUR (rate : 1)
         with account_voucher. The Journal entries do not calculate currency gain/loss but a write off where you 
         must select the currency gain/loss account.

  @account_voucher_run
  Scenario: Create invoice 202
  Given I need a "account.invoice" with oid: scen.voucher_inv_202
    And having:
      | name               | value                              |
      | name               | SI_202                             |
      | date_invoice       | %Y-02-01                           |
      | date_due           | %Y-03-15                           |
      | address_invoice_id | by oid: scen.voucher_partner_add   |
      | partner_id         | by oid: scen.voucher_partner       |
      | account_id         | by name: Debtors - (test)          |
      | journal_id         | by name: Sales Journal - (test)    |
      | currency_id        | by name: USD                       |
      | type               | out_invoice                        |


    Given I need a "account.invoice.line" with oid: scen.voucher_inv102_line202
    And having:
      | name       | value                           |
      | name       | invoice line 202                |
      | quantity   | 1                               |
      | price_unit | 1000                            |
      | account_id | by name: Product Sales - (test) |
      | invoice_id | by oid:scen.voucher_inv_202     |
    Given I find a "account.invoice" with oid: scen.voucher_inv_202
    And I open the credit invoice

  @account_voucher_run
  Scenario: Create Statement 202
    Given I need a "account.bank.statement" with oid: scen.voucher_statement_202
    And having:
     | name        | value                             |
     | name        | Bk.St.202                         |
     | date        | %Y-03-15                          |
     | currency_id | by name: EUR                      |
     | journal_id  | by oid:  scen.voucher_eur_journal |
    And the bank statement is linked to period "X 03/%Y"


 @account_voucher_run @account_voucher_import_invoice
  Scenario: Import invoice into statement
    Given I find a "account.bank.statement" with oid: scen.voucher_statement_202
    And I import invoice "SI_202" using import invoice button

  @account_voucher_run @account_voucher_confirm
  Scenario: confirm bank statement (/!\ Voucher payment options must be 'reconcile payment balance' by default )
    Given I find a "account.bank.statement" with oid: scen.voucher_statement_202
    And I set bank statement end-balance
    When I confirm bank statement
 
  @account_voucher_run @account_voucher_valid_202
  Scenario: validate voucher
    Given I find a "account.bank.statement" with oid: scen.voucher_statement_202
    Then I should have following journal entries in voucher:
      | date     | period  | account                        |  debit | credit | curr.amt | curr. | reconcile | partial |
      | %Y-03-15 | X 03/%Y | Foreign Exchange Gain - (test) |        | 444.44 |          |       |           |         |    
      | %Y-03-15 | X 03/%Y | Debtors - (test)               |        | 555.56 |    -1000 | USD   | yes       |         |
      | %Y-03-15 | X 03/%Y | EUR bank account               |1000.00 |        |          |       |           |         |


  @account_voucher_run @account_voucher_valid_invoice_202
  Scenario: validate voucher
    Given My invoice "SI_202" is in state "paid" reconciled with a residual amount of "0.0"
