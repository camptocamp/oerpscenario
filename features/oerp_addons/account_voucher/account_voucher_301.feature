###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Copyright 2009 Camptocamp SA
#
##############################################################################
##############################################################################
# Branch      # Module       # Processes     # System
@addons       @account_voucher       @3     @301z

Feature: In order to validate multicurrency account_voucher behaviour as an admin user I do a reconciliation run.
         I want to create a customer invoice for 1000 EUR (rate : 1) and pay it in full in USD (rate : 1.8)
         with account_voucher. The Journal entries do not calculate currency gain/loss neither a write off. Invoice should remains open.
         
  @account_voucher_run
  Scenario: Create invoice 301z
  Given I need a "account.invoice" with oid: scen.voucher_inv_301z
    And having:
      | name               | value                              |
      | name               | SI_301z                             |
      | date_invoice       | %Y-01-01                           |
      | date_due           | %Y-02-15                           |
      | address_invoice_id | by oid: scen.partner_1_add   	|
      | partner_id         | by oid: scen.partner_1       	|
      | account_id         | by name: Debtors                   |
      | journal_id         | by name: Sales                     |
      | currency_id        | by name: EUR                       |
      | type               | out_invoice                        |


    Given I need a "account.invoice.line" with oid: scen.voucher_inv301z_line301z
    And having:
      | name       | value                           |
      | name       | invoice line 301z                |
      | quantity   | 1                               |
      | price_unit | 1000                            |
      | account_id | by name: Sales                  |
      | invoice_id | by oid:scen.voucher_inv_301z     |
    Given I find a "account.invoice" with oid: scen.voucher_inv_301z
    And I open the credit invoice

  @account_voucher_run
  Scenario: Create Statement 301z
    Given I need a "account.bank.statement" with oid: scen.voucher_statement_301z
    And having:
     | name        | value                             |
     | name        | Bk.St.301z                         |
     | date        | %Y-02-15                          |
     | currency_id | by name: USD                      |
     | journal_id  | by oid:  scen.voucher_usd_journal |
    And the bank statement is linked to period "02/%Y"


 @account_voucher_run @account_voucher_import_invoice
  Scenario: Import invoice into statement 	
    Given I find a "account.bank.statement" with oid: scen.voucher_statement_301z
    And I import invoice "SI_301z" using import invoice button

 @acccout_voucher_run @account_statement_line_amount_modified   
  Scenario: Modify the paid amount of the imported invoice to pay partialy my invoice
    Given I need a "account.bank.statement.line" with name: SI_301z
    Then I modify the bank statement line amount to 1200

  @account_voucher_run @account_voucher_confirm
  Scenario: confirm bank statement 
    Given I find a "account.bank.statement" with oid: scen.voucher_statement_301z
    And I set bank statement end-balance
    When I confirm bank statement

  @account_voucher_run @account_voucher_valid_301z
  Scenario: validate voucher
    Given I find a "account.bank.statement" with oid: scen.voucher_statement_301z
    Then I should have following journal entries in voucher:
      | date     | period  | account                        |  debit | credit | curr.amt | curr. | reconcile | partial |
      | %Y-02-15 | 02/%Y   | Debtors                        |        | 666.67 |          |       |           |  yes    |
      | %Y-02-15 | 02/%Y   | USD bank account               | 666.67 |        | 1200.00  |  USD  |           |         |
# note : currency amount is not on the debtors account in order to get a correct residual on invoice.
# BUG : Openerp gets 736.20 instead of 666.67 (same bug that in 201/203)

  @account_voucher_run @account_voucher_valid_invoice_301z
  Scenario: validate voucher
    Given My invoice "SI_301z" is in state "open" reconciled with a residual amount of "333.33"
