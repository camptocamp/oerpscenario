###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Copyright 2012 Camptocamp SA
#
##############################################################################

# Features Generic tags (none for all)
##############################################################################

@init_account
Feature: Param the new database
  In order to have a coherent installation
  I autmated the manual steps.
  
  Scenario: install modules
    Given I update the module list
    Given I install the required modules with dependencies:
     | name |
     |account|
     |account_cancel|
     |account_payment|
     |account_voucher|
     |analytic|
    Then my modules should have been installed
    And I reload the Ooor connexion and Helpers
    Given I give all groups right access to admin user
# TODO Complete with generic values
    # Given the main company has a default_income_account set to "3000"
    # Given the main company has a default payment_term set to "30 Days End of Month"

  Scenario: Set the chart of account
    Given I want to generate account chart from module account with 4 digits
 
  Scenario: Configure Taxes
    Given a purchase tax called 'Buy 19.6%' with a rate of 0.196 exists
    And a sale tax called 'Sale 19.6%' with a rate of 0.196 exists
 
  # Scenario: Configure journal
# TODO Complete with generic values
    # Given there is a journal named "Banque CHF" of type "bank" 
    #  And the journal default debit account is set to "1020"
    #  And the journal default credit account is set to "1020"
    #  Given all journals allow entry cancellation
     
# TODO Complete with generic values
  Scenario: Configure banque account:
    Given there is a bank account named "XX-XXXX-X" linked to partner "Customer_name"
     And I set the bank account with the following data :
         | key | value |
         | city | 'Bern' |
         | owner_name | 'Customer_name' |     
         | name | '01-78367-7'|
         | zip | '3012' |
         | country_id | 41 |
         | state | 'bvrpost' |
         | street | 'Stadtbachstrasse 40' |
         | acc_number | 'XX' |
         | bvr_number | 'XX' |
         | post_number | 'XX' |
         | bvr_adherent_num | '0000000'|
         | printbank | false |
         | printaccount | true |
   # And the bank account is linked to bank "Postfinance"


   Scenario: Initialize Account Journal settings
       Given a cash journal in USD exists
       And a cash journal in CHF exists
       And a cash journal in EUR exists
       And on all journal entries can be canceled

        

