###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Copyright 2009 Camptocamp SA
#
##############################################################################
##############################################################################
# Branch      # Module       # Processes     # System
@addons       @account_voucher       @account_voucher_run   @toto

Feature: In order to validate multicurrency account_voucher behaviour as an admin user I do a reconciliation run.
         I want to create a supplier invoice for 1000 EUR (rate : 1) and pay it in full in EUR (rate : 1)
         with account_voucher. 

  @account_voucher_run
  Scenario: Create invoice 413
  Given I need a "account.invoice" with oid: scen.voucher_inv_413
    And having:
      | name               | value                              |
      | name               | SI_413                             |
      | date_invoice       | %Y-01-01                           |
      | date_due           | %Y-02-15                           |
      | address_invoice_id | by oid: scen.partner_1_add         |
      | partner_id         | by oid: scen.partner_1             |
      | account_id         | by name: Creditors                 |
      | journal_id         | by name: Purchases                 |
      | currency_id        | by name: EUR                       |
      | type               | in_invoice                         |


    Given I need a "account.invoice.line" with oid: scen.voucher_inv413_line413
    And having:
      | name       | value                           |
      | name       | invoice line 413                |
      | quantity   | 1                               |
      | price_unit | 1000                            |
      | account_id | by name: Sales                  |
      | invoice_id | by oid:scen.voucher_inv_413     |
    Given I find a "account.invoice" with oid: scen.voucher_inv_413
    And I open the credit invoice

  @account_voucher_run
  Scenario: Create Statement 413
    Given I need a "account.bank.statement" with oid: scen.voucher_statement_413
    And having:
     | name        | value                             |
     | name        | Bk.St.413                         |
     | date        | %Y-02-15                          |
     | currency_id | by name: EUR                      |
     | journal_id  | by oid:  scen.voucher_eur_journal |
    And the bank statement is linked to period "02/%Y"


 @account_voucher_run @account_voucher_import_invoice
  Scenario: Import invoice into statement
    Given I find a "account.bank.statement" with oid: scen.voucher_statement_413
    And I import invoice "SI_413" using import invoice button

 @acccout_voucher_run @account_statement_line_amount_modified   
  Scenario: Modify the paid amount of the imported invoice to pay partialy my invoice
    Given I need a "account.bank.statement.line" with name: SI_413
    And the line amount should be -1000
    Then I modify the bank statement line amount to -950
    
  @account_voucher_run @account_voucher_confirm
  Scenario: confirm bank statement 
    Given I find a "account.bank.statement" with oid: scen.voucher_statement_413
    And I set bank statement end-balance
    When I confirm bank statement
     
  @account_voucher_run @account_voucher_valid_413
  Scenario: validate voucher
    Given I find a "account.bank.statement" with oid: scen.voucher_statement_413
    Then I should have following journal entries in voucher:
      | date     | period  | account                        |  debit | credit | curr.amt | curr. | reconcile | partial |
      | %Y-02-15 | 02/%Y | Creditors                        | 950.00 |        |          |       |           |  yes    |
      | %Y-02-15 | 02/%Y | EUR bank account                 |        | 950.00 |          |       |           |         |

  @account_voucher_run @account_voucher_valid_invoice_413
  Scenario: validate voucher
    Given My invoice "SI_413" is in state "open" reconciled with a residual amount of "50.0"
