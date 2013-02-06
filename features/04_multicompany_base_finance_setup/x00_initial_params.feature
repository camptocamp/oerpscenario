###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Copyright 2009 Camptocamp SA
#
##############################################################################
##############################################################################
# Branch      # Module       # Processes     # System
@multicompany_base_finance

Feature: INITIAL SET-UP FOR NEW DATABASE

  @multicompany_base_finance_create_db
  Scenario: CREATE DATABASE
    #Given I drop database "toto" TODO
    Given I create database "70" with admin password "admin"

  @multicompany_base_finance_setup_install_modules
  Scenario: MODULES INSTALLATION

    Given I do not want all demo data to be loaded on install
    And I update the module list
    And I install the required modules with dependencies:
      | name                                |
      | account_accountant                  |
      | account_default_draft_move          |
      | l10n_multilang                      |
      | l10n_fr                             |     
      | l10n_ch                             |            
      | purchase                            |
      | sale                                |
      | web_shortcuts                       |       
      | report_webkit_lib                   |
      | account_financial_report_webkit     |         
#      | partner_contact_address_detailed    | 
#      | purchase_order_webkit               |
#      | sale_order_webkit                   |
#      | invoice_webkit                      |    
#      | html_invoice_product_note           |
#      | html_sale_product_note              |
#      | sale_note_flow                      |      

    Then my modules should have been installed and models reloaded

  @multicompany_base_finance_setup_languages
  Scenario: LANGUAGE INSTALL
    Given I install the following languages:
      | lang  |
      | fr_FR |
    Then the language should be available

  Scenario: LANGUAGE SETTINGS
     Given I need a "res.lang" with code: en_US
     And having:
     | name              | value     |
     | date_format       | %d/%m/%Y  |
     | grouping          | [3,0]     |
     | thousands_sep     | '         |

     Given I need a "res.lang" with code: fr_FR
     And having:
     | name              | value     |
     | date_format       | %d/%m/%Y  |
     | grouping          | [3,0]     |
     | thousands_sep     | '         |
     Given I need a "res.lang" with code: de_DE
     And having:
     | name              | value     |
     | date_format       | %d/%m/%Y  |
     | grouping          | [3,0]     |
     | thousands_sep     | '         |


  @multicompany_base_finance_setup_create_fy
  Scenario: CREATION OF FISCAL YEAR 2012
    Given I need a "account.fiscalyear" with oid: scenario.fy2012
    And having:
    | name       | value      |
    | name       | 2012       |
    | code       | 2012       |
    | date_start | 2012-01-01 |
    | date_stop  | 2012-12-31 |

    And I create monthly periods on the fiscal year with reference "scenario.fy2012"
    Then I find a "account.fiscalyear" with oid: scenario.fy2012

  Scenario: CREATION OF FISCAL YEAR 2013
     Given I need a "account.fiscalyear" with oid: scenario.fy2013
     And having:
     | name       | value      |
     | name       | 2013       |
     | code       | 2013       |
     | date_start | 2013-01-01 |
     | date_stop  | 2013-12-31 |

     And I create monthly periods on the fiscal year with reference "scenario.fy2013"
     Then I find a "account.fiscalyear" with oid: scenario.fy2013

     Given I install the required modules with dependencies:
     | name                              |
     | account_statement_ext             |
     | account_statement_base_completion |
     | account_statement_base_import     |
     | account_advanced_reconcile        |


  Scenario: SETUP WEBKIT
     Given I need a "res.company" with oid: base.main_company
     And I set the webkit path to "/srv/openerp/webkit_library/wkhtmltopdf-amd64"
    

# TODO --> add multicurrency here + type column

  @multicompany_base_finance_setup_currency_rates
   Scenario: CURRENCY RATES TYPE NAME CREATION (mainly for module account_multicurrency_revaluation)
    Given I need a "res.currency.rate.type" with oid: scen.average_fx_rate_type
    And having:
    | name                  | value          |
    | name                  | average        |

   Scenario: CURRENCY RATES SETTINGS
    Given I set the following currency rates:
      | currency |   rate | date     |  type |
      | EUR      | 1.0000 | %Y-01-01 |       |
      | USD      | 1.5000 | %Y-01-01 |       |
      | USD      | 1.8000 | %Y-02-01 |       |
      | USD      | 1.5000 | %Y-03-01 |       |
      | USD      | 1.4000 | %Y-04-01 |       |
      | USD      | 1.4500 | %Y-05-01 |       |
      | USD      | 1.5500 | %Y-06-01 |       |
      | USD      | 1.5700 | %Y-07-01 |       |
      | USD      | 1.6000 | %Y-08-01 |       |
      | USD      | 1.6500 | %Y-09-01 |       |
      | USD      | 1.6300 | %Y-10-01 |       |
      | USD      | 1.6100 | %Y-11-01 |       |
      | USD      | 1.5700 | %Y-12-01 |       |
      | GBP      | 0.8000 | %Y-01-01 |       |
      | GBP      | 0.9000 | %Y-02-01 |       |
      | GBP      | 0.8000 | %Y-03-01 |       |
      | GBP      | 0.8200 | %Y-04-01 |       |
      | GBP      | 0.8300 | %Y-05-01 |       |
      | GBP      | 0.7900 | %Y-06-01 |       |
      | GBP      | 0.8400 | %Y-07-01 |       |
      | GBP      | 0.7600 | %Y-08-01 |       |
      | GBP      | 0.7700 | %Y-09-01 |       |
      | GBP      | 0.8900 | %Y-10-01 |       |
      | GBP      | 0.9200 | %Y-11-01 |       |
      | GBP      | 0.9500 | %Y-12-01 |       |
      | CAD      | 1.1500 | %Y-01-01 |       |
      | CAD      | 1.1700 | %Y-02-01 |       |
      | CAD      | 1.1900 | %Y-03-01 |       |
      | CAD      | 1.2000 | %Y-04-01 |       |
      | CAD      | 1.0500 | %Y-05-01 |       |
      | CAD      | 1.1000 | %Y-06-01 |       |
      | CAD      | 1.1800 | %Y-07-01 |       |
      | CAD      | 1.2200 | %Y-08-01 |       |
      | CAD      | 1.2400 | %Y-09-01 |       |
      | CAD      | 1.2600 | %Y-10-01 |       |
      | CAD      | 1.1600 | %Y-11-01 |       |
      | CAD      | 1.1300 | %Y-12-01 |       |
      | USD      | 1.6000 | %Y-01-31 |average|
      | USD      | 1.9000 | %Y-02-28 |average|   
      | GBP      | 0.7000 | %Y-01-31 |average|   
      | GBP      | 0.8000 | %Y-02-28 |average|   
      | CAD      | 1.2500 | %Y-01-01 |average|
      | CAD      | 1.2700 | %Y-02-01 |average|
   