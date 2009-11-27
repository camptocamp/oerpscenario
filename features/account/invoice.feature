@account @addons  
Feature check finance
  In order to test the invoicing process and modules
  As an administator
  I want to see if the basics behaviors work 
      
  @billing @account @addons 
  Scenario: validate_created_invoice
    Given I have recorded on the 1 jan 2009 a supplier invoice (in_invoice) of 1000,0 CHF without tax called MySupplierInvoice
    When I press the valiate button
    Then I should see the invoice MySupplierInvoice open
    And the residual amount = 1000,0
  
  @billing @account @addons 
  Scenario: check_account_move_created_invoice
    Given I take the created invoice MySupplierInvoice
    Then I should have a linked account move with 2 lines and a posted status
    And the associated debit account move line should use the account choosen in the invoice line and have the following values:
    |debit|amount_currency|currency|status|
    |608.27|1000.0|CHF|valid|
    And the associated credit account move line should use the account of the partner account payable property and have the following values:
    |credit|amount_currency|currency|status|
    |608.27|-1000.0|CHF|valid|

  @billing @account @addons 
  Scenario: make_and_validate_payments_with_pay_invoice_wizard
    Given I take the created invoice MySupplierInvoice
    And I call the Pay invoice wizard
    When I partially pay 200.0 CHF.- on the 10 jan 2009
    Then I should see a residual amount of 800.0 CHF.-

    
    