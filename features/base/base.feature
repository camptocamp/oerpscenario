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

Feature Control the base module
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
  @base_contact
  Scenario: Try to find a contact to see if base_contact module is installed
    Given I made a search on object res.partner.contact 
    When I press search
    Then the result  should be > 0 
  
  # Scenario specific tags
  ##############################################################################  
  @partner
  Scenario: Validate the partner creation
    Given I want to create a partner named automatedtest with default receivable account 
    Then I get a receivable account
    When I press create
    Then I should get a partner id
