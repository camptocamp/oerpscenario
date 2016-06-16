# -*- coding: utf-8 -*-
@upgrade_from_9.0.6
Feature: upgrade to 9.0.7

  Scenario: upgrade
    Given I update the module list
    Given I install the required modules with dependencies:
      | name                                          |
      | specific_reports                              |
    Then my modules should have been installed and models reloaded

   @currencies
   Scenario: Add currencies
   Scenario: Configure multicurrency and add currencies
   Given I enable "Allow multi currencies" in "Accounting" settings menu
   Given I find an inactive "res.currency" with name: HKD
     And having:
       | key    | value |
       | active | True  |
 
 
  @account_chart_extended
  Scenario: Generate extended account chart for Swisslux AG
    Given "account.account" is imported from CSV "setup/account.account.csv" using delimiter ","

  @force_translations @slow
  Scenario: Force lang translations
    Given I update the module list
    When I update the following languages
         | lang  |
         | de_DE |

    Then I set the version of the instance to "9.0.6"
