###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Copyright 2009 Camptocamp SA
#
##############################################################################
##############################################################################
# Branch      # Module       # Processes     # System
@addons       @account_voucher       @account_voucher_addons @account_voucher_test201

Feature: In order to validate account voucher behavious as an admin user I prepare data
  @account_voucher_addon_install
  Scenario: Install module
    Given I need a "ir.module.module" with name: account_voucher
    And having:
      |name|value|
      | demo | 1 |

    Given I want all demo data to be loaded on install
    And I install the required modules with dependencies:
      | name               |
      | account_voucher    |
      | account_accountant |      
      | account_cancel     |
    Then my modules should have been installed and models reloaded

