###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Copyright 2009 Camptocamp SA
#
##############################################################################

# Features Generic tags (none for all)
##############################################################################
# Branch      # Module       # Processes     # System

@customer_init
Feature: Param the new database
  In order to have a coherent installation
  As an administrator autmated the manual installation steps.
  @customer_db
  Scenario: CREATE DATABASE
    #Given I drop database "openerp_test_customer" TODO
    Given I create database "openerp_test_customer" with admin password "admin"

  @customer_addons
  Scenario: INSTALL MODULES
    Given I update the module list
    Given I install the required modules with dependencies:
     | name                 |
     | account              |
     | account_cancel       |
     | account_payment      |
     | sale                 |
     | analytic             |
     | l10n_ch              |
     | l10n_ch_payment_slip |
     | report_webkit        |
     | l10_ch_dta           |
     | l10n_ch_bank         |
     | base_headers_webkit  |
     | invoice_webkit       |
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
    | name          | value    |
    | date_format   | %d/%m/%Y |
    | grouping      | [3,0]    |
    | thousands_sep | '        |

   Given I need a "res.lang" with code: fr_FR
    And having:
    | name          | value    |
    | date_format   | %d/%m/%Y |
    | grouping      | [3,0]    |
    | thousands_sep | '        |

  Given I need a "res.lang" with code: de_DE
     And having:
     | name          | value    |
     | date_format   | %d/%m/%Y |
     | grouping      | [3,0]    |
     | thousands_sep | '        |

  Given I need a "res.lang" with code: it_IT
    And having:
    | name          | value    |
    | date_format   | %d/%m/%Y |
    | grouping      | [3,0]    |
    | thousands_sep | '        |


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

  Scenario: GENERATE ACCOUNT CHART
    Given I have the module account installed
    And no account set
    And I want to generate account chart from chart template named "Plan comptable STERCHI" with "0" digits
    When I generate the chart
    Then accounts should be available

  Scenario: CONFIGURE MAIN PARTNER AND COMPANY
      Given I need a "res.company" with oid: base.main_company
      And having:
         | name           | value           |
         | name           | GeneralMedia SA |
         | bvr_background | 0               |
      Given the company has the "logo.png" logo
      And the company currency is "CHF" with a rate of "1.00"

      Given I need a "res.partner" with oid: base.main_partner
      And having:
         | name                        | customer           |
         | lang                        | fr_FR              |
         | website                     | www.customer.ch    |
         | customer                    |                    |
         | supplier                    |                    |
         | street                      | Chemin de xxx 8    |
         | street2                     | Case postale 107   |
         | city                        | Lausanne           |
         | zip                         | CH-1000            |
         | phone                       | +41 (0)21 21 21 21 |
         | fax                         | +41 (0)21 21 21 21 |
         | email                       | info@customer.ch   |
         | country_id                  | by code: CH        |
         | property_account_receivable | by code: 1100      |


  Scenario: SETUP WEBKIT
    Given I need a "res.company" with oid: base.main_company
    And I set the webkit path to "/srv/openerp/webkit_library/wkhtmltopdf-amd64"

  @customer_bank_account
  Scenario: CONFIGURE BANQUE ACCOUNT:
     Given I need a "res.partner.bank" with oid: scen.main_bank
     And having:
         | name             | value                     |
         | partner_id       | by oid: base.main_partner |
         | company_id       | by oid: base.main_company |
         | zip              | CH-1000                   |
         | country_id       | by code: CH               |
         | state            | bvr                       |
         | street           | Chemin de xxx 8           |
         | acc_number       | xx-xxxx-x                 |
         | bvr_adherent_num | xxxxxx                    |
         | print_bank       | 0                         |
         | print_account    | 1                         |
         | bank_name        | CREDIT SUISSE             |
         | bank_bic         | CRESCHZZ80A               |
         | currency_id      | by name: CHF              |
