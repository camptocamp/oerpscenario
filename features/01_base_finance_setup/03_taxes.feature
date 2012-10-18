###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Copyright 2009 Camptocamp SA
#
##############################################################################
##############################################################################
# Branch      # Module       # Processes     # System
@base_finance   @base_commercial_management 

Feature: GENERIC CHART OF TAXES & GENERIC CHART OF TAX CODES

  @base_taxes
  Scenario: GENERIC CHART OF TAX CODES
 
# CHART ROOT
 
       Given I need a "account.tax.code" with oid: scen.taxe_code_root
    And having:
    | name                  | value                         |
    | name                  | Chart of tax codes            |
 
# VAT

      Given I need a "account.tax.code" with oid: scen.taxe_code_vat
    And having:
    | name                  | value                         |
    | name                  | VAT to pay                    |
    | parent_id             | by oid: scen.taxe_code_root   |  
  
    Given I need a "account.tax.code" with oid: scen.taxe_code_purchases_vat
    And having:
    | name                  | value                         |
    | name                  | VAT / Purchases               |
    | parent_id             | by oid: scen.taxe_code_vat    |
    
     Given I need a "account.tax.code" with oid: scen.taxe_code_sales_vat_10
    And having:
    | name                  | value                         |
    | name                  | VAT / Sales 10%               |
    | parent_id             | by oid: scen.taxe_code_vat    |
    
     Given I need a "account.tax.code" with oid: scen.taxe_code_sales_vat_20
    And having:
    | name                  | value                         |
    | name                  | VAT / Sales 20%               |
    | parent_id             | by oid: scen.taxe_code_vat    |

    Given I need a "account.tax.code" with oid: scen.taxe_code_EU_purchases_vat
    And having:
    | name                  | value                         |
    | name                  | VAT / Purchases               |
    | parent_id             | by oid: scen.taxe_code_vat    |

    Given I need a "account.tax.code" with oid: scen.taxe_code_EU_purchases_rev_vat
    And having:
    | name                  | value                         |
    | name                  | VAT / Purchases               |
    | parent_id             | by oid: scen.taxe_code_vat    |

# VAT Bases

     Given I need a "account.tax.code" with oid: scen.taxe_code_base
    And having:
    | name                  | value                         |
    | name                  | Base                          |
    | parent_id             | by oid: scen.taxe_code_root   |  
        
     Given I need a "account.tax.code" with oid: scen.taxe_code_sales_base_10
    And having:
    | name                  | value                         |
    | name                  | Sales at 10%                  |
    | parent_id             | by oid: scen.taxe_code_base   |
    
     Given I need a "account.tax.code" with oid: scen.taxe_code_sales_base_20
    And having:
    | name                  | value                         |
    | name                  | Sales at 20%                  |
    | parent_id             | by oid: scen.taxe_code_base   |
    
     Given I need a "account.tax.code" with oid: scen.taxe_code_base_EU_purchases
    And having:
    | name                  | value                         |
    | name                  | EU purchases                  |
    | parent_id             | by oid: scen.taxe_code_base   |  


  @base_taxes
  Scenario: GENERIC CHART OF TAXES
    Given I need a "account.tax" with oid: scen.purchases_vat_10
    And having:
    | name                  | value                                     |
    | name                  | Purchases VAT 10%                         |
    | description           | P10                                       |
    | type_tax_use          | purchase                                  |
    | type                  | percent                                   |   
    | amount                | 0.1                                       |       
    | account_collected_id  | by oid: scen.acc_purchases_vat            |
    | account_paid_id       | by oid: scen.acc_purchases_vat            |
    | tax_code_id           | by oid: scen.taxe_code_purchases_vat      |    
    | tax_sign              | -1                                        |      
    | ref_tax_code_id       | by oid: scen.taxe_code_purchases_vat      |    
    | ref_tax_sign          | -1                                        |      
    
    
   Given I need a "account.tax" with oid: scen.purchases_vat_20
    And having:
    | name                  | value                                     |
    | name                  | Purchases VAT 20%                         |
    | description           | P20                                       |
    | type_tax_use          | purchase                                  |
    | type                  | percent                                   |   
    | amount                | 0.2                                       |       
    | account_collected_id  | by oid: scen.acc_purchases_vat            |
    | account_paid_id       | by oid: scen.acc_purchases_vat            |
    | tax_code_id           | by oid: scen.taxe_code_purchases_vat      |    
    | tax_sign              | -1                                        |      
    | ref_tax_code_id       | by oid: scen.taxe_code_purchases_vat      |    
    | ref_tax_sign          | -1                                        |


   Given I need a "account.tax" with oid: scen.purchases_vat_incl_20
    And having:
    | name                  | value                                     |
    | name                  | Purchases 20% VAT included                |
    | description           | P20_incl                                  |
    | price_include         | true                                      |    
    | type_tax_use          | purchase                                  |
    | type                  | percent                                   |   
    | amount                | 0.2                                       |       
    | account_collected_id  | by oid: scen.acc_purchases_vat            |
    | account_paid_id       | by oid: scen.acc_purchases_vat            | 
    | tax_code_id           | by oid: scen.taxe_code_purchases_vat      |    
    | tax_sign              | -1                                        |      
    | ref_tax_code_id       | by oid: scen.taxe_code_purchases_vat      |    
    | ref_tax_sign          | -1                                        |




    Given I need a "account.tax" with oid: scen.sales_vat_10
    And having:
    | name                  | value                                     |
    | name                  | Sales VAT 10%                             |
    | description           | S10                                       |
    | type_tax_use          | sale                                      |
    | type                  | percent                                   |   
    | amount                | 0.1                                       |       
    | account_collected_id  | by oid: scen.acc_sales_vat                |
    | account_paid_id       | by oid: scen.acc_sales_vat                |
    | base_code_id          | by oid: scen.taxe_code_sales_base_10      |    
    | base_sign             | 1                                         |      
    | tax_code_id           | by oid: scen.taxe_code_sales_vat_10       |    
    | tax_sign              | 1                                         |      
    | ref_base_code_id      | by oid: scen.taxe_code_sales_base_10      |    
    | ref_base_sign         | 1                                         |   
    | ref_tax_code_id       | by oid: scen.taxe_code_sales_vat_10       |     
    | ref_tax_sign          | 1                                         |    
     
    
   Given I need a "account.tax" with oid: scen.sales_vat_20
    And having:
    | name                  | value                                     |
    | name                  | Sales VAT 20%                             |
    | description           | S20                                       |
    | type_tax_use          | sale                                      |
    | type                  | percent                                   |   
    | amount                | 0.2                                       |       
    | account_collected_id  | by oid: scen.acc_sales_vat                |
    | account_paid_id       | by oid: scen.acc_sales_vat                |
    | base_code_id          | by oid: scen.taxe_code_sales_base_20      |    
    | base_sign             | 1                                         |      
    | tax_code_id           | by oid: scen.taxe_code_sales_vat_20       |    
    | tax_sign              | 1                                         |      
    | ref_base_code_id      | by oid: scen.taxe_code_sales_base_20      |    
    | ref_base_sign         | 1                                         |   
    | ref_tax_code_id       | by oid: scen.taxe_code_sales_vat_20       |     
    | ref_tax_sign          | 1                                         |  


   Given I need a "account.tax" with oid: scen.sales_vat_incl_20
    And having:
    | name                  | value                                     |
    | name                  | Sales 20% VAT included                    |
    | description           | P20_incl                                  |
    | price_include         | true                                      |    
    | type_tax_use          | sale                                      |
    | type                  | percent                                   |   
    | amount                | 0.2                                       |       
    | account_collected_id  | by oid: scen.acc_sales_vat                |
    | account_paid_id       | by oid: scen.acc_sales_vat                |    
    | base_code_id          | by oid: scen.taxe_code_sales_base_20      |    
    | base_sign             | 1                                         |      
    | tax_code_id           | by oid: scen.taxe_code_sales_vat_20       |    
    | tax_sign              | 1                                         |      
    | ref_base_code_id      | by oid: scen.taxe_code_sales_base_20      |    
    | ref_base_sign         | 1                                         |   
    | ref_tax_code_id       | by oid: scen.taxe_code_sales_vat_20       |     
    | ref_tax_sign          | 1                                         |     
    


   Given I need a "account.tax" with oid: scen.EU_purchases
    And having:
    | name                  | value                                     |
    | name                  | EU purchases_20%                          |
    | description           | EU_P20                                    |
    | price_include         | false                                     |    
    | type_tax_use          | purchase                                  |
    | type                  | percent                                   |   
    | amount                | 0.2                                       |       
    | account_collected_id  | by oid: scen.acc_EU_purchases_vat         |
    | account_paid_id       | by oid: scen.acc_EU_purchases_vat         |    
    | base_code_id          | by oid: scen.taxe_code_base_EU_purchases  |    
    | base_sign             | -1                                        |      
    | tax_code_id           | by oid: scen.taxe_code_EU_purchases_vat   |    
    | tax_sign              | -1                                        |      
    | ref_base_code_id      | by oid: scen.taxe_code_base_EU_purchases  |    
    | ref_base_sign         | 1                                         |   
    | ref_tax_code_id       | by oid: scen.taxe_code_EU_purchases_vat   |     
    | ref_tax_sign          | 1                                         |   

     Given I need a "account.tax" with oid: scen.EU_purchases_rev
    And having:
    | name                  | value                                     |
    | name                  | EU purchases_20% reverse                  |
    | description           | EU_P20_rev                                |
    | price_include         | false                                     |    
    | type_tax_use          | purchase                                  |
    | type                  | percent                                   |   
    | amount                | -0.2                                      |       
    | account_collected_id  | by oid: scen.acc_EU_purchases_rev_vat     |
    | account_paid_id       | by oid: scen.acc_EU_purchases_rev_vat     |    
    | tax_code_id           | by oid: scen.taxe_code_EU_purchases_rev_vat|    
    | tax_sign              | -1                                        |      
    | ref_tax_code_id       | by oid: scen.taxe_code_EU_purchases_rev_vat|     
    | ref_tax_sign          | 1                                         |   










