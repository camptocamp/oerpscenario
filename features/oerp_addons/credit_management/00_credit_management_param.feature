###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Copyright 2009 Camptocamp SA
#
##############################################################################
##############################################################################
# Branch      # Module       # Processes     # System
@credit_management    

Feature: In order to validate account voucher behavious as an admin user I prepare data
    
 @credit_management_setup_install_modules
  Scenario: MODULES INSTALLATION

                   
    Then my modules should have been installed and models reloaded
  Scenario: Create data
    Given I need a "ir.module.module" with name: account_credit_management
    And having:
      |name|value|
      | demo | 1 |
    Given I install the required modules with dependencies:
      | name |
      | account_credit_management |
'      Then my modules should have been installed and models reloaded