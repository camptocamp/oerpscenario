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
         I want to create a customer invoice for 1000 USD (rate : 1.5) and pay it in full in EUR (rate : 1)
         with account_voucher. The Journal entries must calculate the correct currency gain/loss.

  @account_voucher_run
  Scenario: Create invoice 201
  Given I need a "account.invoice" with oid: scen.voucher_inv_201
    And having:
      | name               | value                              |
      | name               | SI_201                             |
      | date_invoice       | %Y-01-01                           |
      | date_due           | %Y-02-15                           |
      | address_invoice_id | by oid: scen.voucher_partner_add   |
      | partner_id         | by oid: scen.voucher_partner       |
      | account_id         | by name: Debtors - (test)          |
      | journal_id         | by name: Sales Journal - (test)    |
      | currency_id        | by name: USD                       |
      | type               | out_invoice                        |


    Given I need a "account.invoice.line" with oid: scen.voucher_inv201_line201
    And having:
      | name       | value                           |
      | name       | invoice line 201                |
      | quantity   | 1                               |
      | price_unit | 1000                            |
      | account_id | by name: Product Sales - (test) |
      | invoice_id | by oid:scen.voucher_inv_201     |
    Given I find a "account.invoice" with oid: scen.voucher_inv_201
    And I open the credit invoice

  @account_voucher_run
  Scenario: Create Statement 201
    Given I need a "account.bank.statement" with oid: scen.voucher_statement_201
    And having:
     | name        | value                             |
     | date        | %Y-02-15                          |
     | currency_id | by name: USD                      |
     | journal_id  | by oid:  scen.voucher_usd_journal |
    And the bank statement is linked to period "X 02/%Y"


 @account_voucher_run @account_voucher_import_invoice
  Scenario: Import invoice into statement
    Given I find a "account.bank.statement" with oid: scen.voucher_statement_201
    And I import invoice "SI_201" using import invoice button

  @account_voucher_run @account_voucher_confirm
  Scenario: comfirming voucher
    Given I find a "account.bank.statement" with oid: scen.voucher_statement_201
    And I set voucher balance
    When I confirm voucher

  @account_voucher_run @account_voucher_valid_201
  Scenario: validate voucher
    Given I find a "account.bank.statement" with oid: scen.voucher_statement_201
    Then I should have following journal entries in voucher:
      | date     | period  | account                        |  debit | credit | curr.amt | curr. | reconcile | partial |
      | %Y-02-15 | X 02/%Y | Foreign Exchange Loss - (test) |        | 333.33 |          | USD   |           |         |    
      | %Y-02-15 | X 02/%Y | Debtors - (test)               | 333.33 |        |          | USD   | yes       |         |
      | %Y-02-15 | X 02/%Y | Debtors - (test)               |        |1000.00 | -1000    | USD   | yes       |         |
      | %Y-02-15 | X 02/%Y | USD bank account               |1000.00 |        |          | USD   |           |         |


  @account_voucher_run @account_voucher_valid_invoice_201
  Scenario: validate voucher
    Given My invoice "SI_201" is in state "paid" reconciled with a residual amount of "0.0"
