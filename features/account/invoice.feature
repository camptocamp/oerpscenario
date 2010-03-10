###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Copyright 2009 Camptocamp SA
#
##############################################################################

# Features Generic tags (none for all)
##############################################################################
# Branch      # Module       # Processes
@addons       @account       @invoicing

Feature Test the invoicing process
  In order to test the invoicing process and modules
  I want to see if the features work correctly

  # Scenario specific tags
  ##############################################################################
  @workflow @rounding
  Scenario: Validate the invoice creation and confirmation
	Given I have recorded on the 1 jan 2009 a supplier invoice (in_invoice) of 1000,0 CHF without tax called MySupplierInvoice
    When I press the validate button
    Then I should see the invoice MySupplierInvoice open
	And the residual amount = 1000,0
    Then I should have a linked account move with 2 lines and a posted status
    And the associated debit account move line should use the account choosen in the invoice line and have the following values:
    |debit|amount_currency|currency|status|
    |608.27|1000.0|CHF|valid|
    And the associated credit account move line should use the account of the partner account payable property and have the following values:
    |credit|amount_currency|currency|status|
    |608.27|-1000.0|CHF|valid|

  # Scenario specific tags
  ##############################################################################
  @workflow @rounding
  Scenario: Cancel and reset the invoice to draft and finally confirm it again
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

  # Scenario specific tags
  ##############################################################################
  @rounding @bug452854
  Scenario: Validate the rouding computation on an invoice with 3 lines
    Given I have recorded on the 11 oct 2009 a supplier invoice (in_invoice) of 1144.0 CHF without tax called MySupplierInvoiceRounding
    And I add a line called MyFirstLine on the last created invoice of 91.73
    And I add a line called MySecondLine on the last created invoice of 63.00
    And I correct the total amount of the invoice according to changes
    When I press the validate button
    Then I should see the invoice MySupplierInvoiceRounding open
    And the total credit amount must be equal to the total debit amount
	# Here we check the rounding to see if sum(rounded lines) == total invoice amount * current currency rate
    And the total amount convert into company currency must be same amount than the credit line on the payable/receivable account

  # Scenario specific tags
  ##############################################################################
  @reconciliation @bug524521
  Scenario: Try to cancel an invoice with a partial reconciliation done
    Given I have recorded on the 1 jan 2009 a supplier invoice (in_invoice) of 1000,0 CHF without tax called MySupplierInvoicePartialCancel
    When I press the validate button
    Then I should see the invoice MySupplierInvoicePartialCancel open
    And the residual amount = 1000,0

    When I call the Pay invoice wizard
    And I partially pay 200.0 CHF.- on the 10 jan 2009
    Then I should see a residual amount of 800.0 CHF.-

    When I press the cancel button it should raise a warning
	And because the invoice is partially reconciled the payments lines should be kept
    And I should see the invoice MySupplierInvoice open

  # Scenario specific tags
  ##############################################################################
  @tax @bug524278
  Scenario: Check the tax computation in foreign currency and change the tax amount
	Given I have recorded on the 10 sept 2009 a supplier invoice (in_invoice) of 1000.0 CHF without tax called MySupplierInvoiceTax
    And I add a line with tax called MyTaxLine on the last created invoice of 12156.0 with the tax called 'Buy 19.6%'
	When I compute the taxes on invoice
	Then I should have a invoice tax line with a base amount of 12156.0
	And a tax amount of 2382.58
	
	When I modify the tax amount to 2382.55
	Then I should have a invoice tax line with a base amount of 12156.0
	And a tax amount of 2382.55
	And a tax code amount of -1588.37
	And a tax base amount of -8104.0
	
	Given I correct the total amount of the invoice according to changes
	When I press the validate button
	Then I should see the invoice MySupplierInvoiceTax open
	And I should have a linked account move with 4 lines and a posted status

