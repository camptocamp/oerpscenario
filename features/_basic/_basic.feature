Feature basic action
  In order to do BDD
  As a power user
  I want to see if the basics behaviors work
  


  Background: login
    Given I am loged as admin user with password admin used
    
  Scenario: check_base_contact
    Given I made a search on object res.partner.contact 
    When I press search
    Then the result  should be > 0 

  Scenario: create_partner
      Given I want to create a partner named automatedtest with default receivable account 
      Then I get a receivable account
      When I press create
      Then I should get a partner id
      And  I should get account_payable and pricelist proprety
