# -*- coding: utf-8 -*-
@swisslux @setup @accounting

Feature: Configure CH accounting

  @currency
  Scenario: Configure company currency
  Given I find a "res.company" with oid: base.main_company
    And having:
      | key         | value        |
      | currency_id | by name: CHF |

  @account_chart_ch
  Scenario: Generate account chart for Swisslux AG
    Given I have the module account installed
    Then accounts should be available for company "Swisslux AG"

  @bank_account
  Scenario: create account 1010, 1020 and 1021
    Given I need an "account.account" with oid: scenario.account_1010
    And having:
      | key          | value                        |
      | name         | CCP 84-001285-1              |
      | code         | 1010                         |
      | user_type_id | by name: Expenses            |
    Given I need an "account.account" with oid: scenario.account_1020
    And having:
      | key          | value                        |
      | name         | ZKB CH7400700115500086877    |
      | code         | 1020                         |
      | user_type_id | by name: Expenses            |
    Given I need an "account.account" with oid: scenario.account_1021
    And having:
      | key          | value                        |
      | name         | ZKB CH2300700115500179557    |
      | code         | 1021                         |
      | user_type_id | by name: Expenses            |


  #@fiscalyear_ch
  #Scenario: create fiscal years
    #Given I need a "account.fiscalyear" with oid: scenario.fy2015_ch
    #And having:
    #| name       | value                     |
    #| name       | 2016                      |
    #| code       | 2016                      |
    #| date_start | 2016-01-01                |
    #| date_stop  | 2016-12-31                |
    #| company_id | by oid: base.main_company |

      
  @banks
  Scenario: Set the CCP on the bank
    Given I find a "res.bank" with oid: l10n_ch_bank.bank_730_0000
    And having:
      | key | value         |
      | ccp | 01-200027-2   |
  
  @banks    
  Scenario Outline: Create bank account for Swisslux AG
    Given I am configuring the company with ref "base.main_company"
    Given I need a "account.journal" with oid: <journal_oid>
    And having:
      | key                         | value                     |
      | name                        | <journal_name>            |
      | code                        | <journal_code>            |
      | type                        | bank                      |
      | company_id                  | by oid: base.main_company |
      | currency_id                 | <currency>                |
      | default_debit_account_id    | by code: <acc_code>       |
      | default_credit_account_id   | by code: <acc_code>       |
      | update_posted               | True                      |
    Given I need a "res.partner.bank" with oid: <bank_oid>
    And having:
      | key                 | value                     |
      | journal_id          | by oid: <journal_oid>     |
      | partner_id          | by oid: base.main_partner |
      | bank_id             | by oid: <l10n_ch_bank_id> |
      | company_id          | by oid: base.main_company |
      | acc_number          | <account_nr>              |
      | bvr_adherent_num    | <bvr>                     |
      | print_bank          | True                      |
      | print_account       | True                      |
      | print_partner       | True                      |

    Examples: Bank Accounts
      | journal_oid             | journal_code | journal_name | currency | acc_code | bank_oid        | l10n_ch_bank_id             | account_nr                 | bvr    |
      | scenario.journal_POCH   | POCH         | Postfinance  | false    | 1010     | scenario.bank_1 | l10n_ch_bank.bank_9000_0000 | 84-001285-1                |        |
      | scenario.journal_ZKB1   | BNK1         | ZKB (ES)     | false    | 1020     | scenario.bank_2 | l10n_ch_bank.bank_730_0000  | CH74 0070 0115 5000 8687 7 | 933421 |
      | scenario.journal_ZKB2   | BNK2         | ZKB          | false    | 1021     | scenario.bank_3 | l10n_ch_bank.bank_730_0000  | CH23 0070 0115 5001 7955 7 |        |

  @journal
  Scenario: Remove default Bank and Cash journals
    Given I find a "account.journal" with name: Bank
    And I delete it
    Given I find a "account.journal" with name: Cash
    And I delete it
    
  @journal
  Scenario Outline: create new financial journal
    Given I need a "account.journal" with oid: <journal_oid>
    And having:
      | key                         | value                     |
      | name                        | <journal_name>            |
      | code                        | <journal_code>            |
      | type                        | <journal_type>            |
      | company_id                  | by oid: base.main_company |
      | currency_id                 | <currency>                |      
      | update_posted               | True                      |

    Examples: Financial Journals
      | journal_oid             | journal_name  | journal_code  | journal_type  | currency |
      | scenario.expense_journal| Expenses      | EXP           | purchase      | false    |
      | scenario.wage_journal   | Wage          | WAGE          | purchase      | false    |
     
  
  @default_accounts
  Scenario Outline: Define default accounts via properties
    Given I set global property named "<name>" for model "<model>" and field "<name>" for company with ref "base.main_company"
    And the property is related to model "account.account" using column "code" and value "<account_code>"

    Examples: Defaults accounts for Swisslux AG
      | name                                 | model            | account_code |
      | property_account_receivable_id       | res.partner      |         1100 |
      | property_account_payable_id          | res.partner      |         2000 |
      | property_account_expense_categ_id    | product.category |         4200 |
      | property_account_income_categ_id     | product.category |         3200 |
      | property_stock_valuation_account_id  | product.category |         1260 |
      | property_stock_account_input         | product.template |         1260 |
      | property_stock_account_output        | product.template |         1260 |

  @bvr
  Scenario: Configure the BVR on the company
    Given I find a "res.company" with oid: base.main_company
    And having:
      | key                             | value     |
      | bvr_delta_horz                  | 0.00      |
      | bvr_delta_vert                  | 0.00      |
      | bvr_scan_line_horz              | 68.00     |
      | bvr_scan_line_vert              | 245.00    |
      | bvr_scan_line_font_size         | 11        |
      | bvr_scan_line_letter_spacing    | 2.55      |
      | bvr_add_horz                    | 10.00     |
      | bvr_add_vert                    | 70.00     |
      | bvr_background                  | True      |
      | merge_mode                      | in_memory |
      

  @account_cancel
  Scenario Outline: Activate account cancel on all financial journals
    Given I need a "account.journal" with code: <journal_code>
    And having:
      | key                       | value           |      
      | update_posted             | <update_posted> |

    Examples: Journals Accounts
      | journal_code    | update_posted |
      | INV             | True          |
      | BILL            | True          |
      | MISC            | True          |
      | EXCH            | True          |
      | STJ             | True          |
