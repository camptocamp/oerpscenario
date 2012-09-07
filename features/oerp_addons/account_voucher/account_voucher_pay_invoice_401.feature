###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Copyright 2009 Camptocamp SA
#
##############################################################################
##############################################################################
# Branch      # Module       # Processes     # System
@addons       @account_voucher       @4     @401PI

Feature: In order to validate multicurrency account_voucher behaviour as an admin user I do a reconciliation run.
         I want to create a customer invoice for 1000 EUR (rate : 1) and pay it in full in EUR (rate : 1)
         with account_voucher using the pay invoice button from the invoice. 

  @account_voucher_run
  Scenario: Create invoice 401PI
  Given I need a "account.invoice" with oid: scen.voucher_inv_401PI
    And having:
      | name               | value                              |
      | name               | SI_401PI                           |
      | date_invoice       | %Y-01-01                           |
      | date_due           | %Y-02-15                           |
      | address_invoice_id | by oid: scen.partner_1_add         |
      | partner_id         | by oid: scen.partner_1             |
      | account_id         | by name: Debtors                   |
      | journal_id         | by name: Sales                     |
      | currency_id        | by name: EUR                       |
      | type               | out_invoice                        |


    Given I need a "account.invoice.line" with oid: scen.voucher_inv401PI_line401PI
    And having:
      | name       | value                           |
      | name       | invoice line 401PI              |
      | quantity   | 1                               |
      | price_unit | 1000                            |
      | account_id | by name: Sales                  |
      | invoice_id | by oid:scen.voucher_inv_401PI   |
    Given I find a "account.invoice" with oid: scen.voucher_inv_401PI
    And I open the credit invoice


    Given I pay the customer invoice with name "SI_401PI"
    And I set the voucher paid amount to "1150"
    And I set the voucher payment method to "EUR bank"
    And I set the voucher's first line to be "full reconcile" with a "1000" allocation    
    And I change the voucher's options to create a write-off on account "658"
#    And I save the voucher
    And I set the voucher's first line to be "full reconcile" with a "1000" allocation
    When I validate the voucher
    Then generated move lines should be:

  @account_voucher_run @account_voucher_valid_401PI
  Scenario: validate voucher
    Given I find a "account.bank.statement" with oid: scen.voucher_statement_401PI
    Then I should have following journal entries in voucher:
      | date     | period  | account                        |  debit | credit | curr.amt | curr. | reconcile | partial |
      | %Y-02-15 | 02/%Y   | Debtors                        |        |1000.00 |          |       | yes       |         |
      | %Y-02-15 | 02/%Y   | Write-off                      |        | 150.00 |          |       |           |         |
      | %Y-02-15 | 02/%Y   | EUR bank account               |1150.00 |        |          |       |           |         |


  @account_voucher_run @account_voucher_valid_invoice_401PI
  Scenario: validate voucher
    Given My invoice "SI_401PI" is in state "paid" reconciled with a residual amount of "0.0"
