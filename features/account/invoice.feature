###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Copyright 2009 Camptocamp SA
#
##############################################################################

@account @addons  
Feature check finance
  In order to test the invoicing process and modules
  As an administator
  I want to see if the basics behaviors work 
      
  @invoicing @account @addons @rounding
  Scenario: validate_created_invoice
    Given I have recorded on the 1 jan 2009 a supplier invoice (in_invoice) of 1000,0 CHF without tax called MySupplierInvoice
    When I press the validate button
    Then I should see the invoice MySupplierInvoice open
    And the residual amount = 1000,0
  
  @invoicing @account @addons
  Scenario: check_account_move_created_invoice
    Given I take the created invoice MySupplierInvoice
    Then I should have a linked account move with 2 lines and a posted status
    And the associated debit account move line should use the account choosen in the invoice line and have the following values:
    |debit|amount_currency|currency|status|
    |608.27|1000.0|CHF|valid|
    And the associated credit account move line should use the account of the partner account payable property and have the following values:
    |credit|amount_currency|currency|status|
    |608.27|-1000.0|CHF|valid|

  @invoicing @account @addons @workflow @rounding
  Scenario: cancel_recreate_created_invoice
    Given I take the created invoice MySupplierInvoice
    And the entries on the invoice related journal can be cancelled
     
    When I press the cancel button
    Then I should see the invoice MySupplierInvoice cancel
    And no more link on an account move
    
    When I press the set to draft button
    Then I should see the invoice MySupplierInvoice draft
	
	When I change the currency to EUR
	And I press the validate button
	Then I should see the invoice MySupplierInvoice open
	And the residual amount = 1000,0
    
  @addons @account @rounding
  Scenario: check_rounding_diff_multi_line_inv
    Given I have recorded on the 11 oct 2009 a supplier invoice (in_invoice) of 1144.0 CHF without tax called MySupplierInvoiceRounding
    And I add a line on the last created invoice of 91.73
    And I add a line on the last created invoice of 63.00
    And correct the total amount of the invoice according to changes
    When I press the validate button
    Then I should see the invoice MySupplierInvoiceRounding open
    And the total credit amount must be equal to the total debit amount
	# Here we check the rounding to see if sum(rounded lines) == total invoice amount * current currency rate
    And the total amount convert into company currency must be same amount than the credit line on the payable/receivable account







