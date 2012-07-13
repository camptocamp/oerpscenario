###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Copyright 2009 Camptocamp SA
#
##############################################################################
##############################################################################
# Branch      # Module       # Processes     # System
@addons       @account_voucher       @account_voucher_run

Feature: In order to validate multicurrency account_voucher behaviour as an admin user I do a reconciliation run.
         I want to create a customer invoice for 1000 USD (rate : 1.8) and pay it in full in USD (rate : 1.5)
         with account_voucher. The Journal entries must calculate the correct currency gain/loss.

  @account_voucher_run
  Scenario: Create invoice 102
  Given I need a "account.invoice" with oid: scen.voucher_inv_102
    And having:
      | name               | value                              |
      | name               | SI_102                             |
      | date_invoice       | %Y-02-01                           |
      | date_due           | %Y-03-15                           |
      | address_invoice_id | by oid: scen.voucher_partner_add   |
      | partner_id         | by oid: scen.voucher_partner       |
      | account_id         | by name: Debtors - (test)          |
      | journal_id         | by name: Sales Journal - (test)    |
      | currency_id        | by name: USD                       |
      | type               | out_invoice                        |


    Given I need a "account.invoice.line" with oid: scen.voucher_inv1_line102
    And having:
      | name       | value                           |
      | name       | invoice line 102                |
      | quantity   | 1                               |
      | price_unit | 1000                            |
      | account_id | by name: Product Sales - (test) |
      | invoice_id | by oid:scen.voucher_inv_102     |
    Given I find a "account.invoice" with oid: scen.voucher_inv_102
    And I open the credit invoice

  @account_voucher_run
  Scenario: Create Statement 102
    Given I need a "account.bank.statement" with oid: scen.voucher_statement_102
    And having:
     | name        | value                             |
     | date        | %Y-03-15                          |
     | currency_id | by name: USD                      |
     | journal_id  | by oid:  scen.voucher_usd_journal |
    And the bank statement is linked to period "X 03/%Y"


 @account_voucher_run @account_voucher_import_invoice
  Scenario: Import invoice into statement
    Given I find a "account.bank.statement" with oid: scen.voucher_statement_102
    And I import invoice "SI_102" using import invoice button

  @account_voucher_run @account_voucher_confirm
  Scenario: comfirming voucher
    Given I find a "account.bank.statement" with oid: scen.voucher_statement_102
    And I set voucher balance
    When I confirm voucher

  @account_voucher_run @account_voucher_valid_102
  Scenario: validate voucher
    Given I find a "account.bank.statement" with oid: scen.voucher_statement_102
    Then I should have following journal entries in voucher:
      | date     | period  | account                        |  debit | credit | curr.amt | curr. | reconcile | partial |
      | %Y-03-15 | X 03/%Y | Foreign Exchange Gain - (test) |        | 111.11 |          | USD   |           |         |    
      | %Y-03-15 | X 03/%Y | Debtors - (test)               | 111.11 |        |     1000 | USD   | yes       |         |
      | %Y-03-15 | X 03/%Y | Debtors - (test)               |        | 666.67 |    -1000 | USD   | yes       |         |
      | %Y-03-15 | X 03/%Y | USD bank account               | 666.67 |        |     1000 | USD   |           |         |


  @account_voucher_run @account_voucher_valid_invoice_1
  Scenario: validate voucher
    Given My invoice "SI_102" is in state "paid" reconciled with a residual amount of "0.0"
