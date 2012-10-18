###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Copyright 2009 Camptocamp SA
#
##############################################################################
##############################################################################
# Branch      # Module       # Processes     # System
@base_finance 	@base_commercial_management 

Feature: INITIAL SET-UP FOR NEW DATABASE

  @base_finance_setup_install_modules
  Scenario: MODULES INSTALLATION

    Given I do not want all demo data to be loaded on install
    And I install the required modules with dependencies:
      | name                            |
      | account_voucher                 |
      | account_accountant              |
      | account_cancel                  |
      | purchase                        |
      | sale                            |
      | stock_move_change_delivery_date |
#      | product_standard_margin         |
#      | product_historical_margin       |
#      | report_webkit_lib               |
#      | account_financial_report_webkit |
#      | invoice_webkit                  |
#      | purchase_order_webkit           |
#      | sale_order_webkit               |
#      | stock_picking_webkit            |
#      | account_advanced_reconcile      |     
                   
    Then my modules should have been installed and models reloaded

  @base_finance_setup_languages
  Scenario: LANGUAGE SETTINGS
    Given I need a "res.lang" with code: en_US
    And having:
    | name        | value    |
    | date_format | %d/%m/%Y |
    | grouping    | [3,0]    |
    
  @base_finance_setup_access_rights
  Scenario: USER RIGHTS SETTINGS
    Given we select users below:
      | login |
      | admin |
    Then we assign all groups to the users
    And we activate the extended view on the users

  @base_finance_setup_create_fy
  Scenario: CREATION OF FISCAL YEAR 2012
    Given I need a "account.fiscalyear" with oid: scenario.fy2012
    And having:
    | name       | value      |
    | name       | 2012       |
    | code       | 2012       |
    | date_start | 2012-01-01 |
    | date_stop  | 2012-12-31 |

    And I create monthly periods on the fiscal year with reference "fy2012"
    Then I find a "account.fiscalyear" with oid: scenario.fy2012
    
  @base_finance_setup_currency_rates
  Scenario: CURRENCY RATES SETTINGS
    Given I set the following currency rates :
      | currency |   rate | date     |
      | EUR      | 1.0000 | %Y-01-01 |
      | USD      | 1.5000 | %Y-01-01 |
      | USD      | 1.8000 | %Y-02-01 |
      | USD      | 1.5000 | %Y-03-01 |
      | USD      | 1.4000 | %Y-04-01 |
      | USD      | 1.4500 | %Y-05-01 |      
      | USD      | 1.5500 | %Y-06-01 |  
      | USD      | 1.5700 | %Y-07-01 |                
      | USD      | 1.6000 | %Y-08-01 | 
      | USD      | 1.6500 | %Y-09-01 |
      | USD      | 1.6300 | %Y-10-01 |                             
      | USD      | 1.6100 | %Y-11-01 |
      | USD      | 1.5700 | %Y-12-01 |                  
      | GBP      | 0.8000 | %Y-01-01 |
      | GBP      | 0.9000 | %Y-02-01 |
      | GBP      | 0.8000 | %Y-03-01 |
      | GBP      | 0.8200 | %Y-04-01 |
      | GBP      | 0.8300 | %Y-05-01 |
      | GBP      | 0.7900 | %Y-06-01 |    
      | GBP      | 0.8400 | %Y-07-01 |    
      | GBP      | 0.7600 | %Y-08-01 |    
      | GBP      | 0.7700 | %Y-09-01 |
      | GBP      | 0.8900 | %Y-10-01 |
      | GBP      | 0.9200 | %Y-11-01 |      
      | GBP      | 0.9500 | %Y-12-01 |
      | CAD      | 1.1500 | %Y-01-01 |
      | CAD      | 1.1700 | %Y-02-01 |
      | CAD      | 1.1900 | %Y-03-01 |
      | CAD      | 1.2000 | %Y-04-01 |
      | CAD      | 1.0500 | %Y-05-01 |
      | CAD      | 1.1000 | %Y-06-01 |    
      | CAD      | 1.1800 | %Y-07-01 |    
      | CAD      | 1.2200 | %Y-08-01 |    
      | CAD      | 1.2400 | %Y-09-01 |
      | CAD      | 1.2600 | %Y-10-01 |
      | CAD      | 1.1600 | %Y-11-01 |      
      | CAD      | 1.1300 | %Y-12-01 |
