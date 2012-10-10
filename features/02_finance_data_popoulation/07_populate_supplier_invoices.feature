###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Copyright 2009 Camptocamp SA
#
##############################################################################
##############################################################################
# Branch      # Module       # Processes     # System
@addons     @invoices    @purchases_invoices  


Feature: PURCHASES INVOICES POPULATION

  @inv_PI1
  Scenario: Create supplier invoice PI1
  Given I need a "account.invoice" with oid: scen.purchases_inv_PI1
    And having:
      | name               | value                              |
      | name               | PI_PI1                             |
      | date_invoice       | %Y-01-15                           |
      | address_invoice_id | by oid: scen.partner_1_add         |
      | partner_id         | by oid: scen.partner_1             |
      | account_id         | by name: Creditors                 |
      | journal_id         | by name: Purchases                 |
      | currency_id        | by name: USD                       |
      | type               | in_invoice                         |

    Given I need a "account.invoice.line" with oid: scen.purchases_invPI1_line1
    And having:
      | name       | value                                      |
      | name       | invoice line PI1                           |
      | quantity   | 1                                          |
      | price_unit | 1000                                       |
      | account_id | by name: Purchases                         |
      | invoice_id | by oid:scen.purchases_inv_PI1              |
      | invoice_line_tax_id | all by oid: scen.purchases_vat_10 |    
      
    Given I need a "account.invoice.line" with oid: scen.purchases_invPI1_line2
    And having:
      | name       | value                                      |
      | name       | invoice line 2 PI1                         |
      | quantity   | 1                                          |
      | price_unit | 1000                                       |
      | account_id | by name: Purchases                         |
      | invoice_id | by oid:scen.purchases_inv_PI1              |
      | invoice_line_tax_id | all by oid: scen.purchases_vat_20 |                      
    Given I find a "account.invoice" with oid: scen.purchases_inv_PI1
    And I open the supplier invoice
    

  @inv_PI2
  Scenario: Create supplier invoice PI2
  Given I need a "account.invoice" with oid: scen.purchases_inv_PI2
    And having:
      | name               | value                              |
      | name               | PI_PI2                             |
      | date_invoice       | %Y-02-15                           |
      | address_invoice_id | by oid: scen.partner_1_add         |
      | partner_id         | by oid: scen.partner_1             |
      | account_id         | by name: Creditors                 |
      | journal_id         | by name: Purchases                 |
      | currency_id        | by name: USD                       |
      | type               | in_invoice                         |


    Given I need a "account.invoice.line" with oid: scen.purchases_invPI2_line1
    And having:
      | name       | value                                      |
      | name       | invoice line PI2                           |
      | quantity   | 1                                          |
      | price_unit | 1000                                       |
      | account_id | by name: Purchases                         |
      | invoice_id | by oid:scen.purchases_inv_PI2              |
      | invoice_line_tax_id | all by oid: scen.purchases_vat_20 |        
    Given I find a "account.invoice" with oid: scen.purchases_inv_PI2
    And I open the supplier invoice
    

  @inv_PI3
  Scenario: Create supplier invoice PI3
  Given I need a "account.invoice" with oid: scen.purchases_inv_PI3
    And having:
      | name               | value                              |
      | name               | PI_PI3                             |
      | date_invoice       | %Y-03-15                           |
      | address_invoice_id | by oid: scen.partner_1_add         |
      | partner_id         | by oid: scen.partner_1             |
      | account_id         | by name: Creditors                 |
      | journal_id         | by name: Purchases                 |
      | currency_id        | by name: USD                       |
      | type               | in_invoice                         |


    Given I need a "account.invoice.line" with oid: scen.purchases_invPI3_line1
    And having:
      | name       | value                                      |
      | name       | invoice line PI3                           |
      | quantity   | 1                                          |
      | price_unit | 1000                                       |
      | account_id | by name: Purchases                         |
      | invoice_id | by oid:scen.purchases_inv_PI3              |
      | invoice_line_tax_id | all by oid: scen.purchases_vat_10 |        
    Given I find a "account.invoice" with oid: scen.purchases_inv_PI3
    And I open the supplier invoice
    
  @inv_PI4
  Scenario: Create supplier invoice PI4
  Given I need a "account.invoice" with oid: scen.purchases_inv_PI4
    And having:
      | name               | value                              |
      | name               | PI_PI4                             |
      | date_invoice       | %Y-01-20                           |
      | address_invoice_id | by oid: scen.partner_1_add         |
      | partner_id         | by oid: scen.partner_1             |
      | account_id         | by name: Creditors                 |
      | journal_id         | by name: Purchases                 |
      | currency_id        | by name: EUR                       |
      | type               | in_invoice                         |


    Given I need a "account.invoice.line" with oid: scen.purchases_invPI4_line1
    And having:
      | name       | value                                      |
      | name       | invoice line PI4                           |
      | quantity   | 1                                          |
      | price_unit | 1000                                       |
      | account_id | by name: Purchases                         |
      | invoice_id | by oid:scen.purchases_inv_PI4              |
      | invoice_line_tax_id | all by oid: scen.purchases_vat_20 |        
    Given I find a "account.invoice" with oid: scen.purchases_inv_PI4
    And I open the supplier invoice
    

  @inv_PI5
  Scenario: Create supplier invoice PI5
  Given I need a "account.invoice" with oid: scen.purchases_inv_PI5
    And having:
      | name               | value                              |
      | name               | PI_PI5                             |
      | date_invoice       | %Y-02-20                           |
      | address_invoice_id | by oid: scen.partner_1_add         |
      | partner_id         | by oid: scen.partner_1             |
      | account_id         | by name: Creditors                 |
      | journal_id         | by name: Purchases                 |
      | currency_id        | by name: EUR                       |
      | type               | in_invoice                         |


    Given I need a "account.invoice.line" with oid: scen.purchases_invPI5_line1
    And having:
      | name       | value                                      |
      | name       | invoice line PI5                           |
      | quantity   | 1                                          |
      | price_unit | 1000                                       |
      | account_id | by name: Purchases                         |
      | invoice_id | by oid:scen.purchases_inv_PI5              |
      | invoice_line_tax_id | all by oid: scen.purchases_vat_10 |        
    Given I find a "account.invoice" with oid: scen.purchases_inv_PI5
    And I open the supplier invoice
    

  @inv_PI6
  Scenario: Create supplier invoice PI6
  Given I need a "account.invoice" with oid: scen.purchases_inv_PI6
    And having:
      | name               | value                              |
      | name               | PI_PI6                             |
      | date_invoice       | %Y-03-20                           |
      | address_invoice_id | by oid: scen.partner_1_add         |
      | partner_id         | by oid: scen.partner_1             |
      | account_id         | by name: Creditors                 |
      | journal_id         | by name: Purchases                 |
      | currency_id        | by name: EUR                       |
      | type               | in_invoice                         |


    Given I need a "account.invoice.line" with oid: scen.purchases_invPI6_line1
    And having:
      | name       | value                                      |
      | name       | invoice line PI6                           |
      | quantity   | 1                                          |
      | price_unit | 1000                                       |
      | account_id | by name: Purchases                         |
      | invoice_id | by oid:scen.purchases_inv_PI6              |
      | invoice_line_tax_id | all by oid: scen.purchases_vat_20 |        
    Given I find a "account.invoice" with oid: scen.purchases_inv_PI6
    And I open the supplier invoice


