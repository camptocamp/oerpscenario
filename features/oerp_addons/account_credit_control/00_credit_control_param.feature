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

    Given I do not want all demo data to be loaded on install
    And I install the required modules with dependencies:
      | name                            |
      | account_credit_management       |
    
    Then my modules should have been installed and models reloaded

