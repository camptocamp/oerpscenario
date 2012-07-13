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
         I want to create a supplier invoice for 1000 EUR (rate : 1) and pay it in full in USD (rate : 1.5)
         with account_voucher. The Journal entries do not calculate currency gain/loss but a write off where you 
         must select the currency gain/loss account.
         
  @account_voucher_run
  Scenario: Create invoice 304
  Given I need a "account.invoice" with oid: scen.voucher_inv_304
    And having:
      | name               | value                              |
      | name               | SI_304                             |
      | date_invoice       | %Y-02-01                           |
      | date_due           | %Y-03-15                           |
      | address_invoice_id | by oid: scen.voucher_partner_add   |
      | partner_id         | by oid: scen.voucher_partner       |
      | account_id         | by name: Creditors - (test)        |
      | journal_id         | by name: Expenses Journal - (test) |
      | currency_id        | by name: EUR                       |
      | type               | in_invoice                         |


    Given I need a "account.invoice.line" with oid: scen.voucher_inv304_line304
    And having:
      | name       | value                           |
      | name       | invoice line 304                |
      | quantity   | 1                               |
      | price_unit | 1000                            |
      | account_id | by name: Product Sales - (test) |
      | invoice_id | by oid:scen.voucher_inv_304     |
    Given I find a "account.invoice" with oid: scen.voucher_inv_304
    And I open the credit invoice

  @account_voucher_run
  Scenario: Create Statement 304
    Given I need a "account.bank.statement" with oid: scen.voucher_statement_304
    And having:
     | name        | value                             |
     | name        | Bk.St.304                         |
     | date        | %Y-03-15                          |
     | currency_id | by name: USD                      |
     | journal_id  | by oid:  scen.voucher_usd_journal |
    And the bank statement is linked to period "X 03/%Y"


 @account_voucher_run @account_voucher_import_invoice
  Scenario: Import invoice into statement
    Given I find a "account.bank.statement" with oid: scen.voucher_statement_304
    And I import invoice "SI_304" using import invoice button

  @account_voucher_run @account_voucher_confirm
  Scenario: confirm bank statement (/!\ Voucher payment options must be 'reconcile payment balance' by default )
    Given I find a "account.bank.statement" with oid: scen.voucher_statement_304
    And I set bank statement end-balance
    When I confirm bank statement

   @account_voucher_run @account_voucher_valid_304
  Scenario: validate voucher
    Given I find a "account.bank.statement" with oid: scen.voucher_statement_304
    Then I should have following journal entries in voucher:
      | date     | period  | account                        |  debit | credit | curr.amt | curr. | reconcile | partial |
      | %Y-03-15 | X 03/%Y | Foreign Exchange Gain - (test) |        | 333.33 |          |       |           |         |
      | %Y-03-15 | X 03/%Y | Creditors - (test)             | 1000.00|        |          |       | yes       |         |
      | %Y-03-15 | X 03/%Y | USD bank account               |        | 666.67 |    -1000 | USD   |           |         |


  @account_voucher_run @account_voucher_valid_invoice_304
  Scenario: validate voucher
    Given My invoice "SI_304" is in state "paid" reconciled with a residual amount of "0.0"
