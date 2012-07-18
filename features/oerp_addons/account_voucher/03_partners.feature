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
  Scenario: Partner_1
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

  Scenario: Supplier_1
    Given I need a "res.partner" with oid: scen.supplier_1
    And having:
      | name                       | value              |
      | name                       | supplier_1         |
      | customer                   | 0                  |
      | supplier                   | 1                  |
      | property_account_payable   | by name: Creditors |
      | property_account_receivable| by name: Debtors   |
      
    Given I need a "res.partner.address" with oid: scen.supplier_1_add
    And having:
      | name       | value                        |
      | name       | Frederic Clementi            |
      | zip        | 1030                         |
      | city       | Bussigny                     |
      | email      | openerp@locahost.dummy       |
      | phone      | +41 21 619 10 13             |
      | street     | PSE-A, EPF                   |
      | partner_id | by oid: scen.supplier_1      |
      
  Scenario: Supplier_3
    Given I need a "res.partner" with oid: scen.supplier_3
    And having:
      | name                       | value              |
      | name                       | supplier_3         |
      | customer                   | 0                  |
      | supplier                   | 1                  |
      | property_account_payable   | by name: Creditors |
      | property_account_receivable| by name: Debtors   |
      
    Given I need a "res.partner.address" with oid: scen.supplier_3_add
    And having:
      | name       | value                        |
      | name       | Vincent Renaville            |
      | zip        | 1005                         |
      | city       | Lausanne                     |
      | email      | openerp@locahost.dummy       |
      | phone      | +41 21 619 10 13             |
      | street     | PSE-A, EPF                   |
      | partner_id | by oid: scen.supplier_3      |

  Scenario: Supplier_3
    Given I need a "res.partner" with oid: scen.supplier_3
    And having:
      | name                       | value              |
      | name                       | supplier_3         |
      | customer                   | 0                  |
      | supplier                   | 1                  |
      | property_account_payable   | by name: Creditors |
      | property_account_receivable| by name: Debtors   |
      
    Given I need a "res.partner.address" with oid: scen.supplier_3_add
    And having:
      | name       | value                        |
      | name       | Joel Grandguillaume          |
      | zip        | 1900                         |
      | city       | Neuchatel                    |
      | email      | openerp@locahost.dummy       |
      | phone      | +41 21 619 10 15             |
      | street     | PSE-A, EPF                   |
      | partner_id | by oid: scen.supplier_3      |

  Scenario: Customer_1
    Given I need a "res.partner" with oid: scen.customer_1
    And having:
      | name                       | value              |
      | name                       | customer_1         |
      | customer                   | 0                  |
      | supplier                   | 1                  |
      | property_account_payable   | by name: Creditors |
      | property_account_receivable| by name: Debtors   |
      
    Given I need a "res.partner.address" with oid: scen.customer_1_add
    And having:
      | name       | value                        |
      | name       | Guewen Baconnier             |
      | zip        | 1800                         |
      | city       | Orbe                         |
      | email      | openerp@locahost.dummy       |
      | phone      | +41 21 619 10 13             |
      | street     | PSE-A, EPF                   |
      | partner_id | by oid: scen.customer_1      |

  Scenario: Customer_2
    Given I need a "res.partner" with oid: scen.customer_2
    And having:
      | name                       | value              |
      | name                       | customer_2         |
      | customer                   | 0                  |
      | supplier                   | 1                  |
      | property_account_payable   | by name: Creditors |
      | property_account_receivable| by name: Debtors   |
      
    Given I need a "res.partner.address" with oid: scen.customer_2_add
    And having:
      | name       | value                        |
      | name       | Nicolas Bessi                |
      | zip        | 1456                         |
      | city       | Pentalaz                     |
      | email      | openerp@locahost.dummy       |
      | phone      | +41 21 619 10 16             |
      | street     | PSE-A, EPF                   |
      | partner_id | by oid: scen.customer_2      |






