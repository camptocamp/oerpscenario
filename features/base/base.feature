###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Copyright 2009 Camptocamp SA
#
##############################################################################

@base 
Feature check_base
  In order to test the database integrity
      
  @properties
  Scenario: validate_properties
    Given I check the integrity of ir.property named property_product_pricelist
    Then I check the value of ir.property and it should not start with a space
    
  @base_contact
  Scenario: check_base_contact
    Given I made a search on object res.partner.contact 
    When I press search
    Then the result  should be > 0 
    
  @partner
  Scenario: create_partner
    Given I want to create a partner named automatedtest with default receivable account 
    Then I get a receivable account
    When I press create
    Then I should get a partner id
    And  I should get account_payable and pricelist proprety
