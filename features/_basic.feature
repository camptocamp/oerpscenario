Feature check migration
  In order to test my migration
  As an administator
  I want to see if the basics behaviors work
  



  Scenario: check_contacts
    Given I am loged as admin user with password admin used
    And I made a search on object res.partner.contact 
    When I press search
    Then the result  should be > 0 


    Scenario: create_partner
        Given I am loged as admin user with password admin used
        And I want to create a partner name automatedtest with default receivable account 
        Then I get a receivable account
        When I press create
        Then I should get a partner id
        And  I should get account_payable and pricelist proprety


    Scenario: copy_partner
      Given I am loged as admin user with password admin used
      And I want to create a partner named copyautomatedtest 
      When I press create
      Then I should get a partner id
      And I copy the partner
      Then I should get a copied partner id


    Scenario: create_product
        Given I am loged as admin user with password admin used
        And I want to create a prodcut named automatedtestprodcut
        Then I get a product category 
        When I press create
        Then I should get a product id
        And  I should get property_expense_account and property_income_account proprety
        
    Scenario: copy_product
        Given I am loged as admin user with password admin used
        And I want to create a prodcut to copy named automatedtestprodcutcopy
        Then I get a product category 
        When I press create
        Then I should get a product id
        And I copy the product
        Then I should get a product id