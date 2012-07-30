###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Copyright 2009 Camptocamp SA
#
##############################################################################
##############################################################################
# Branch      # Module       # Processes     # System
@addons       @account_voucher       @account_voucher_run   @403

Feature: In order to validate multicurrency account_voucher behaviour as an admin user I do a reconciliation run.
         I want to create a supplier invoice for 1000 EUR (rate : 1) and pay it in full in EUR (rate : 1)
         with account_voucher. 

  @account_voucher_run
  Scenario: Create invoice 403
  Given I need a "account.invoice" with oid: scen.voucher_inv_403
    And having:
      | name               | value                              |
      | name               | SI_403                             |
      | date_invoice       | %Y-01-01                           |
      | date_due           | %Y-02-15                           |
      | address_invoice_id | by oid: scen.partner_1_add         |
      | partner_id         | by oid: scen.partner_1             |
      | account_id         | by name: Creditors                 |
      | journal_id         | by name: Purchases                 |
      | currency_id        | by name: EUR                       |
      | type               | in_invoice                         |


    Given I need a "account.invoice.line" with oid: scen.voucher_inv403_line403
    And having:
      | name       | value                           |
      | name       | invoice line 403                |
      | quantity   | 1                               |
      | price_unit | 1000                            |
      | account_id | by name: Sales                  |
      | invoice_id | by oid:scen.voucher_inv_403     |
    Given I find a "account.invoice" with oid: scen.voucher_inv_403
    And I open the credit invoice

  @account_voucher_run
  Scenario: Create Statement 403
    Given I need a "account.bank.statement" with oid: scen.voucher_statement_403
    And having:
     | name        | value                             |
     | name        | Bk.St.403                         |
     | date        | %Y-02-15                          |
     | currency_id | by name: EUR                      |
     | journal_id  | by oid:  scen.voucher_eur_journal |
    And the bank statement is linked to period "02/%Y"


 @account_voucher_run @account_voucher_import_invoice
  Scenario: Import invoice into statement
    Given I find a "account.bank.statement" with oid: scen.voucher_statement_403
    And I import invoice "SI_403" using import invoice button

  @account_voucher_run @account_voucher_confirm
  Scenario: confirm bank statement (/!\ Voucher payment options must be 'reconcile payment balance' by default )
    Given I find a "account.bank.statement" with oid: scen.voucher_statement_403
    And I set bank statement end-balance
    When I confirm bank statement
     
  @account_voucher_run @account_voucher_valid_403
  Scenario: validate voucher
    Given I find a "account.bank.statement" with oid: scen.voucher_statement_403
    Then I should have following journal entries in voucher:
      | date     | period  | account                        |  debit | credit | curr.amt | curr. | reconcile | partial |
      | %Y-02-15 | 02/%Y | Creditors                        |1000.00 |        |          |       | yes       |         |
      | %Y-02-15 | 02/%Y | EUR bank account                 |        |1000.00 |          |       |           |         |

  @account_voucher_run @account_voucher_valid_invoice_403
  Scenario: validate voucher
    Given My invoice "SI_403" is in state "paid" reconciled with a residual amount of "0.0"
