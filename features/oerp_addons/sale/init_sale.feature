###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Copyright 2009 Camptocamp SA
#
##############################################################################

# Features Generic tags (none for all)
##############################################################################

@init_sale
Feature: Initialize the settings for sale module
  In order ensure the right state for the tests suite
  I want to set some parameters and settings
  
  Scenario: install modules
    Given I update the module list
    Given I install the required modules with dependencies:
     | name |
     |sale|
    Then my modules should have been installed and models reloaded
    Given I give all groups right access to admin user

  Scenario: Initialize Sales settings
      Given a cash journal in USD exists
      And a cash journal in CHF exists
      And a cash journal in EUR exists
      
      Given a valid sale pricelist in CHF exists
      And a valid sale pricelist in EUR exists
