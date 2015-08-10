# -*- coding: utf-8 -*-
@swisslux @setup

Feature: Parameter the new database
  In order to have a coherent installation
  I've automated the manual steps.

  @createdb @no_login
  Scenario: CREATE DATABASE
    Given I create database from config file

  @no_demo_data
  Scenario: deactivate demo data
    Given I update the module list
    And I do not want all demo data to be loaded on install

  @webkit_path
  Scenario: SETUP WEBKIT path before running YAML tests
    Given I need a "res.company" with oid: base.main_company
    And I set the webkit path to "/srv/openerp/webkit_library/wkhtmltopdf-amd64"

  @modules
  Scenario: install modules
    Given I install the required modules with dependencies:
        | name                                 |
        # oca/ocb
        | account                              |
        | hr                                   |
        | hr_timesheet                         |
        | hr_timesheet_sheet                   |
        | l10n_ch                              |
        | project                              |
        | sale                                 |
        | stock                                |
        # oca/account-financial-tools
        | account_credit_control               |
        # oca/carrier-delivery
        | delivery_carrier_label_postlogistics |
        # oca/l10n-switzerland
        | l10n_ch_bank                         |
        | l10n_ch_dta                          |
        | l10n_ch_states                       |
        | l10n_ch_zip                          |
        # oca/server-tools
        | disable_openerp_online               |

  @lang
  Scenario: install lang
   Given I install the following language :
      | lang  |
      | de_DE |
      | fr_FR |
    Then the language should be available
    Given I find a "res.lang" with code: en_US
    And having:
      | key         | value    |
      | grouping    | [3,0]    |
      | date_format | %d/%m/%Y |
    Given I find a "res.lang" with code: de_DE
    And having:
      | key         | value    |
      | grouping    | [3,0]    |
      | date_format | %d/%m/%Y |
    Given I find a "res.lang" with code: fr_FR
    And having:
      | key         | value    |
      | grouping    | [3,0]    |
      | date_format | %d/%m/%Y |

  @company
  Scenario: Configure main partner and company
  Given I find a "res.company" with oid: base.main_company
    And having:
       | key        | value              |
       | name       | Swisslux SA        |
       | street     | Industriestrasse 8 |
       | street2    |                    |
       | zip        | 8618               |
       | city       | Oetwil am See      |
       | country_id | by code: CH        |
       | phone      | +41 43 844 80 80   |
       | fax        | +41 43 844 80 81   |
       | email      | info@swisslux.ch   |
       | website    | www.swisslux.ch    |
    Given the company has the "images/company_logo.png" logo
    And the company currency is "CHF" with a rate of "1.00"
    Given I need a "res.partner" with oid: scenario.partner_swisslux
    And having:
       | key        | value                     |
       | name       | Swisslux SA               |
       | street     | Industriestrasse 8        |
       | street2    |                           |
       | zip        | 8618                      |
       | city       | Oetwil am See             |
       | country_id | by code: CH               |
       | phone      | +41 43 844 80 80          |
       | fax        | +41 43 844 80 81          |
       | email      | info@swisslux.ch          |
       | website    | www.swisslux.ch           |
       | company_id | by oid: base.main_company |
    Given I need a "res.partner" with oid: scenario.partner_swisslux_romandie
    And having:
       | key        | value                          |
       | name       | Swisslux SA, Romandie & Tessin |
       | street     | Chemin de la Grand Clos 17     |
       | street2    |                                |
       | zip        | 1092                           |
       | city       | Belmont-sur-Lausanne           |
       | country_id | by code: CH                    |
       | phone      | +41 21 711 23 40               |
       | fax        | +41 21 711 23 41               |
       | email      | info@swisslux.ch               |
       | website    | www.swisslux.ch                |
       | company_id | by oid: base.main_company      |


  @account_chart_ch
  Scenario: Generate account chart for Swisslux SA
    Given I have the module account installed
    And I want to generate account chart from chart template named "Plan comptable STERCHI" with "5" digits for company "Swisslux SA"
    When I generate the chart
    Then accounts should be available for company "Swisslux SA"


  @fiscalyear_ch
    Scenario: create fiscal years
    Given I need a "account.fiscalyear" with oid: scenario.fy2015_ch
    And having:
    | name       | value                     |
    | name       | 2015                      |
    | code       | 2015                      |
    | date_start | 2015-01-01                |
    | date_stop  | 2015-12-31                |
    | company_id | by oid: base.main_company |
    And I create monthly periods on the fiscal year with reference "scenario.fy2015_ch"
    Then I find a "account.fiscalyear" with oid: scenario.fy2015_ch

