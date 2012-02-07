###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Copyright 2009 Camptocamp SA
#
##############################################################################

# Features Generic tags (none for all)
##############################################################################

@init_purchase
Feature: Initialize the settings for purchase module
  In order ensure the right state for the tests suite
  
  Scenario: install modules
    Given I update the module list
    Given I install the required modules with dependencies:
     | name |
     |purchase|
    Then my modules should have been installed and models reloaded
    Given I give all groups right access to admin user

