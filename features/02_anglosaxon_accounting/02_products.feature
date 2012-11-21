###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Copyright 2009 Camptocamp SA
#
##############################################################################
##############################################################################
# Branch      # Module       # Processes     # System
@anglosaxon_accounting

Feature: PRODUCT CATEGORIES CREATION

   @anglosaxon_product_category_creation
  Scenario: CREATION OF PRODUCT CATEGORIES FOR ANGLO-SAXON ACCOUNTING
    Given I need a "product.category" with name: Cat_A and oid: scenario.cat_A
     And having:
          | name                                                | value             |
          | type                                                | normal            |  
          | property_account_creditor_price_difference_categ    | by code: 688      |
          | property_account_income_categ                       | by code: 707      |
          | property_account_expense_categ                      | by code: 690      |
          | property_stock_account_input_categ                  | by code: 405      |
          | property_stock_account_output_categ                 | by code: 415      |
          | property_stock_valuation_account_id                 | by code: 370      |  
          
     Given I need a "product.category" with name: Cat_A and oid: scenario.cat_B
     And having:
          | name                                                | value             |
          | type                                                | normal            |  
          | property_account_creditor_price_difference_categ    | by code: 688      |
          | property_account_income_categ                       | by code: 707      |
          | property_account_expense_categ                      | by code: 690      |
          | property_stock_account_input_categ                  | by code: 405      |
          | property_stock_account_output_categ                 | by code: 415      |
          | property_stock_valuation_account_id                 | by code: 370      |           
                      
         Given I need a "product.category" with name: Cat_A and oid: scenario.cat_C
     And having:
          | name                                                | value             |
          | type                                                | normal            |  
          | property_account_creditor_price_difference_categ    | by code: 688      |
          | property_account_income_categ                       | by code: 707      |
          | property_account_expense_categ                      | by code: 690      |
          | property_stock_account_input_categ                  | by code: 405      |
          | property_stock_account_output_categ                 | by code: 415      |
          | property_stock_valuation_account_id                 | by code: 370      |      
                  


  @product_modification
  Scenario: CHANGE OF STOCK VALUATION METHODE (REAL TIME) ON PRODUCT
     Given I need a "product.product" with name: P1 and oid: scenario.p1
     And having:
          | name            | value             |
          | valuation       | real_time         |
                   
     Given I need a "product.product" with name: P2 and oid: scenario.p2
     And having:
          | name            | value             |
          | valuation       | real_time         |

     Given I need a "product.product" with name: P3 and oid: scenario.p3
     And having:
          | name            | value             |
          | valuation       | real_time         |       
          
     Given I need a "product.product" with name: P4 and oid: scenario.p4
     And having:
          | name            | value             |
          | valuation       | real_time         |   
          
          
     Given I need a "product.product" with name: P5 and oid: scenario.p5
     And having:
          | name            | value             |
          | valuation       | real_time         |   