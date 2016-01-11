# -*- coding: utf-8 -*-
@swisslux @setup

Feature: Parameter the new database
  In order to have a coherent installation
  I've automated the manual steps.

  @createdb @no_login
  Scenario: CREATE DATABASE
    Given I find or create database from config file

  @no_demo_data
  Scenario: deactivate demo data
    Given I update the module list
    And I do not want all demo data to be loaded on install

  @lang
  Scenario: install lang
   Given I install the following language :
      | lang    |
      | de_DE   |
      | fr_FR   |
      | it_IT   |
    Then the language should be available
    Given I find a "res.lang" with code: en_US
    And having:
      | key             | value     |
      | grouping        | [3,0]     |
      | iso_code        | en        |
      | date_format     | %m/%d/%Y  |
      | thousands_sep   | ,         |
      | decimal_point   | .         |
    Given I find a "res.lang" with code: de_DE
    And having:
      | key             | value     |
      | grouping        | [3,0]     |
      | date_format     | %d.%m.%Y  |
      | thousands_sep   | '         |
      | decimal_point   | .         |
    Given I find a "res.lang" with code: fr_FR
    And having:
      | key             | value     |
      | grouping        | [3,0]     |
      | date_format     | %d.%m.%Y  |
      | thousands_sep   | '         |
      | decimal_point   | .         |
    Given I find a "res.lang" with code: it_IT
    And having:
      | key             | value     |
      | grouping        | [3,0]     |
      | date_format     | %d.%m.%Y  |
      | thousands_sep   | '         |
      | decimal_point   | .         |

  @company
  Scenario: Configure main partner and company
  Given I find a "res.company" with oid: base.main_company
    And having:
       | key                | value                 |
       | name               | Swisslux AG           |
       | street             | Industriestrasse 8    |
       | street2            |                       |
       | zip                | 8618                  |
       | city               | Oetwil am See         |
       | country_id         | by code: CH           |
       | phone              | +41 43 844 80 80      |
       | fax                | +41 43 844 80 81      |
       | email              | info@swisslux.ch      |
       | website            | www.swisslux.ch       |
       | vat                | CHE-107.897.036 MWST  |
       | company_registry   | CHE-107.897.036       |
       | rml_header1        |                       |    
    Given the company has the "images/company_logo.png" logo
    
    Given I need a "res.partner" with oid: base.main_partner
    And having:
       | key        | value                     |
       | name       | Swisslux AG               |
       | street     | Industriestrasse 8        |
       | street2    |                           |
       | zip        | 8618                      |
       | city       | Oetwil am See             |
       | country_id | by code: CH               |
       | phone      | +41 43 844 80 80          |
       | fax        | +41 43 844 80 81          |
       | email      | info@swisslux.ch          |
       | website    | www.swisslux.ch           |
       | lang       | de_DE                     |
       | company_id | by oid: base.main_company |
    Given I need a "res.partner" with oid: scenario.partner_swisslux_romandie
    And having:
       | key        | value                         |
       | name       | Swisslux SA                   |
       | street     | Chemin de la Grand Clos 17    |
       | street2    |                               |
       | zip        | 1092                          |
       | city       | Belmont-sur-Lausanne          |
       | country_id | by code: CH                   |
       | phone      | +41 21 711 23 40              |
       | fax        | +41 21 711 23 41              |
       | email      | info@swisslux.ch              |
       | website    | www.swisslux.ch               |
       | type       | other                         |
       | lang       | fr_FR                         |
       | parent_id  | by oid: base.main_partner     |
       | company_id | by oid: base.main_company     |
    And the partner has the "images/company_logo.png" image

  @modules
  Scenario: install modules
    Given I install the required modules with dependencies:
        | name                                 |
        # oca/ocb
        | account                               |
        | hr                                    |
        | hr_appraisal                          |
        | hr_contract                           |
        | hr_expense                            |
        | hr_holidays                           |
        | hr_recruitment                        |
        | hr_timesheet                          |
        | hr_timesheet_sheet                    |
        | l10n_ch                               |
        | mrp                                   |
        | purchase                              |
        | project                               |
        | project_issue                         |
        | sale                                  |
        | stock                                 |
        # oca/account-financial-tools
        #| account_credit_control               |
        #| account_compute_tax_amount           |
        # oca/account-financial-reporting
        #| account_financial_report_webkit      |
        #| account_financial_report_webkit_xls  |
        # oca/bank-payment
        | account_invoice_bank_selection       |
        # oca/carrier-delivery
        | delivery_carrier_label_postlogistics |
        # oca/l10n-switzerland
        | l10n_ch_bank                          |
        #| l10n_ch_dta                          |
        | l10n_ch_payment_slip                  |
        | l10n_ch_states                        |
        | l10n_ch_zip                           |
        # oca/server-tools
        #| disable_openerp_online               |
        # oca/web
        #| web_dialog_size                      |
        #| web_sheet_full_width                 |
        #| web_shortcuts                        |
        # specific-addons
        | specific_building_project             |
        | specific_hr                           |
        | specific_reports                      |

      
  @version
  Scenario: setup application version
    Given I set the version of the instance to "1.0.0"
