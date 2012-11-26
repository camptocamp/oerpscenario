###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Copyright 2009 Camptocamp SA
#
##############################################################################

# Features Generic tags (none for all)
##############################################################################

# Branch      # Module       # Processes     # System
@customer @customer_init

Feature: Param the new database
  In order to have a coherent installation
  I autmated the manual steps.

  Scenario: install modules
    Given I update the module list
    Given I install the required modules with dependencies:
     | name              |
     | account           |
     | account_cancel    |
     | account_payment   |
     | account_voucher   |
     | analytic          |
     | base              |
     | base_action_rule  |
     | base_calendar     |
     | base_iban         |
     | base_setup        |
     | base_tools        |
     | board             |
     | crm               |
     | decimal_precision |
     | fetchmail         |
     | l10n_ch           |
     | mail              |
     | process           |
     | procurement       |
     | product           |
     | purchase          |
     | report_webkit     |
     | resource          |
     | sale              |
     | sale_crm          |
     | stock             |
     | web               |
     | web_calendar      |
     | web_dashboard     |
     | web_diagram       |
     | web_gantt         |
     | web_graph         |
     | web_kanban        |
     | web_mobile        |
     | web_tests         |
    Then my modules should have been installed and models reloaded
    Given I give all groups right access to admin user
  Scenario: install lang
   Given I install the following language :
      | lang  |
      | fr_FR |
      | de_DE |
   Then the language should be available


  Scenario: Config lang_locals
  Given I have install "fr_FR" language
  And I set "fr_FR" language to swiss formatting
  Then  "fr_FR" language date format should have changed

  Given I have install "de_DE" language
  And I set "de_DE" language to swiss formatting
  Then "de_DE" language date format should have changed

  Scenario: Generate account chart
    Given I have the module account installed
    And no account set
    And I want to generate account chart from chart template named "Plan comptable STERCHI" with "0" digits
    When I generate the chart
    Then accounts should be available

  Scenario: Configure main partner and company
      Given I should have a company
      Given the company has the "logo.png" logo
      And his rml header set to "rml_header.txt"
      Then I set the company with the following data :
         | key            | value           |
         | name           | 'Customer_name' |
         | bvr_background | true            |


      And the main company currency is "CHF" with a rate of "1.00"

      And I set the company main partner with the following data :
         | key        | value             |
         | first_name | 'Customer_name'   |
         | lang       | 'fr_FR'           |
         | website    | 'www.website.com' |
         | customer   | false             |

      And I set the main address with the following data :
         | key     | value                         |
         | zip     | '3012'                        |
         | fax     | '+358 9 8561 9901'            |
         | phone   | '+41 79 210 98 55'            |
         | email   | 'nfo-switzerland@website.com' |
         | street  | 'Stadtbachstrasse 40'         |
         | street2 | ''                            |
         | city    | 'Bern'                        |
         | name    | 'Customer_name System AG'     |

     And I update the address country code to CH
     Given the main company has a default_income_account set to "3000"
     Given the main company has a default payment_term set to "30 Days End of Month"

  Scenario: Configure journal
    Given there is a journal named "Banque CHF" of type "bank"
     And the journal default debit account is set to "1020"
     And the journal default credit account is set to "1020"
     Given all journals allow entry cancellation

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

  @setup_property
  Scenario: set properties
    Given I set global property named "property_account_receivable" for model "res.partner" and field "property_account_receivable"
    And the property is related to model "account.account" using column "code" and value "X11002"

  Scenario: create user ERP Manager
    Given create a ERP manager user with password "naewaiT6N"
    
  @set_ir_exports
  Scenario: create ir.exports
    Given I create an "Arrêt standard" export for model "cpm.arret" with following columns:
       | name                |
       | ar_code_int         |
       | ar_code_comm        |
       | ar_lib              |
       | ar_zon_id/zon_code  |
       | company_id/etc_code |
       | deb_val_date        |
       | fin_val_date        |