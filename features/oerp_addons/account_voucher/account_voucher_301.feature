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
         I want to create a customer invoice for 1000 EUR (rate : 1) and pay it in full in USD (rate : 1.8)
         with account_voucher. The Journal entries do not calculate currency gain/loss but a write off where you 
         must select the currency gain/loss account.
         
  @account_voucher_run
  Scenario: Create invoice 301
  Given I need a "account.invoice" with oid: scen.voucher_inv_301
    And having:
      | name               | value                              |
      | name               | SI_301                             |
      | date_invoice       | %Y-01-01                           |
      | date_due           | %Y-02-15                           |
      | address_invoice_id | by oid: scen.partner_1_add   |
      | partner_id         | by oid: scen.partner_1       |
      | account_id         | by name: Debtors                   |
      | journal_id         | by name: Sales                     |
      | currency_id        | by name: EUR                       |
      | type               | out_invoice                        |


    Given I need a "account.invoice.line" with oid: scen.voucher_inv301_line301
    And having:
      | name       | value                           |
      | name       | invoice line 301                |
      | quantity   | 1                               |
      | price_unit | 1000                            |
      | account_id | by name: Sales                  |
      | invoice_id | by oid:scen.voucher_inv_301     |
    Given I find a "account.invoice" with oid: scen.voucher_inv_301
    And I open the credit invoice

  @account_voucher_run
  Scenario: Create Statement 301
    Given I need a "account.bank.statement" with oid: scen.voucher_statement_301
    And having:
     | name        | value                             |
     | name        | Bk.St.301                         |
     | date        | %Y-02-15                          |
     | currency_id | by name: USD                      |
     | journal_id  | by oid:  scen.voucher_usd_journal |
    And the bank statement is linked to period "02/%Y"


 @account_voucher_run @account_voucher_import_invoice
  Scenario: Import invoice into statement (/!\ Invoice must be 'fully reconciled')
    Given I find a "account.bank.statement" with oid: scen.voucher_statement_301
    And I import invoice "SI_301" using import invoice button

  @account_voucher_run @account_voucher_confirm
  Scenario: confirm bank statement (/!\ Voucher payment options must be 'reconcile payment balance' by default )
    Given I find a "account.bank.statement" with oid: scen.voucher_statement_301
    And I set bank statement end-balance
    When I confirm bank statement

  @account_voucher_run @account_voucher_valid_301
  Scenario: validate voucher
    Given I find a "account.bank.statement" with oid: scen.voucher_statement_301
    Then I should have following journal entries in voucher:
      | date     | period  | account                        |  debit | credit | curr.amt | curr. | reconcile | partial |
      | %Y-02-15 | 02/%Y | Currency fx                      | 444.44 |        |          |       |           |         |    
      | %Y-02-15 | 02/%Y | Debtors                          |        | 1000   |          |       | yes       |         |
      | %Y-02-15 | 02/%Y | USD bank account                 | 555.56 |        |     1000 | USD   |           |         |


  @account_voucher_run @account_voucher_valid_invoice_301
  Scenario: validate voucher
    Given My invoice "SI_301" is in state "paid" reconciled with a residual amount of "0.0"
