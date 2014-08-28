###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Copyright 2009 Camptocamp SA
#
##############################################################################
##############################################################################
# Branch      # Module       # Processes     # System
@base_finance   @base_commercial_management

Feature: INITIAL SET-UP FOR NEW DATABASE

  @base_finance_create_db
  Scenario: CREATE DATABASE
    Given I create database from config file

  @base_finance_setup_install_modules
  Scenario: MODULES INSTALLATION

    Given I do not want all demo data to be loaded on install
    And I update the module list
    And I install the required modules with dependencies:
      | name                            |
      | account_voucher                 |
      | account_accountant              |
      | account_cancel                  |
      | purchase                        |
      | sale                            |
      | web_shortcuts                   |

    Then my modules should have been installed and models reloaded

  @base_finance_setup_languages
  Scenario: LANGUAGE INSTALL
    Given I install the following languages:
      | lang  |
      | fr_FR |
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

  @base_finance_setup_access_rights
  Scenario: USER RIGHTS SETTINGS
    Given we select users below:
      | login |
      | admin |
    Then we assign all groups to the users

  @base_finance_setup_create_fy
  Scenario: CREATION OF FISCAL YEAR 2012
    Given I need a "account.fiscalyear" with oid: scenario.fy2012
    And having:
    | name       | value      |
    | name       | 2012       |
    | code       | 2012       |
    | date_start | 2012-01-01 |
    | date_stop  | 2012-12-31 |

    And I create monthly periods on the fiscal year with reference "scenario.fy2012"
    Then I find a "account.fiscalyear" with oid: scenario.fy2012

  @base_finance_setup_create_fy
  Scenario: CREATION OF FISCAL YEAR 2013
    Given I need a "account.fiscalyear" with oid: scenario.fy2013
    And having:
    | name       | value      |
    | name       | 2013       |
    | code       | 2013       |
    | date_start | 2013-01-01 |
    | date_stop  | 2013-12-31 |

    And I create monthly periods on the fiscal year with reference "scenario.fy2013"
    Then I find a "account.fiscalyear" with oid: scenario.fy2013

  @base_finance_setup_currency_rates
  Scenario: CURRENCY RATES TYPE NAME CREATION (mainly for module account_multicurrency_revaluation)
    Given I need a "res.currency.rate.type" with oid: scen.average_fx_rate_type
    And having:
    | name                  | value          |
    | name                  | average        |

  @debug_taxes
  Scenario: CURRENCY RATES SETTINGS
    Given I set the following currency rates:
      | currency |   rate |       date | type    |
      | EUR      | 1.0000 | 2012-01-01 |         |
      | USD      | 1.5000 | 2012-01-01 |         |
      | USD      | 1.8000 | 2012-02-01 |         |
      | USD      | 1.5000 | 2012-03-01 |         |
      | USD      | 1.4000 | 2012-04-01 |         |
      | USD      | 1.4500 | 2012-05-01 |         |
      | USD      | 1.5500 | 2012-06-01 |         |
      | USD      | 1.5700 | 2012-07-01 |         |
      | USD      | 1.6000 | 2012-08-01 |         |
      | USD      | 1.6500 | 2012-09-01 |         |
      | USD      | 1.6300 | 2012-10-01 |         |
      | USD      | 1.6100 | 2012-11-01 |         |
      | USD      | 1.5700 | 2012-12-01 |         |
      | GBP      | 0.8000 | 2012-01-01 |         |
      | GBP      | 0.9000 | 2012-02-01 |         |
      | GBP      | 0.8000 | 2012-03-01 |         |
      | GBP      | 0.8200 | 2012-04-01 |         |
      | GBP      | 0.8300 | 2012-05-01 |         |
      | GBP      | 0.7900 | 2012-06-01 |         |
      | GBP      | 0.8400 | 2012-07-01 |         |
      | GBP      | 0.7600 | 2012-08-01 |         |
      | GBP      | 0.7700 | 2012-09-01 |         |
      | GBP      | 0.8900 | 2012-10-01 |         |
      | GBP      | 0.9200 | 2012-11-01 |         |
      | GBP      | 0.9500 | 2012-12-01 |         |
      | CAD      | 1.1500 | 2012-01-01 |         |
      | CAD      | 1.1700 | 2012-02-01 |         |
      | CAD      | 1.1900 | 2012-03-01 |         |
      | CAD      | 1.2000 | 2012-04-01 |         |
      | CAD      | 1.0500 | 2012-05-01 |         |
      | CAD      | 1.1000 | 2012-06-01 |         |
      | CAD      | 1.1800 | 2012-07-01 |         |
      | CAD      | 1.2200 | 2012-08-01 |         |
      | CAD      | 1.2400 | 2012-09-01 |         |
      | CAD      | 1.2600 | 2012-10-01 |         |
      | CAD      | 1.1600 | 2012-11-01 |         |
      | CAD      | 1.1300 | 2012-12-01 |         |
      | USD      | 1.6000 | 2012-01-31 | average |
      | USD      | 1.9000 | 2012-02-28 | average |
      | GBP      | 0.7000 | 2012-01-31 | average |
      | GBP      | 0.8000 | 2012-02-28 | average |
      | CAD      | 1.2500 | 2012-01-01 | average |
      | CAD      | 1.2700 | 2012-02-01 | average |

  @set_payment_term
  Scenario: PAYMENT TERM SETTINGS
    Given I need a "account.payment.term" with oid: account.account_payment_term
    And having:
    | name | value                |
    | name | 30 Days End of Month |
    | note | 30 Days End of Month |

    # 30 Days End of Month
    Given I need a "account.payment.term.line" with oid: account.account_payment_term_line
    And having:
    | name       | value                               |
    | value      | balance                             |
    | days       | 30                                  |
    | days2      | -1                                  |
    | payment_id | by oid: account.account_payment_term |



    Given I need a "account.payment.term" with oid: account.account_payment_term_advance
    And having:
    | name | value                   |
    | name | 30% Advance End 30 Days |
    | note | 30% Advance End 30 Days |
    # 30% Advance
    Given I need a "account.payment.term.line" with oid: account.account_payment_term_line_advance1
    And having:
    | name         |                                        value |
    | value        |                                      procent |
    | value_amount |                                     0.300000 |
    | days         |                                            0 |
    | days2        |                                            0 |
    | payment_id   | by oid: account.account_payment_term_advance |

    # Remaining Balance
    Given I need a "account.payment.term.line" with oid: account.account_payment_term_line_advance2
    And having:
    | name       | value                                        |
    | value      | balance                                      |
    | days       | 30                                           |
    | days2      | -1                                           |
    | payment_id | by oid: account.account_payment_term_advance |
