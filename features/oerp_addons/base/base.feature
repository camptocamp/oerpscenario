###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Copyright 2009 Camptocamp SA
#
##############################################################################

# Features Generic tags (none for all)
##############################################################################

# Branch      # Module       # Processes     # System
@addons       @base

Feature: Control the base module
  In order to test the basic features of the base module
  I want to make some basic tests

  # Scenario specific tags
  ##############################################################################
  @properties
  Scenario: Validate the model ir.property into the DB
    Given I check the integrity of ir.property named property_product_pricelist
    Then I check the value of ir.property and it should not start with a space


  # Scenario specific tags
  ##############################################################################  
  @partner
  Scenario: Validate the partner creation
    Given I want to create a partner named automatedtest with default receivable account 
    Then I get a receivable account
    And I should get a partner id
