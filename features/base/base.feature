###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Copyright 2009 Camptocamp SA
#
##############################################################################

@base 
Feature check base
  In order to test the database integrity
      
  @base
  Scenario: validate_properties
    Given I check the integrity of ir.property named property_product_pricelist
    Then I check the value of ir.property and it should not start with a space