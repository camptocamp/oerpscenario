###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Copyright 2009 Camptocamp SA
#
##############################################################################

@quality 
Feature run quality tests
  In order to run the quality tests provided by base_module_quality
  As an administator
  I want to install the module and run the following tests
  
  @quality
  Scenario: install_and_run_base_module_quality
    Given I want to run the quality tests provided by base_module_quality on installed module
    When I insall the base_module_quality
    And run the quality check on every installed module
    Then I should have a report on every module
    And all module, except base, should have a final score greater than 70.0 percent
    And above is a detailed summary of the results
    