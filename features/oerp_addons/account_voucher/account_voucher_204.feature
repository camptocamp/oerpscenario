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
         I want to create a supplier invoice for 1000 USD (rate : 1.8) and pay it in full in EUR (rate : 1)
         with account_voucher. The Journal entries do not calculate currency gain/loss but a write off where you 
         must select the currency gain/loss account.
         
  @account_voucher_run
  Scenario: Create invoice 204
  Given I need a "account.invoice" with oid: scen.voucher_inv_204
    And having:
      | name               | value                              |
      | name               | SI_204                             |
      | date_invoice       | %Y-02-01                           |
      | date_due           | %Y-03-15                           |
      | address_invoice_id | by oid: scen.voucher_partner_add   |
      | partner_id         | by oid: scen.voucher_partner       |
      | account_id         | by name: Creditors - (test)        |
      | journal_id         | by name: Expenses Journal - (test) |
      | currency_id        | by name: USD                       |
      | type               | in_invoice                         |


    Given I need a "account.invoice.line" with oid: scen.voucher_inv204_line204
    And having:
      | name       | value                           |
      | name       | invoice line 204                |
      | quantity   | 1                               |
      | price_unit | 1000                            |
      | account_id | by name: Product Sales - (test) |
      | invoice_id | by oid:scen.voucher_inv_204     |
    Given I find a "account.invoice" with oid: scen.voucher_inv_204
    And I open the credit invoice

  @account_voucher_run
  Scenario: Create Statement 204
    Given I need a "account.bank.statement" with oid: scen.voucher_statement_204
    And having:
     | name        | value                             |
     | name        | Bk.St.204                         |
     | date        | %Y-03-15                          |
     | currency_id | by name: EUR                      |
     | journal_id  | by oid:  scen.voucher_eur_journal |
    And the bank statement is linked to period "X 03/%Y"


 @account_voucher_run @account_voucher_import_invoice
  Scenario: Import invoice into statement
    Given I find a "account.bank.statement" with oid: scen.voucher_statement_204
    And I import invoice "SI_204" using import invoice button

  @account_voucher_run @account_voucher_confirm
  Scenario: confirm bank statement (/!\ Voucher payment options must be 'reconcile payment balance' by default )
    Given I find a "account.bank.statement" with oid: scen.voucher_statement_204
    And I set bank statement end-balance
    When I confirm bank statement
 
  @account_voucher_run @account_voucher_valid_204
  Scenario: validate voucher
    Given I find a "account.bank.statement" with oid: scen.voucher_statement_204
    Then I should have following journal entries in voucher:
      | date     | period  | account                        |  debit | credit | curr.amt | curr. | reconcile | partial |
      | %Y-03-15 | X 03/%Y | Foreign Exchange Loss - (test) | 444.44 |        |          |       |           |         |
      | %Y-03-15 | X 03/%Y | Creditors - (test)             | 555.56 |        |     1000 | USD   | yes       |         |
      | %Y-03-15 | X 03/%Y | EUR bank account               |        |1000.00 |          |       |           |         |


  @account_voucher_run @account_voucher_valid_invoice_204
  Scenario: validate voucher
    Given My invoice "SI_204" is in state "paid" reconciled with a residual amount of "0.0"
