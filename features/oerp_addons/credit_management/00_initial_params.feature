###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Copyright 2009 Camptocamp SA
#
##############################################################################
##############################################################################
# Branch      # Module       # Processes     # System
@addons       @credit_management

Feature: In order to validate account voucher behavious as an admin user I prepare data
  @account_voucher_addon_install
  Scenario: Install module
    Given I need a "ir.module.module" with name: account_credit_management
    And having:
      |name     | value |
      | demo    | 0     |

    Given I do not want all demo data to be loaded on install
    And I install the required modules with dependencies:
      | name                        |
      | account_voucher             |
      | account_accountant          |      
      | account_cancel              |
      | account_credit_management   |
    Then my modules should have been installed and models reloaded

  @account_voucher_init
  Scenario: Lang Parameters
    Given I need a "res.lang" with code: en_US
    And having:
    | name        | value    |
    | date_format | %d/%m/%Y |
    | grouping    | [3,0]    |
    
  @account_voucher_init
  Scenario: Admin user right
    Given we select users below:
      | login |
      | admin |
    Then we assign all groups to the users
    And we activate the extended view on the users
    
  Scenario: create fiscal year
    Given I need a "account.fiscalyear" with oid: scenario.fy2012
    And having:
    | name       | value      |
    | name       | 2012       |
    | code       | 2012       |
    | date_start | 2012-01-01 |
    | date_stop  | 2012-12-31 |

    And I create monthly periods on the fiscal year with reference "fy2012"
    Then I find a "account.fiscalyear" with oid: scenario.fy2012
    

  @account_voucher_init
  Scenario: Admin user right
    Given I set the following currency rates :
      | currency |   rate | date     |
      | EUR      | 1.0000 | %Y-01-01 |
      | USD      | 1.5000 | %Y-01-01 |
      | USD      | 1.8000 | %Y-02-01 |
      | USD      | 1.5000 | %Y-03-01 |
      | GBP      | 0.8000 | %Y-02-01 |
      | GBP      | 0.9000 | %Y-02-01 |
      | GBP      | 0.8000 | %Y-02-01 |


    
    
    

