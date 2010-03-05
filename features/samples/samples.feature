###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Copyright 2009 Camptocamp SA
#
##############################################################################

# Features Generic tags (none for all)
##############################################################################

# System
@sample

Feature Make some scenario samples
  In order to test my migration
  As an administator
  I want to see if the basics behaviors work  

    Scenario: Try to find a contact as define in base_contact module
      Given I made a search on object res.partner.contact 
      When I press search
      Then the result  should be > 0 

    Scenario: Create a partner and test some basic stuff
        Given I want to create a partner named automatedtest with default receivable account 
        Then I get a receivable account
        When I press create
        Then I should get a partner id
        And  I should get account_payable and pricelist proprety

    Scenario: Try to copy a partner
      Given I want to create a partner named copyautomatedtest 
      When I press create
      Then I should get a partner id
      And I copy the partner
      Then I should get a copied partner id

    Scenario: Try to create a product
        Given I want to create a prodcut named automatedtestprodcut
        Then I get a product category 
        When I press create
        Then I should get a product id
        And  I should get property_expense_account and property_income_account proprety

    Scenario: Describe a scenario about product copy but without implementing it
        Given I want to create a prodcut to copy named automatedtestprodcutcopy
        Then I get a product category 
        When I press create
        Then I should get a product id
        And I copy the product
        Then I should get a product id