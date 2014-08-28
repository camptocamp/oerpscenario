###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Copyright 2009 Camptocamp SA
#
##############################################################################
##############################################################################
# Branch      # Module       # Processes     # System
@anglosaxon_accounting

Feature: INITIAL SET-UP FOR NEW DATABASE

  @anglosaxon_install_module
  Scenario: MODULES INSTALLATION FOR ANGLO-SAXON ACCOUNTING

    Given I do not want all demo data to be loaded on install
    And I install the required modules with dependencies:
      | name                            |
      | account_anglo_saxon             |
                      
    Then my modules should have been installed and models reloaded


   