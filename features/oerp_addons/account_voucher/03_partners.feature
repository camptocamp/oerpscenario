###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Copyright 2009 Camptocamp SA
#
##############################################################################
##############################################################################
# Branch      # Module       # Processes     # System
@addons       @account_voucher       @account_voucher_addons  @param

Feature: I create a list of partners
   @account_voucher_init
  Scenario: Partner
    Given I need a "res.partner" with oid: scen.partner_1
    And having:
      | name                       | value              |
      | name                       | partner_1          |
      | customer                   | 1                  |
      | supplier                   | 1                  |
      | property_account_payable   | by name: Creditors |
      | property_account_receivable| by name: Debtors   |
      
    Given I need a "res.partner.address" with oid: scen.partner_1_add
    And having:
      | name       | value                        |
      | name       | Luc Maurer                   |
      | zip        | 1015                         |
      | city       | lausanne                     |
      | email      | openerp@locahost.dummy       |
      | phone      | +41 21 619 10 12             |
      | street     | PSE-A, EPF                   |
      | partner_id | by oid: scen.partner_1       |
