###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Copyright 2009 Camptocamp SA
#
##############################################################################

@base 
Feature check base
  In order to test the database structure problem
      
  @base
  Scenario: validate_properties
    Given /^Sometimes the properties of company are not well formed