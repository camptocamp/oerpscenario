# -*- coding: utf-8 -*-
@swisslux @setup @accounting

Feature: Configure accounting

  @company_currency
  Scenario: Configure company currency
  Given I find a "res.company" with oid: base.main_company
    And having:
      | key         | value        |
      | currency_id | by name: CHF |

  @currencies
  Scenario: Configure multicurrency and add currencies
  Given I enable "Allow multi currencies" in "Accounting" settings menu
  Given I find an inactive "res.currency" with name: HKD
    And having:
      | key    | value |
      | active | True  |

  @account_chart_extended
  Scenario: Generate extended account chart for Swisslux AG
    Given "account.account" is imported from CSV "setup/account.account.csv" using delimiter ","

  @banks_del
  Scenario: Remove default Bank and Cash accounts
    Given I find a "account.account" with name: Bank
    And I delete it
    Given I find a "account.account" with name: Cash
    And I delete it

  @journal_del
  Scenario: Remove default Bank and Cash journals
    Given I find a "account.journal" with name: Bank
    And I delete it
    Given I find a "account.journal" with name: Cash
    And I delete it

  @bank_account
  Scenario Outline: Create account for Swisslux bank
    Given I need a "account.account" with oid: <account_oid>
    And having:
      | key             | value                 |
      | name            | <account_name>        |
      | code            | <account_code>        |
      | user_type_id    | by name: <user_type>  |

    Examples: Bank Accounts
      | account_oid             | account_name              | account_code  | user_type |
      | scenario.account_1010   | CCP 84-001285-1           | 1010          | Expenses  |
      | scenario.account_1020   | ZKB CH7400700115500086877 | 1020          | Expenses  |
      | scenario.account_1021   | ZKB CH2300700115500179557 | 1021          | Expenses  |

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

    Examples: Bank Accounts
      | journal_oid             | journal_code | journal_name | currency | acc_code | bank_oid        | l10n_ch_bank_id             | account_nr                 |
      | scenario.journal_POCH   | POCH         | Postfinance  | false    | 1010     | scenario.bank_1 | l10n_ch_bank.bank_9000_0000 | 84-001285-1                |
      | scenario.journal_ZKB1   | BNK1         | ZKB (ES)     | false    | 1020     | scenario.bank_2 | l10n_ch_bank.bank_730_0000  | CH74 0070 0115 5000 8687 7 |
      | scenario.journal_ZKB2   | BNK2         | ZKB          | false    | 1021     | scenario.bank_3 | l10n_ch_bank.bank_730_0000  | CH23 0070 0115 5001 7955 7 |

  @banks
  Scenario: configure BVR on the right bank
    Given I find a "res.partner.bank" with oid: scenario.bank_2
    And having:
      | key                 | value     |
      | bvr_adherent_num    | 933421    |
      | print_bank          | True      |
      | print_account       | True      |
      | print_partner       | True      |

  @bank_invoice
  Scenario: configure which bank account is set on customer invoices
    Given I need a "invoice.bank.rule" with oid: scenario.invoice_bank_rule_swiss
    And having:
      | key             | value                     |
      | name            | Bank for swiss customers  |
      | partner_bank_id | by oid: scenario.bank_2   |
      | country_id      | by code: CH               |
      | company_id      | by oid: base.main_company |

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
    
    Given I execute the SQL commands
      """
      DELETE FROM ir_property WHERE name='property_account_expense_id' AND res_id IS NULL;
      DELETE FROM ir_property WHERE name='property_account_income_id' AND res_id IS NULL;
      """

  @bvr
  Scenario: Configure the BVR on the company
    Given I find a "res.company" with oid: base.main_company
    And having:
      | key                             | value     |
      | bvr_delta_horz                  | 0.00      |
      | bvr_delta_vert                  | 0.00      |
      | bvr_scan_line_horz              | 0.00      |
      | bvr_scan_line_vert              | 0.00      |
      | bvr_scan_line_font_size         | 11        |
      | bvr_scan_line_letter_spacing    | 2.55      |
      | bvr_add_horz                    | 0.10      |
      | bvr_add_vert                    | 0.00      |
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
      
  @configure_sepa
  Scenario: modify pain value for Switzerland
    Given I find a "account.payment.method" with oid: account_banking_sepa_credit_transfer.sepa_credit_transfer
    And having:
      | key             | value                 |
      | pain_version    | pain.001.001.03.ch.02 |
      
    Given I need a "account.payment.mode" with oid: scenario.account_payment_mode_1
    And having:
      | key                         | value                         |
      | name                        | SEPA (ZKB)                    |
      | active                      | True                          |
      | no_debit_before_maturity    | False                         |
      | fixed_journal_id            | by oid: scenario.journal_ZKB1 |
      | generate_move               | True                          |
      | group_lines                 | True                          |
      | default_journal_ids         | add all by oid: scenario.expense_journal  |
      | default_journal_ids         | add all by oid: scenario.wage_journal     |
      | default_journal_ids         | add all by name: Vendor Bills             |
      | bank_account_link           | fixed                         |   
      | default_invoice             | False                         |
      | move_option                 | date                          |
      | offsetting_account          | bank_account                  |  
      | payment_method_id           | by oid: account_banking_sepa_credit_transfer.sepa_credit_transfer |
      | default_payment_mode        | same                          |
      | payment_order_ok            | True                          |
      | default_target_move         | posted                        |
      | default_date_type           | due                           |
  
