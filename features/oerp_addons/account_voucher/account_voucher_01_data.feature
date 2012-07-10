###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Copyright 2009 Camptocamp SA
#
##############################################################################
##############################################################################
# Branch      # Module       # Processes     # System
@addons       @account_voucher       @account_voucher_date

Feature: In order to validate account voucher behavious as an admin user I prepare data
  @account_voucher_init
  Scenario: Install module
    Given I need a "ir.module.module" with name: account_voucher
    And having:
      |name|value|
      | demo | 1 |

    Given I install the required modules:
      | name                      |
      | account                   |
      | account_voucher           |
      | account_cancel            |

  @account_voucher_init
  Scenario: Lang Parameters
    Given I need a "res.lang" with code: en_US
    And having:
    | name        | value    |
    | date_format | %d/%m/%Y |
    | grouping    | [3,0]    |

  @account_voucher_init
  Scenario: Clean period
    Given I correct the period default set up (all special by default) :
    #UPDATE account_period SET special ='f' WHERE fiscalyear_id = 1;

  @account_voucher_init
  Scenario: Company setting
    Given I need a "res.company" with oid: base.main_company
    And having:
    | name                                 | value                                   |
    | expense_currency_exchange_account_id | by name: Foreign Exchange Loss - (test) |
    | income_currency_exchange_account_id  | by name: Foreign Exchange Gain - (test) |

  @account_voucher_init
  Scenario: Admin user right
    Given we select users below:
      | login |
      | admin |
    Then we assign all groups to the users
    And we activate the extended view on the users

  @account_voucher_init
  Scenario: Admin user right
    Given I set the following currency rates :
      | currency    |  rate  | date     |
      | EUR      | 1.0000 | 01-01-%Y |
      | USD      | 1.5000 | 01-01-%Y |
      | USD      | 1.8000 | 01-02-%Y |
      | USD      | 1.5000 | 01-03-%Y |
      | GBP      | 0.8000 | 01-02-%Y |
      | GBP      | 0.9000 | 01-02-%Y |
      | GBP      | 0.8000 | 01-02-%Y |

  @account_voucher_init
  Scenario: Account
    Given I need a "account.account" with oid: scen.voucher_usd
    And having:
    | name        | value            |
    | name        | USD bank account |
    | code        | X11010           |
    | parent_id   | by code: X101    |
    | type        | other            |
    | user_type   | by name: Cash    |
    | currency_id | by name: USD     |

    Given I need a "account.account" with oid: scen.voucher_gbp
    And having:
    | name        | value            |
    | name        | GBP bank account |
    | code        | X11011           |
    | parent_id   | by code: X101    |
    | type        | other            |
    | user_type   | by name: Cash    |
    | currency_id | by name: GBP     |

  @account_voucher_init
  Scenario: setting journals
   Given I need a "account.journal" with oid: scen.voucher_uds_journal
   And having:
     | name                      | value                           |
     | name                      | USD bank                        |
     | code                      | BUSD                            |
     | type                      | bank                            |
     | currency                  | by name: USD                    |
     | journal_user              | 1                               |
     | check_dtls                | 1                               |
     | default_debit_account_id  | by code: X11010                 |
     | default_credit_account_id | by code: X11010                 |
     | view_id                   | by name: Bank/Cash Journal View |

   Given I need a "account.journal" with oid: scen.voucher_uds_journal
   And having:
      | name                      | value                           |
      | name                      | GBP bank                        |
      | code                      | BGBP                            |
      | type                      | bank                            |
      | currency                  | by name: GBP                    |
      | journal_user              | 1                               |
      | check_dtls                | 1                               |
      | default_debit_account_id  | by code: X11011                 |
      | default_credit_account_id | by code: X11011                 |
      | view_id                   | by name: Bank/Cash Journal View |

   Given I allow cancelling entries on all journals
