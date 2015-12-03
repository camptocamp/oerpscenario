# -*- coding: utf-8 -*-
###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Copyright 2015 Camptocamp SA
#
##############################################################################
@swisslux @setup @accounting

Feature: Configure CH accounting

  @account_chart_ch
  Scenario: Generate account chart for Swisslux AG
    Given I have the module account installed
    And I want to generate account chart from chart template named "Plan comptable 2015" with "4" digits for company "Swisslux AG"
    When I generate the chart
    Then accounts should be available for company "Swisslux AG"

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

  @banks
  Scenario Outline: Create bank account for Swisslux AG
    Given I am configuring the company with ref "base.main_company"
    Given I need a "account.journal" with oid: <journal_oid>
    And having:
      | key                       | value                     |
      | name                      | <journal_name>            |
      | code                      | <journal_code>            |
      | type                      | bank                      |
      | company_id                | by oid: base.main_company |
      | currency_id               | <currency>                |
      | default_debit_account_id  | by code: <acc_code>       |
      | default_credit_account_id | by code: <acc_code>       |
      | allow_date                | false                     |
    Given I need a "res.partner.bank" with oid: <bank_oid>
    And having:
      | key        | value                         |
      | journal_id | by oid: <journal_oid>         |
      | partner_id | by oid: base.main_partner     |
      | bank       | by oid: l10n_ch_bank.bank1215 |
      | bank_name  | <bank_name>                   |
      | company_id | by oid: base.main_company     |
      | street     | Industrialstrasse 8           |
      | zip        | 8618                          |
      | city       | Oetwil am See                 |
      | country_id | by code: CH                   |
      | state      | bank                          |
      | acc_number | <iban>                        |
      | bank_bic   | <bic>                         |

    Examples: Bank Accounts
      | journal_oid                     | journal_code | journal_name | currency | acc_code | bank_oid                     | bank_name           | iban                       | bic         |
      | scenario.journal_service_client | XXXX         | Bank CHF     | false    | 1020     | scenario.bank_service_client | Zücher Kantonalbank | CH74 0070 0115 5000 8687 7 | ZKBKCHZZ80A |

  @default_accounts
  Scenario Outline: Define default accouts via properties
    Given I set global property named "<name>" for model "<model>" and field "<name>" for company with ref "base.main_company"
    And the property is related to model "account.account" using column "code" and value "<account_code>"

    Examples: Defaults accouts for Swisslux AG
      | name                                 | model            | account_code |
      | property_account_receivable          | res.partner      |         1100 |
      | property_account_payable             | res.partner      |         2000 |
      | property_account_expense_categ       | product.category |         4200 |
      | property_account_income_categ        | product.category |         3200 |
      | property_stock_valuation_account_id  | product.category |         1260 |
      | property_stock_account_input         | product.template |         1260 |
      | property_stock_account_output        | product.template |         1260 |
