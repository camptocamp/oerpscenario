###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Copyright 2009 Camptocamp SA
#
##############################################################################
##############################################################################
# Branch      # Module       # Processes     # System
@addons     @invoices    @sales_invoices  


Feature: SALES INVOICES POPULATION
   
  @inv_SI1
  Scenario: Create customer invoice SI1
  Given I need a "account.invoice" with oid: scen.sales_inv_SI1
    And having:
      | name               | value                              |
      | name               | SI_SI1                             |
      | date_invoice       | %Y-01-15                           |
      | partner_id         | by oid: scen.partner_1             |
      | address_invoice_id | by oid: scen.partner_1_add         |      
      | account_id         | by name: Debtors                   |
      | journal_id         | by name: Sales                     |
      | currency_id        | by name: EUR                       |
      | payment_term       | by name: 30 Net Days               | 
      | type               | out_invoice                        |


    Given I need a "account.invoice.line" with oid: scen.sales_invSI1_line1
    And having:
      | name       | value                                      |
      | name       | invoice line 1 SI1                         |
      | quantity   | 1                                          |
      | price_unit | 1000                                       |
      | account_id | by name: Sales                             |
      | invoice_id | by oid:scen.sales_inv_SI1                  |
      | invoice_line_tax_id | all by oid: scen.sales_vat_10     |            
    Given I need a "account.invoice.line" with oid: scen.sales_invSI1_line2
    And having:
      | name       | value                                      |
      | name       | invoice line 2 SI1                         |
      | quantity   | 1                                          |
      | price_unit | 1000                                       |
      | account_id | by name: Sales                             |
      | invoice_id | by oid:scen.sales_inv_SI1                  |
      | invoice_line_tax_id | all by oid: scen.sales_vat_20     |            
    Given I find a "account.invoice" with oid: scen.sales_inv_SI1
    And I open the customer invoice
    

  @inv_SI2
  Scenario: Create customer invoice SI2
  Given I need a "account.invoice" with oid: scen.sales_inv_SI2
    And having:
      | name               | value                              |
      | name               | SI_SI2                             |
      | date_invoice       | %Y-02-15                           |
      | partner_id         | by oid: scen.customer_1            |
      | address_invoice_id | by oid: scen.customer_1_add        |      
      | account_id         | by name: Debtors                   |
      | journal_id         | by name: Sales                     |
      | currency_id        | by name: EUR                       |
      | payment_term       | by name: 30 Net Days               |       
      | type               | out_invoice                        |


    Given I need a "account.invoice.line" with oid: scen.sales_invSI2_line1
    And having:
      | name       | value                                      |
      | name       | invoice line 1 SI2                         |
      | quantity   | 1                                          |
      | price_unit | 1000                                       |
      | account_id | by name: Sales                             |
      | invoice_id | by oid:scen.sales_inv_SI2                  |
      | invoice_line_tax_id | all by oid: scen.sales_vat_20     |            
            
    Given I find a "account.invoice" with oid: scen.sales_inv_SI2
    And I open the customer invoice
    

  @inv_SI3
  Scenario: Create customer invoice SI3
  Given I need a "account.invoice" with oid: scen.sales_inv_SI3
    And having:
      | name               | value                              |
      | name               | SI_SI3                             |
      | date_invoice       | %Y-03-15                           |
      | partner_id         | by oid: scen.customer_2            |
      | address_invoice_id | by oid: scen.customer_2_add        |         
      | account_id         | by name: Debtors                   |
      | journal_id         | by name: Sales                     |
      | currency_id        | by name: EUR                       |
      | payment_term       | by name: 30% Advance End 30 Days   |    
      | type               | out_invoice                        |
      | invoice_line_tax_id | all by oid: scen.sales_vat_20     | 

    Given I need a "account.invoice.line" with oid: scen.sales_invSI3_line1
    And having:
      | name       | value                                      |
      | name       | invoice line 1 SI3                         |
      | quantity   | 1                                          |
      | price_unit | 1000                                       |
      | account_id | by name: Sales                             |
      | invoice_id | by oid:scen.sales_inv_SI3                  |
    Given I find a "account.invoice" with oid: scen.sales_inv_SI3
    And I open the customer invoice
  
  @inv_SI4
  Scenario: Create customer invoice SI4
  Given I need a "account.invoice" with oid: scen.sales_inv_SI4
    And having:
      | name               | value                              |
      | name               | SI_SI4                             |
      | date_invoice       | %Y-01-20                           |
      | partner_id         | by oid: scen.customer_5            |
      | address_invoice_id | by oid: scen.customer_5_add        |        
      | account_id         | by name: Debtors                   |
      | journal_id         | by name: Sales                     |
      | currency_id        | by name: USD                       |
      | payment_term       | by name: 30 Days End of Month      |         
      | type               | out_invoice                        |
      | invoice_line_tax_id | all by oid: scen.sales_vat_20     | 

    Given I need a "account.invoice.line" with oid: scen.sales_invSI4_line1
    And having:
      | name       | value                                      |
      | name       | invoice line 1 SI4                         |
      | quantity   | 1                                          |
      | price_unit | 1000                                       |
      | account_id | by name: Sales                             |
      | invoice_id | by oid:scen.sales_inv_SI4                  |
    Given I find a "account.invoice" with oid: scen.sales_inv_SI4
    And I open the customer invoice
    

  @inv_SI5
  Scenario: Create customer invoice SI5
  Given I need a "account.invoice" with oid: scen.sales_inv_SI5
    And having:
      | name               | value                              |
      | name               | SI_SI5                             |
      | date_invoice       | %Y-02-20                           |
      | partner_id         | by oid: scen.customer_2            |
      | address_invoice_id | by oid: scen.customer_2_add        |        
      | account_id         | by name: Debtors                   |
      | journal_id         | by name: Sales                     |
      | currency_id        | by name: USD                       |
      | payment_term       | by name: 30 Net Days               |       
      | type               | out_invoice                        |
      | invoice_line_tax_id | all by oid: scen.sales_vat_20     | 

    Given I need a "account.invoice.line" with oid: scen.sales_invSI5_line1
    And having:
      | name       | value                                      |
      | name       | invoice line 1 SI5                         |
      | quantity   | 1                                          |
      | price_unit | 1000                                       |
      | account_id | by name: Sales                             |
      | invoice_id | by oid:scen.sales_inv_SI5                  |
    Given I find a "account.invoice" with oid: scen.sales_inv_SI5
    And I open the customer invoice
    

  @inv_SI6
  Scenario: Create customer invoice SI6
  Given I need a "account.invoice" with oid: scen.sales_inv_SI6
    And having:
      | name               | value                              |
      | name               | SI_SI6                             |
      | date_invoice       | %Y-03-20                           |
      | partner_id         | by oid: scen.customer_5            |
      | address_invoice_id | by oid: scen.customer_5_add        |        
      | account_id         | by name: Debtors                   |
      | journal_id         | by name: Sales                     |
      | currency_id        | by name: USD                       |
      | payment_term       | by name: 30 Net Days               |       
      | type               | out_invoice                        |


    Given I need a "account.invoice.line" with oid: scen.sales_invSI6_line1
    And having:
      | name       | value                                      |
      | name       | invoice line 1 SI6                         |
      | quantity   | 1                                          |
      | price_unit | 1000                                       |
      | account_id | by name: Sales                             |
      | invoice_id | by oid:scen.sales_inv_SI6                  |
    Given I find a "account.invoice" with oid: scen.sales_inv_SI6
    And I open the customer invoice  



