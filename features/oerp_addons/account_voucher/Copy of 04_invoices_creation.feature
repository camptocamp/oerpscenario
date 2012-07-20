###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Copyright 2009 Camptocamp SA
#
##############################################################################
##############################################################################
# Branch      # Module       # Processes     # System
@addons   @credit_management_module @credit_management_base_data    


Feature: Invoices creation
  @credit_management_base_data  @inv_CM1
  Scenario: Create invoice CM1
  Given I need a "account.invoice" with oid: scen.voucher_inv_CM1
    And having:
      | name               | value                              |
      | name               | SI_CM1                             |
      | date_invoice       | %Y-01-15                           |
      | address_invoice_id | by oid: scen.partner_1_add         |
      | partner_id         | by oid: scen.partner_1             |
      | account_id         | by name: Debtors                   |
      | journal_id         | by name: Sales                     |
      | currency_id        | by name: USD                       |
      | type               | out_invoice                        |


    Given I need a "account.invoice.line" with oid: scen.voucher_invCM1_lineCM1
    And having:
      | name       | value                           |
      | name       | invoice line CM1                |
      | quantity   | 1                               |
      | price_unit | 1000                            |
      | account_id | by name: Sales                  |
      | invoice_id | by oid:scen.voucher_inv_CM1     |
    Given I find a "account.invoice" with oid: scen.voucher_inv_CM1
    And I open the credit invoice
    

  @credit_management_base_data  @inv_CM2
  Scenario: Create invoice CM2
  Given I need a "account.invoice" with oid: scen.voucher_inv_CM2
    And having:
      | name               | value                              |
      | name               | SI_CM2                             |
      | date_invoice       | %Y-02-15                           |
      | address_invoice_id | by oid: scen.partner_1_add         |
      | partner_id         | by oid: scen.partner_1             |
      | account_id         | by name: Debtors                   |
      | journal_id         | by name: Sales                     |
      | currency_id        | by name: USD                       |
      | type               | out_invoice                        |


    Given I need a "account.invoice.line" with oid: scen.voucher_invCM3_lineCM3
    And having:
      | name       | value                           |
      | name       | invoice line CM2                |
      | quantity   | 1                               |
      | price_unit | 1000                            |
      | account_id | by name: Sales                  |
      | invoice_id | by oid:scen.voucher_inv_CM2     |
    Given I find a "account.invoice" with oid: scen.voucher_inv_CM2
    And I open the credit invoice
    

  @credit_management_base_data  @inv_CM3
  Scenario: Create invoice CM3
  Given I need a "account.invoice" with oid: scen.voucher_inv_CM3
    And having:
      | name               | value                              |
      | name               | SI_CM3                             |
      | date_invoice       | %Y-03-15                           |
      | address_invoice_id | by oid: scen.partner_1_add         |
      | partner_id         | by oid: scen.partner_1             |
      | account_id         | by name: Debtors                   |
      | journal_id         | by name: Sales                     |
      | currency_id        | by name: USD                       |
      | type               | out_invoice                        |


    Given I need a "account.invoice.line" with oid: scen.voucher_invCM3_lineCM3
    And having:
      | name       | value                           |
      | name       | invoice line CM3                |
      | quantity   | 1                               |
      | price_unit | 1000                            |
      | account_id | by name: Sales                  |
      | invoice_id | by oid:scen.voucher_inv_CM3     |
    Given I find a "account.invoice" with oid: scen.voucher_inv_CM3
    And I open the credit invoice
    



