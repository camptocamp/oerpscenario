###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Copyright 2009 Camptocamp SA
#
##############################################################################

@sample @testpartnersample
Feature test partner
  In order to test my demo
  As an administator
  I want to see if the partner named Mypartner exist and is Swiss
  

  @testpartnersample
  Background: login
    I am loged as admin user with the password set in config used
  @testpartnersample  
  Scenario: check_partner
    Given I made a search on a partner named Mypartner 
    When I press search
    Then the result  should be true
    And the country code should be CH