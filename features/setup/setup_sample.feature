###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Copyright 2009 Camptocamp SA
#
##############################################################################

# Features Generic tags (none for all)
##############################################################################
# Branch      # Module       # Processes     # System

@gm_init
Feature: Param the new database
  In order to have a coherent installation
  As an administrator autmated the manual installation steps.

  Scenario: install modules
    Given I update the module list
    Given I install the required modules with dependencies:
     | name              |
     | account           |
     | account_cancel    |
     | account_payment   |
     | account_voucher   |
     | analytic          |
     | board             |
     | decimal_precision |
     | fetchmail         |
     | l10n_ch           |
     | report_webkit     |

    Then my modules should have been installed and models reloaded

  Scenario: USER RIGHTS SETTINGS
    Given we select users below:
        | login |
        | admin |
    Then we assign all groups to the users

  Scenario: LANGUAGE INSTALL
    Given I install the following languages:
        | lang  |
        | fr_FR |
        | de_DE |
        | it_IT |
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

  Given I need a "res.lang" with code: it_IT
    And having:
    | name              | value     |
    | date_format       | %d/%m/%Y  |
    | grouping          | [3,0]     |
    | thousands_sep     | '         |


  Scenario: CREATION OF FISCAL YEAR 2013
    Given I need a "account.fiscalyear" with oid: scenario.fy2013
    And having:
       | name       | value      |
       | name       | 2013       |
       | code       | 2013       |
       | date_start | 2013-01-01 |
       | date_stop  | 2013-12-31 |

       And I create monthly periods on the fiscal year with reference "scenario.fy2013"
       Then I find a "account.fiscalyear" with oid: scenario.fy2012

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
