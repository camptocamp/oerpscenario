###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Copyright 2009 Camptocamp SA
#
##############################################################################
##############################################################################
# Branch      # Module       # Processes     # System
@base_finance_setup @base_comercial_mgmt 

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
      
  Scenario: Supplier_2
    Given I need a "res.partner" with oid: scen.supplier_2
    And having:
      | name                       | value              |
      | name                       | supplier_2         |
      | supplier                   | 1                  |
      | property_account_payable   | by name: Creditors |
      | property_account_receivable| by name: Debtors   |
      
    Given I need a "res.partner.address" with oid: scen.supplier_2_add
    And having:
      | name       | value                        |
      | name       | Vincent Renaville            |
      | zip        | 1005                         |
      | city       | Lausanne                     |
      | email      | openerp@locahost.dummy       |
      | phone      | +41 21 619 10 13             |
      | street     | PSE-A, EPF                   |
      | partner_id | by oid: scen.supplier_2      |

  Scenario: Supplier_3
    Given I need a "res.partner" with oid: scen.supplier_3
    And having:
      | name                       | value              |
      | name                       | supplier_3         |
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

  Scenario: Supplier_4 en USD
    Given I need a "res.partner" with oid: scen.supplier_4_usd
    And having:
      | name                       | value                  |
      | name                       | supplier_4_usd         |
      | supplier                   | 1                      |
      | property_account_payable   | by name: Creditors USD |
      | property_account_receivable| by name: Debtors USD   |
      
    Given I need a "res.partner.address" with oid: scen.supplier_4_add
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
      | customer                   | 1                  |
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
      | customer                   | 1                  |
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

  Scenario: Customer_3
    Given I need a "res.partner" with oid: scen.customer_3
    And having:
      | name                       | value              |
      | name                       | customer_3         |
      | customer                   | 1                  |
      | property_account_payable   | by name: Creditors |
      | property_account_receivable| by name: Debtors   |
      
    Given I need a "res.partner.address" with oid: scen.customer_3_add
    And having:
      | name       | value                        |
      | name       | Yannick Vauchet              |
      | zip        | 1456                         |
      | city       | Neuchatel                    |
      | email      | openerp@locahost.dummy       |
      | phone      | +41 21 619 10 18             |
      | street     | PSE-A, EPF                   |
      | partner_id | by oid: scen.customer_3      |

  Scenario: Customer_4
    Given I need a "res.partner" with oid: scen.customer_4
    And having:
      | name                       | value              |
      | name                       | customer_4         |
      | customer                   | 1                  |
      | property_account_payable   | by name: Creditors |
      | property_account_receivable| by name: Debtors   |
      
    Given I need a "res.partner.address" with oid: scen.customer_4_add
    And having:
      | name       | value                        |
      | name       | Alexandre Fayolle            |
      | zip        | 1456                         |
      | city       | Neuchatel                    |
      | email      | openerp@locahost.dummy       |
      | phone      | +41 21 619 10 18             |
      | street     | PSE-A, EPF                   |
      | partner_id | by oid: scen.customer_4      |


  Scenario: Customer_4
    Given I need a "res.partner" with oid: scen.customer_4
    And having:
      | name                       | value              |
      | name                       | customer_4         |
      | customer                   | 1                  |
      | property_account_payable   | by name: Creditors |
      | property_account_receivable| by name: Debtors   |
      
    Given I need a "res.partner.address" with oid: scen.customer_4_add
    And having:
      | name       | value                        |
      | name       | Maxime Wiot                  |
      | zip        | 1456                         |
      | city       | Neuchatel                    |
      | email      | openerp@locahost.dummy       |
      | phone      | +33 21 619 20 88             |
      | street     | PSE-A, EPF                   |
      | partner_id | by oid: scen.customer_4      |

  Scenario: Customer_5
    Given I need a "res.partner" with oid: scen.customer_5
    And having:
      | name                       | value              |
      | name                       | customer_5_usd     |
      | customer                   | 1                  |
      | property_account_payable   | by name: Creditors USD |
      | property_account_receivable| by name: Debtors USD   |
      
    Given I need a "res.partner.address" with oid: scen.customer_5_add
    And having:
      | name       | value                        |
      | name       | Barack Obama                 |
      | zip        | 20500                        |
      | city       | Washington, DC               |
      | email      | openerp@locahost.dummy       |
      | phone      | +01 21 619 20 88             |
      | street     | 1600 Pennsylvania Ave        |
      | partner_id | by oid: scen.customer_5      |

