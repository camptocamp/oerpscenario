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

Feature: INSTALL OF LOCALISATION MODULES IN MULTI-COMPANY ENVIRONNEMENT

############################### COMPANY 1 ###############################

  @multicompany_base_finance_chart
  Scenario: GENERATE ACCOUNT CHART FMA SOCIETE FR
    Given I need a "res.company" with oid: base.main_company
    And having:
         | name                        | value                                          |
         | name                        | MA SOCIETE FR                                  |
       And I create monthly periods on the fiscal year with reference "scenario.fy2013"
       Then I find a "account.fiscalyear" with oid: scenario.fy2013
    Given I have the module account installed
    And no account set for company "MA SOCIETE FR"
    And I want to generate account chart from chart template named "Plan Comptable Général (France)" with "6" digits for company "MA SOCIETE FR"
    When I generate the chart
    Then accounts should be available for company "MA SOCIETE FR"

############################### COMPANY 2 ###############################

  @multicompany_base_finance_chart
  Scenario: GENERATE ACCOUNT CHART MA SOCIETE CH
    Given I need a "res.company" with oid: scen.CH_company
    And having:
         | name | value                  |
         | name | MA SOCIETE CH          |

    Given I need a "account.fiscalyear" with oid: scenario.CHfy2013
    And having:
       | name       |                   value |
       | name       |                    2013 |
       | code       |                    2013 |
       | date_start |              2013-01-01 |
       | date_stop  |              2013-12-31 |
       | company_id | by oid: scen.CH_company |

       And I create monthly periods on the fiscal year with reference "scenario.CHfy2013"
       Then I find a "account.fiscalyear" with oid: scenario.CHfy2013

    Given I have the module account installed
    And no account set for company "MA SOCIETE CH"
    And I want to generate account chart from chart template named "Plan comptable STERCHI" with "6" digits for company "MA SOCIETE CH"
    When I generate the chart
    Then accounts should be available for company "MA SOCIETE CH"


