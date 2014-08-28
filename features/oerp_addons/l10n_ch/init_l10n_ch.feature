###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Copyright 2012 Camptocamp SA
#
##############################################################################

# Features Generic tags (none for all)
##############################################################################

@init_l10n_ch
Feature: Param the new database
  In order to have a coherent installation
  I autmated the manual steps.

  Scenario: install modules
    Given I update the module list
    Given I install the required modules with dependencies:
     | name         |
     | l10n_ch      |
     | l10n_ch_bank |
    Then my modules should have been installed and models reloaded
    Given I give all groups right access to admin user
    Given the main company has a default_income_account set to "3000"
    Given the main company has a default payment_term set to "30 Days End of Month"

  Scenario: Configure journal
    Given there is a journal named "Banque CHF" of type "bank"
     And the journal default debit account is set to "1020"
     And the journal default credit account is set to "1020"
     Given all journals allow entry cancellation


   Scenario: Generate account chart
     Given I have the module account installed
     And no account set
     And I want to generate account chart from module l10n_ch
     When I generate the chart
     Then accounts should be available

  Scenario: Configure banque account:
    Given there is a bank account named "XX-XXXX-X" linked to partner "Customer_name"
     And I set the bank account with the following data :
         | key              | value                 |
         | city             | 'Bern'                |
         | owner_name       | 'Customer_name'       |
         | name             | '01-78367-7'          |
         | zip              | '3012'                |
         | country_id       | 41                    |
         | state            | 'bvrpost'             |
         | street           | 'Stadtbachstrasse 40' |
         | acc_number       | 'XX'                  |
         | bvr_number       | 'XX'                  |
         | post_number      | 'XX'                  |
         | bvr_adherent_num | '0000000'             |
         | printbank        | false                 |
         | printaccount     | true                  |
    And the bank account is linked to bank "Postfinance"

  Scenario: Configure main partner and company
    Given I should have a company
    And the company currency is "CHF" with a rate of "1.00"
    And I update the address country code to CH
