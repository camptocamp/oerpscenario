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

Feature: FINANCIAL JOURNALS SETTINGS
   
############################### COMPANY 1 ###############################

  Scenario: ADD SPECIFIC FINANCIAL ACCOUNT FOR THIS BANK ACCOUNT
   Given I need a "account.account" with oid: scen.acc_bank_eur
    And having:
    | name        | value               |
    | name        | EUR bank account    |
    | code        | 512100              |
    | parent_id   | by code: 512        |
    | type        | other               |
    | user_type   | by name: Cash       |


  @multicompany_base_finance_bank_journal_settings
  Scenario: FINANCIAL JOURNALS CREATION
   Given there is a journal with name "BNP LA DEFENSE ENTREPRISE FR7630004013280001246072204" and company "MA SOCIETE FR"
   And having:
     | name                      | value                           |
     | name                      | BNP 2204                        |
     | code                      | B2204                           |
     | type                      | bank                            |
     | default_debit_account_id  | by code: 512100                 |
     | default_credit_account_id | by code: 512100                 |
     | allow_date                | f                               |
     | analytic_journal_id       | by oid: scen.fr_analytic_journal|
     
 
############################### COMPANY 2 ###############################

  @multicompany_base_finance_bank_journal_settings
  Scenario: FINANCIAL JOURNALS CREATION
   Given there is a journal with name "Commerzbank DE16 6808 0030 0553 0349 00" and company "MA SOCIETE CH"
   And having:
     | name                      | value                           |
     | name                      | COMM 4900                       |
     | code                      | B4900                           |
     | type                      | bank                            |
     | default_debit_account_id  | by code: 1021                   |
     | default_credit_account_id | by code: 1021                   |
     | allow_date                | f                               |
     | analytic_journal_id       | by oid: scen.ch_analytic_journal|


  @multicompany_base_finance_bank_journal_settings
  Scenario: FINANCIAL JOURNALS CREATION
   Given there is a journal with name "UniCredit Bank HU76 1091 8001 0000 0056 8267 0008" and company "MA SOCIETE CH"
   And having:
     | name                      | value                           |
     | name                      | UCB 0008                        |
     | code                      | B0008                           |
     | type                      | bank                            |
     | default_debit_account_id  | by code: 1022                   |
     | default_credit_account_id | by code: 1022                   |
     | currency                  | by name: USD                    |
     | allow_date                | f                               |
     | analytic_journal_id       | by oid: scen.ch_analytic_journal|


  Scenario: FINANCIAL JOURNALS CREATION
   Given there is a journal with name "Fio Banka CZ66 2010 0000 0026 0003 9960" and company "MA SOCIETE CH"
   And having:
     | name                      | value                           |
     | name                      | FB 9960                         |
     | code                      | B9960                           |
     | type                      | bank                            |
     | default_debit_account_id  | by code: 1023                   |
     | default_credit_account_id | by code: 1023                   |
     | currency                  | by name: GBP                    |
     | allow_date                | f                               |
     | analytic_journal_id       | by oid: scen.ch_analytic_journal|

     
     

#Other journals
############################### COMPANY 1 ###############################
     
  Scenario: FINANCIAL JOURNALS CREATION
   Given there is a journal with name "Sales Journal" and company "MA SOCIETE FR"
   And having:
     | name                      | value                           |
     | name                      | FR-Ventes                       |
     | code                      | FRJV                            |
     | type                      | sale                            |
     | allow_date                | f                               |
     | analytic_journal_id       | by oid: scen.fr_analytic_journal|
  
   
  Scenario: FINANCIAL JOURNALS CREATION     
   Given there is a journal with name "Sales Refund Journal" and company "MA SOCIETE FR"
   And having:
     | name                      | value                           |
     | name                      | FR-Avoir sur ventes             |
     | code                      | FRJAV                           |
     | type                      | sale_refund                     |
     | allow_date                | f                               |
     | analytic_journal_id       | by oid: scen.fr_analytic_journal|    
  

  Scenario: FINANCIAL JOURNALS CREATION     
   Given there is a journal with name "Purchase Journal" and company "MA SOCIETE FR"
   And having:
     | name                      | value                           |
     | name                      | FR-Achats                       |
     | code                      | FRJA                            |
     | type                      | purchase                        |
     | allow_date                | f                               |
     | analytic_journal_id       | by oid: scen.fr_analytic_journal|
     

  Scenario: FINANCIAL JOURNALS CREATION     
   Given there is a journal with name "Purchase Refund Journal" and company "MA SOCIETE FR"
   And having:
     | name                      | value                           |
     | name                      | FR-Avoir sur achats             |
     | code                      | FRJAA                           |
     | type                      | purchase_refund                 |
     | allow_date                | f                               |
     | analytic_journal_id       | by oid: scen.fr_analytic_journal|
     

  Scenario: FINANCIAL JOURNALS CREATION     
   Given there is a journal with name "Miscellaneous Journal" and company "MA SOCIETE FR"
   And having:
     | name                      | value                           |
     | name                      | FR-Opérations Diverses          |
     | code                      | FROD                            |
     | type                      | general                         |
     | allow_date                | f                               |
     | analytic_journal_id       | by oid: scen.fr_analytic_journal| 


  Scenario: FINANCIAL JOURNALS CREATION     
   Given there is a journal with name "Opening Entries Journal" and company "MA SOCIETE FR"
   And having:
     | name                      | value                           |
     | name                      | FR-Soldes à Nouveau             |
     | code                      | FRSAN                           |
     | type                      | situation                       |
     | default_debit_account_id  | by code : 120000                |
     | default_credit_account_id | by code : 120000                |
     | centralisation            | true                            |
     | analytic_journal_id       | by oid: scen.fr_analytic_journal|
                
  
  Scenario: FINANCIAL JOURNALS CREATION
   Given there is a journal with name "Stock Journal" and company "MA SOCIETE FR"
   And having:
     | name                      | value                           |
     | name                      | FR-Stock                        |
     | code                      | FRST                            |
     | type                      | general                         | 
     
  @multicompany_base_finance_petty_cash_journal_settings
  Scenario: FINANCIAL JOURNALS CREATION
   Given there is a journal with name "Cash" and company "MA SOCIETE FR"
   And having:
     | name                      | value                           |
     | name                      | Caisse                          |
     | code                      | FR-CA                           |
     | type                      | bank                            |
     | default_debit_account_id  | by code: 531000                 |
     | default_credit_account_id | by code: 531000                 |
     | allow_date                | f                               |
     | analytic_journal_id       | by oid: scen.fr_analytic_journal|
     
                  
############################### COMPANY 2 ###############################

  Scenario: FINANCIAL JOURNALS CREATION
   Given there is a journal with name "Sales Journal" and company "MA SOCIETE CH"
   And having:
     | name                      | value                            |
     | name                      | CH-Ventes                        |
     | code                      | CHJV                             |
     | type                      | sale                             |
     | allow_date                | f                                |
     | analytic_journal_id       | by oid: scen.ch_analytic_journal |


  Scenario: FINANCIAL JOURNALS CREATION
   Given there is a journal with name "Sales Refund Journal" and company "MA SOCIETE CH"
   And having:
     | name                      | value                           |
     | name                      | CH-Avoir sur ventes             |
     | code                      | CHJAV                           |
     | type                      | sale_refund                     |
     | allow_date                | f                               |
     | analytic_journal_id       | by oid: scen.ch_analytic_journal|


  Scenario: FINANCIAL JOURNALS CREATION     
   Given there is a journal with name "Purchase Journal" and company "MA SOCIETE CH"
   And having:
     | name                      | value                           |
     | name                      | CH-Achats                       |
     | code                      | CHJA                            |
     | type                      | purchase                        |
     | allow_date                | f                               |
     | analytic_journal_id       | by oid: scen.ch_analytic_journal|
  

  Scenario: FINANCIAL JOURNALS CREATION     
   Given there is a journal with name "Purchase Refund Journal" and company "MA SOCIETE CH"
   And having:
     | name                      | value                           |
     | name                      | CH-Avoir sur achats             |
     | code                      | CHJAA                           |
     | type                      | purchase_refund                 |
     | allow_date                | f                               |
     | analytic_journal_id       | by oid: scen.ch_analytic_journal|


  Scenario: FINANCIAL JOURNALS CREATION     
   Given there is a journal with name "Miscellaneous Journal" and company "MA SOCIETE CH"
   And having:
     | name                      | value                           |
     | name                      | CH-Opérations Diverses          |
     | code                      | CHOD                            |
     | type                      | general                         |
     | allow_date                | f                               |
     | analytic_journal_id       | by oid: scen.ch_analytic_journal|
  

  Scenario: FINANCIAL JOURNALS CREATION     
   Given there is a journal with name "Opening Entries Journal" and company "MA SOCIETE CH"
   And having:
     | name                      | value                           |
     | name                      | LU-Soldes à Nouveau             |
     | code                      | LUSAN                           |
     | type                      | situation                       |
     | default_debit_account_id  | by code : 2991                  |
     | default_credit_account_id | by code : 2991                  |
     | centralisation            | true                            |

 
  Scenario: FINANCIAL JOURNALS CREATION
   Given there is a journal with name "Stock Journal" and company "MA SOCIETE CH"
   And having:
     | name                      | value                           |
     | name                      | CH-Stock                        |
     | code                      | CHST                            |
     | type                      | general                         |
     | analytic_journal_id       | by oid: scen.ch_analytic_journal|

  @multicompany_base_finance_petty_cash_journal_settings
  Scenario: FINANCIAL JOURNALS CREATION
   Given there is a journal with name "Cash" and company "MA SOCIETE CH"
   And having:
     | name                      | value                           |
     | name                      | Caisse                          |
     | code                      | CH-CA                           |
     | type                      | bank                            |
     | default_debit_account_id  | by code: 1000                   |
     | default_credit_account_id | by code: 1000                   |
     | allow_date                | f                               |
     | analytic_journal_id       | by oid: scen.ch_analytic_journal|






