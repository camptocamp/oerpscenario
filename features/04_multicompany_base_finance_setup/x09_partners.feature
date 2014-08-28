###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Copyright 2009 Camptocamp SA
#
##############################################################################
##############################################################################
# Branch      # Module       # Processes     # System
@multicompany_base_finance

Feature: CUSTOMER & SUPPLIER CREATION
   @multicompany_base_finance_partner
  Scenario: Partner_1
    Given I need a "res.partner" with oid: scen.partner_1
    And having:
      | name                        | value                                 |
      | name                        | partner_1                             |
      | is_company                  | true                                  |
      | customer                    | 1                                     |
      | supplier                    | 1                                     |
      | lang                        | fr_FR                                 |
      | property_account_payable    | by name: Creditors                    |
      | property_account_receivable | by name: Debtors                      |
      | property_payment_term       | by name: 30 Net Days                  |
      | type                        | default                               |
      | street                      | PSE-A, EPF                            |
      | zip                         | 1015                                  |
      | city                        | lausanne                              |
      | email                       | partner_1@camptocamp.com              |
      | phone                       | +41 21 619 10 12                      |

    Given I need a "res.partner" with oid: scen.partner_1_add_del
    And having:
      | name                        | value                                 |
      | name                        | Luc Maurer                            |
      | is_company                  | false                                 |
      | parent_id                   | by name: partner_1                    |
      | customer                    | 1                                     |
      | supplier                    | 1                                     |
      | lang                        | fr_FR                                 |
      | property_account_payable    | by name: Creditors                    |
      | property_account_receivable | by name: Debtors                      |
      | property_payment_term       | by name: 30 Net Days                  |
      | type                        | delivery                              |
      | use_parent_address          | true                                  |

    Given I need a "res.partner" with oid: scen.partner_1_add_inv
    And having:
      | name                        | value                                 |
      | type                        | invoice                               |
      | name                        | Stéphanie Debayle                     |
      | zip                         | 1015                                  |
      | city                        | lausanne                              |
      | email                       | partner_1_stephanie@camptocamp.com    |
      | phone                       | +41 21 619 10 12                      |
      | street                      | PSE-A, EPF                            |
      | parent_id                   | by name: partner_1                    |


  Scenario: Supplier_1
    Given I need a "res.partner" with oid: scen.supplier_1
    And having:
      | name                        | value                                 |
      | name                        | supplier_1                            |
      | is_company                  | true                                  |
      | supplier                    | 1                                     |
      | property_account_payable    | by name: Creditors                    |
      | property_account_receivable | by name: Debtors                      |
      | property_payment_term       | by name: 30 Net Days                  |
      | zip                         | 1030                                  |
      | city                        | Bussigny                              |
      | email                       | openerp@locahost.dummy                |
      | phone                       | +41 21 619 10 13                      |
      | street                      | PSE-A, EPF                            |

    Given I need a "res.partner" with oid: scen.supplier_1_add
    And having:
      | name                        | value                                 |
      | type                        | default                               |
      | name                        | Frederic Clementi                     |
      | use_parent_address          | true                                  |
      | parent_id                   | by oid: scen.supplier_1               |


  Scenario: Supplier_2
    Given I need a "res.partner" with oid: scen.supplier_2
    And having:
      | name                        | value                                 |
      | name                        | supplier_2                            |
      | supplier                    | 1                                     |
      | property_account_payable    | by name: Creditors                    |
      | property_account_receivable | by name: Debtors                      |
      | property_payment_term       | by name: 30% Advance End 30 Days      |
      | zip                         | 1005                                  |
      | city                        | Lausanne                              |
      | email                       | openerp@locahost.dummy                |
      | phone                       | +41 21 619 10 13                      |
      | street                      | PSE-A, EPF                            |

    Given I need a "res.partner" with oid: scen.supplier_2_add
    And having:
      | name                        | value                                 |
      | type                        | default                               |
      | name                        | Vincent Renaville                     |
      | use_parent_address          | true                                  |
      | parent_id                   | by oid: scen.supplier_2               |


  Scenario: Supplier_3
    Given I need a "res.partner" with oid: scen.supplier_3
    And having:
      | name                        | value                                 |
      | name                        | supplier_3                            |
      | supplier                    | 1                                     |
      | lang                        | fr_FR                                 |
      | property_account_payable    | by name: Creditors                    |
      | property_account_receivable | by name: Debtors                      |
      | property_payment_term       | by name: 30 Days End of Month         |
      | zip                         | 1900                                  |
      | city                        | Neuchatel                             |
      | email                       | openerp@locahost.dummy                |
      | phone                       | +41 21 619 10 15                      |
      | street                      | PSE-A, EPF                            |

    Given I need a "res.partner" with oid: scen.supplier_3_add
    And having:
      | name                        | value                                 |
      | type                        | default                               |
      | name                        | Joel Grandguillaume                   |
      | use_parent_address          | true                                  |
      | parent_id                   | by oid: scen.supplier_3               |


  Scenario: Supplier_4 en USD
    Given I need a "res.partner" with oid: scen.supplier_4_usd
    And having:
      | name                        | value                                 |
      | name                        | supplier_4_usd                        |
      | supplier                    | 1                                     |
      | lang                        | en_US                                 |
      | property_account_payable    | by name: Creditors USD                |
      | property_account_receivable | by name: Debtors USD                  |
      | property_payment_term       | by name: 30 Net Days                  |
      | zip                         | 1900                                  |
      | city                        | Neuchatel                             |
      | email                       | openerp@locahost.dummy                |
      | phone                       | +41 21 619 10 15                      |
      | street                      | PSE-A, EPF                            |

    Given I need a "res.partner" with oid: scen.supplier_4_add
    And having:
      | name                        | value                                 |
      | type                        | default                               |
      | name                        | Robert Johnson                        |
      | use_parent_address          | true                                  |
      | parent_id                   | by oid: scen.supplier_3               |


  Scenario: Customer_1
    Given I need a "res.partner" with oid: scen.customer_1
    And having:
      | name                        | value                                 |
      | name                        | customer_1                            |
      | customer                    | 1                                     |
      | lang                        | fr_FR                                 |
      | property_account_payable    | by name: Creditors                    |
      | property_account_receivable | by name: Debtors                      |
      | property_payment_term       | by name: 30 Net Days                  |
      | zip                         | 1800                                  |
      | city                        | Orbe                                  |
      | email                       | customer_1@camptocamp.com             |
      | phone                       | +41 21 619 10 13                      |
      | street                      | PSE-A, EPF                            |

    Given I need a "res.partner" with oid: scen.customer_1_add
    And having:
      | name                        | value                                 |
      | type                        | default                               |
      | name                        | Guewen Baconnier                      |
      | use_parent_address          | true                                  |
      | parent_id                   | by oid: scen.customer_1               |


  Scenario: Customer_2
    Given I need a "res.partner" with oid: scen.customer_2
    And having:
      | name                        | value                                 |
      | name                        | customer_2                            |
      | lang                        | fr_FR                                 |
      | customer                    | 1                                     |
      | property_account_payable    | by name: Creditors                    |
      | property_account_receivable | by name: Debtors                      |
      | property_payment_term       | by name: 30% Advance End 30 Days      |
      | zip                         | 1456                                  |
      | city                        | Pentalaz                              |
      | email                       | customer_2@camptocamp.com             |
      | phone                       | +41 21 619 10 16                      |
      | street                      | PSE-A, EPF                            |

    Given I need a "res.partner" with oid: scen.customer_2_add
    And having:
      | name                        | value                                 |
      | type                        | default                               |
      | name                        | Nicolas Bessi                         |
      | use_parent_address          | true                                  |
      | parent_id                   | by oid: scen.customer_2               |


  Scenario: Customer_3
    Given I need a "res.partner" with oid: scen.customer_3
    And having:
      | name                        | value                                 |
      | name                        | customer_3                            |
      | lang                        | fr_FR                                 |
      | customer                    | 1                                     |
      | property_account_payable    | by name: Creditors                    |
      | property_account_receivable | by name: Debtors                      |
      | zip                         | 1456                                  |
      | city                        | Neuchatel                             |
      | email                       | customer_3@camptocamp.com             |
      | phone                       | +41 21 619 10 18                      |
      | street                      | PSE-A, EPF                            |

    Given I need a "res.partner" with oid: scen.customer_3_add
    And having:
      | name                        | value                                 |
      | type                        | default                               |
      | name                        | Yannick Vauchet                       |
      | use_parent_address          | true                                  |
      | parent_id                   | by oid: scen.customer_3               |


  Scenario: Customer_4
    Given I need a "res.partner" with oid: scen.customer_4
    And having:
      | name                        | value                                 |
      | name                        | customer_4                            |
      | customer                    | 1                                     |
      | lang                        | fr_FR                                 |
      | property_account_payable    | by name: Creditors                    |
      | property_account_receivable | by name: Debtors                      |
      | property_payment_term       | by name: 30 Net Days                  |
      | zip                         | 1456                                  |
      | city                        | Neuchatel                             |
      | email                       | customer_4@camptocamp.com             |
      | phone                       | +41 21 619 10 18                      |
      | street                      | PSE-A, EPF                            |

    Given I need a "res.partner" with oid: scen.customer_4_add
    And having:
      | name                        | value                                 |
      | type                        | default                               |
      | name                        | Alexandre Fayolle                     |
      | use_parent_address          | true                                  |
      | parent_id                   | by oid: scen.customer_4               |


  Scenario: Customer_5
    Given I need a "res.partner" with oid: scen.customer_5
    And having:
      | name                        | value                                 |
      | name                        | customer_5_usd                        |
      | customer                    | 1                                     |
      | lang                        | en_US                                 |
      | property_account_payable    | by name: Creditors USD                |
      | property_account_receivable | by name: Debtors USD                  |
      | property_payment_term       | by name: 30 Days End of Month         |
      | zip                         | 20500                                 |
      | city                        | Washington, DC                        |
      | email                       | customer_5@camptocamp.com             |
      | phone                       | +01 21 619 20 88                      |
      | street                      | 1600 Pennsylvania Ave                 |

    Given I need a "res.partner" with oid: scen.customer_5_add
    And having:
      | name                        | value                                 |
      | type                        | default                               |
      | name                        | Barack Obama                          |
      | use_parent_address          | true                                  |
      | parent_id                   | by oid: scen.customer_5               |


  Scenario: Customer_6
    Given I need a "res.partner" with oid: scen.customer_6
    And having:
      | name                        | value                                 |
      | name                        | customer_6                            |
      | customer                    | 1                                     |
      | lang                        | en_US                                 |
      | property_account_payable    | by name: Creditors                    |
      | property_account_receivable | by name: Debtors                      |
      | property_payment_term       | by name: 30 Days End of Month         |
      | zip                         | 1456                                  |
      | city                        | Chambérix                             |
      | email                       | customer_6@camptocamp.com             |
      | phone                       | +33 21 619 20 88                      |
      | street                      | PSE-A, EPF                            |

    Given I need a "res.partner" with oid: scen.customer_6_add
    And having:
      | name                        | value                                 |
      | type                        | default                               |
      | name                        | Maxime Wiot                           |
      | use_parent_address          | true                                  |
      | parent_id                   | by oid: scen.customer_6               |