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
      And I have recorded on the 1 jan 2009 a supplier invoice (in_invoice) of 1000,0 CHF without tax called MySupplierInvoice

  @billing @account @addons 
  Scenario: validate_created_invoice
    Given I take the created invoice
    When I press the valiate button
    Then I should see the invoice MySupplierInvoice open
    And the residual amount = 1000,0
    