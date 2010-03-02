###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Copyright 2009 Camptocamp SA
#
##############################################################################

@sale @addons  
Feature Test Sales
  In order to test the sale process and modules
  As an administator
  I want to see if the sales features and workflow work well 
      
  Scenario: confirm_basic_sale_order
	Given I have recorded on the 1 jan 2009 a sale order of 1000,0 CHF without tax called MySimpleSO
    When I press the confirm button
    Then I should see the sale order MySimpleSO open
	And the total amount = 1000,0
    # Then I should have a linked account move with 2 lines and a posted status
    # And the associated debit account move line should use the account choosen in the invoice line and have the following values:
    # |debit|amount_currency|currency|status|
    # |608.27|1000.0|CHF|valid|
    # And the associated credit account move line should use the account of the partner account payable property and have the following values:
    # |credit|amount_currency|currency|status|
    # |608.27|-1000.0|CHF|valid|
