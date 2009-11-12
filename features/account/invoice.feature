@account @addons  
Feature check finance
  In order to test the invoicing process and modules
  As an administator
  I want to see if the basics behaviors work 
  
  @account @addons @billing 
  Background:
      Given I am loged as admin user with password admin used
      And the company currency is set to EUR 
      And the following currency rate settings are:
      |code|rate|name|
      |EUR|1.000|01-01-2009|
      |CHF|1.644|01-01-2009|
      |CHF|1.500|09-09-2009|

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
  Scenario: make_and_validate_payments_with_bank_statement
    Given I take the created invoice MySupplierInvoice
    And I make a new bank statement


  @billing @account @addons 
  Scenario: make_and_validate_payments_with_pay_invoice_wizard
    Given I take the created invoice MySupplierInvoice
    And I call the Pay invoice wizard

    
    