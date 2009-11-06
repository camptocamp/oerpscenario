Feature test partner
  In order to test my demo
  As an administator
  I want to see if the partner named Mypartner exist and is Swiss
  


  Background: login
    Given I am loged as admin user with password admin used
    
  Scenario: check_partner
    Given I made a search on a partner named Mypartner 
    When I press search
    Then the result  should be true
    And the country code should be CH