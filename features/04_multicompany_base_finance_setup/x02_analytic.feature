###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Copyright 2009 Camptocamp SA
#
##############################################################################

# Features Generic tags (none for all)
##############################################################################
# Branch      # Module       # Processes     # System
@multicompany_base_finance

Feature: CUSTOM ANALYTIC ACCOUNTS CHART IMPORT BASED ON CSV TEMPLATE + ANALYTIC JOURNALS SETTINGS

 
####### deletion of existing analytic accounts #########
 Scenario: deleting analytic accounts
   Given I execute the SQL commands
   """;
   DELETE from account_analytic_account;
   """   
######### import of CSV Analytic Chart file ###########
 @multicompany_base_finance_csv_analytic_chart_import
 Scenario: importing analytic_chart
   Given "account.analytic.account" is imported from CSV "Plan_analytique.csv" using delimiter ";"   

####### deletion company id  #########
# Scenario: deleting analytic accounts
#   Given I execute the SQL commands
#   """;
#   UPDATE account_analytic_account SET company_id=null;
#   """  
  


##### ANALYTIC JOURNALS CREATION ####   
 @multicompany_base_finance_analytic_journal_fr
  Scenario: ANALYTIC JOURNALS
  Given I need a "account.analytic.journal" with oid: scen.fr_analytic_journal
     And having:
     | name                             | value                        |
     | company_id                       | by oid: base.main_company    |   
     | name                             | FR journal analytique        |  
     | type                             | general                      |     

   
 @multicompany_base_finance_analytic_journal_lu
  Scenario: ANALYTIC JOURNALS
  Given I need a "account.analytic.journal" with oid: scen.ch_analytic_journal
     And having:
     | name                             | value                        |
     | company_id                       | by oid: scen.CH_company      |   
     | name                             | CH journal analytique        |  
     | type                             | general                      |   
 
