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

Feature: Make some scenario samples
  In order to show you how to work with OERPScenario
  I want to illustrate the basics behaviors

  Scenario: Sample Create a partner and test some basic stuffs
    Given I want to show you how to use OERPScenario
    When I create a partner named automatedtest
    Then I should be able to find it by his id
    And the name should be automatedtest

  Scenario: Sample using the memorizer
    Given I am still in the same features and not the same scenario
    When I call the @partner variable I should not retrieve the partner

    Given I take the first found partner to set @partner variable
    And I store it into the memorizer as automatedtest in order to retrieve it in another scenario

    When I call back the memorizer to retieve the automatedtest variable
    Then I should have the same partner as contained into @partner variable

  Scenario: Sample using ResPartner Helper
    Given I want to show you how to use the Helpers
    When you need to look for a supplier partner with at least one contact
    Then you can use one of the ResPartner helper called get_valid_partner
    And get the corresponding partner very easily

  Scenario: Sample using object method like validate an invoice
    Given I have recorded a supplier invoice of 1000,0 EUR called MySampleSupplierInvoice using Helpers
    When I validate the invoice using the validate button
    Then I should get the invoice open

  Scenario: Sample to create and rename a partner
    Given I have created a partner named "Demour SA" with the following addresses:
      | name |
      | Luc  |
      | Marc |
    Then I expect the partner credit to be 0
    And I expect the partner debit to be 0
    When I change the partner name to "Demour sa"
    Then the partner name to be "Demour sa"

  Scenario: Sample to use sequel to establish a direct db connection
    Given I open a database connection with sequel
    When I select all the users
    Then I must have selected users

  Scenario: Sample to create a random resource with the generic sentences
    Given I need a "res.partner" with reference "partner_rincewind"
    When I update it with values:
      | key  | value       |
      | name | 'Rincewind' |
      | ref  | 'test'      |
      | lang | 'en_US'     |
    Then I save it

    Given I need a "res.partner.address" with reference "partner_address_rincewind"
    When I update it with values:
      | key        | value                   |
      | partner_id | ref 'partner_rincewind' |
      | function   | 'Wizzard'               |
      | country_id | name 'United Kingdom'   |
      | type       | 'default'               |
      | street     | 'Unseen University'     |
      | city       | 'Ankh-Morpork'          |
      | active     | true                    |
    Then I save it

  Scenario: Sample to execute raw SQL
    Given I execute following sql:
    """
      update res_partner set customer = True where not customer and not supplier;
      """
