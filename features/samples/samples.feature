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
