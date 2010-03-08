###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Copyright 2009 Camptocamp SA
#
##############################################################################

# Features Generic tags (none for all)
##############################################################################

# Module : commented because not always needed
# Run it with tag @quality
# @addons

# System
@quality
 
Feature Run quality tests provided by the editor
  In order to run the quality tests provided by base_module_quality
  I want to install the module and run the following tests
  
  Scenario: Install base_module_quality and run the tests
    Given I want to run the quality tests provided by base_module_quality on installed module
    When I install the base_module_quality
    And run the quality check on every installed module
    Then I should have a report on every module
    And all module, except base, should have a final score greater than 70.0 percent
    And above is a detailed summary of the results
    