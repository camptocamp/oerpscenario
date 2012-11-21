###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Copyright 2009 Camptocamp SA
#
##############################################################################
##############################################################################
# Branch      # Module       # Processes     # System
@base_finance   @base_commercial_management 

Feature: CUSTOMER & SUPPLIER CREATION
   @partner
  Scenario: Partner_1
    Given I need a "res.partner" with oid: scen.partner_1
    And having:
      | name                       | value                              |
      | name                       | partner_1                          |
      | customer                   | 1                                  |
      | supplier                   | 1                                  |
      | lang                       | fr_FR                              |
      | property_account_payable   | by name: Creditors                 |
      | property_account_receivable| by name: Debtors                   |
      | property_payment_term      | by name: 30 Net Days               |    
      
    Given I need a "res.partner.address" with oid: scen.partner_1_add
    And having:
      | name       | value                        |
      | type       | default                      |
      | name       | Luc Maurer                   |
      | zip        | 1015                         |
      | city       | lausanne                     |
      | email      | partner_1@camptocamp.com     |
      | phone      | +41 21 619 10 12             |
      | street     | PSE-A, EPF                   |
      | partner_id | by oid: scen.partner_1       |

    Given I need a "res.partner.address" with oid: scen.partner_1_add_inv
    And having:
      | name       | value                        |
      | type       | invoice                      |
      | name       | Stéphanie Debayle            |
      | zip        | 1015                         |
      | city       | lausanne                     |
      | email      | partner_1_stephanie@camptocamp.com     |
      | phone      | +41 21 619 10 12             |
      | street     | PSE-A, EPF                   |
      | partner_id | by oid: scen.partner_1       |

  Scenario: Supplier_1
    Given I need a "res.partner" with oid: scen.supplier_1
    And having:
      | name                       | value                              |
      | name                       | supplier_1                         |
      | supplier                   | 1                                  |
      | property_account_payable   | by name: Creditors                 |
      | property_account_receivable| by name: Debtors                   |
      | property_payment_term      | by name: 30 Net Days               |    
      
      
    Given I need a "res.partner.address" with oid: scen.supplier_1_add
    And having:
      | name       | value                        |
      | type       | default                      |
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
      | name                       | value                              |
      | name                       | supplier_2                         |
      | supplier                   | 1                                  |
      | property_account_payable   | by name: Creditors                 |
      | property_account_receivable| by name: Debtors                   |
      | property_payment_term      | by name: 30% Advance End 30 Days   |    
      
    Given I need a "res.partner.address" with oid: scen.supplier_2_add
    And having:
      | name       | value                        |
      | type       | default                      |      
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
      | name                       | value                              |
      | name                       | supplier_3                         |
      | supplier                   | 1                                  |
      | lang                       | fr_FR                              |      
      | property_account_payable   | by name: Creditors                 |
      | property_account_receivable| by name: Debtors                   |
      | property_payment_term      | by name: 30 Days End of Month      |     
      
    Given I need a "res.partner.address" with oid: scen.supplier_3_add
    And having:
      | name       | value                        |
      | type       | default                      |      
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
      | name                       | value                              |
      | name                       | supplier_4_usd                     |
      | supplier                   | 1                                  |
      | lang                       | en_US                              |      
      | property_account_payable   | by name: Creditors USD             |
      | property_account_receivable| by name: Debtors USD               |
      | property_payment_term      | by name: 30 Net Days               |    
      
    Given I need a "res.partner.address" with oid: scen.supplier_4_add
    And having:
      | name       | value                        |
      | type       | default                      |      
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
      | name                       | value                              |
      | name                       | customer_1                         |
      | customer                   | 1                                  |
      | lang                       | fr_FR                              |      
      | property_account_payable   | by name: Creditors                 |
      | property_account_receivable| by name: Debtors                   |
      | property_payment_term      | by name: 30 Net Days               |    
      
    Given I need a "res.partner.address" with oid: scen.customer_1_add
    And having:
      | name       | value                        |
      | type       | default                      |      
      | name       | Guewen Baconnier             |
      | zip        | 1800                         |
      | city       | Orbe                         |
      | email      | customer_1@camptocamp.com    |
      | phone      | +41 21 619 10 13             |
      | street     | PSE-A, EPF                   |
      | partner_id | by oid: scen.customer_1      |

  Scenario: Customer_2
    Given I need a "res.partner" with oid: scen.customer_2
    And having:
      | name                       | value                              |
      | name                       | customer_2                         |
      | lang                       | fr_FR                              |      
      | customer                   | 1                                  |
      | property_account_payable   | by name: Creditors                 |
      | property_account_receivable| by name: Debtors                   |
      | property_payment_term      | by name: 30% Advance End 30 Days   |    
      
    Given I need a "res.partner.address" with oid: scen.customer_2_add
    And having:
      | name       | value                        |
      | type       | default                      |      
      | name       | Nicolas Bessi                |
      | zip        | 1456                         |
      | city       | Pentalaz                     |
      | email      | customer_2@camptocamp.com    |
      | phone      | +41 21 619 10 16             |
      | street     | PSE-A, EPF                   |
      | partner_id | by oid: scen.customer_2      |

  Scenario: Customer_3
    Given I need a "res.partner" with oid: scen.customer_3
    And having:
      | name                       | value                              |
      | name                       | customer_3                         |
      | lang                       | fr_FR                              |      
      | customer                   | 1                                  |
      | property_account_payable   | by name: Creditors                 |
      | property_account_receivable| by name: Debtors                   |
  
      
    Given I need a "res.partner.address" with oid: scen.customer_3_add
    And having:
      | name       | value                        |
      | type       | default                      |      
      | name       | Yannick Vauchet              |
      | zip        | 1456                         |
      | city       | Neuchatel                    |
      | email      | customer_3@camptocamp.com    |
      | phone      | +41 21 619 10 18             |
      | street     | PSE-A, EPF                   |
      | partner_id | by oid: scen.customer_3      |

  Scenario: Customer_4
    Given I need a "res.partner" with oid: scen.customer_4
    And having:
      | name                       | value                              |
      | name                       | customer_4                         |
      | customer                   | 1                                  |
      | lang                       | fr_FR                              |      
      | property_account_payable   | by name: Creditors                 |
      | property_account_receivable| by name: Debtors                   |
      | property_payment_term      | by name: 30 Net Days               |    
      
    Given I need a "res.partner.address" with oid: scen.customer_4_add
    And having:
      | name       | value                        |
      | type       | default                      |      
      | name       | Alexandre Fayolle            |
      | zip        | 1456                         |
      | city       | Neuchatel                    |
      | email      | customer_4@camptocamp.com    |
      | phone      | +41 21 619 10 18             |
      | street     | PSE-A, EPF                   |
      | partner_id | by oid: scen.customer_4      |


  Scenario: Customer_5
    Given I need a "res.partner" with oid: scen.customer_5
    And having:
      | name                       | value                              |
      | name                       | customer_5_usd                     |
      | customer                   | 1                                  |
      | lang                       | en_US                              |      
      | property_account_payable   | by name: Creditors USD             |
      | property_account_receivable| by name: Debtors USD               |
      | property_payment_term      | by name: 30 Days End of Month      |    
      
    Given I need a "res.partner.address" with oid: scen.customer_5_add
    And having:
      | name       | value                        |
      | type       | default                      |      
      | name       | Barack Obama                 |
      | zip        | 20500                        |
      | city       | Washington, DC               |
      | email      | customer_5@camptocamp.com    |
      | phone      | +01 21 619 20 88             |
      | street     | 1600 Pennsylvania Ave        |
      | partner_id | by oid: scen.customer_5      |


  Scenario: Customer_6
    Given I need a "res.partner" with oid: scen.customer_6
    And having:
      | name                       | value                              |
      | name                       | customer_6                         |
      | customer                   | 1                                  |
      | lang                       | en_US                              |      
      | property_account_payable   | by name: Creditors                 |
      | property_account_receivable| by name: Debtors                   |
      | property_payment_term      | by name: 30 Days End of Month|          
      
    Given I need a "res.partner.address" with oid: scen.customer_6_add
    And having:
      | name       | value                        |
      | type       | default                      |      
      | name       | Maxime Wiot                  |
      | zip        | 1456                         |
      | city       | Neuchatel                    |
      | email      | customer_6@camptocamp.com    |
      | phone      | +33 21 619 20 88             |
      | street     | PSE-A, EPF                   |
      | partner_id | by oid: scen.customer_6      |