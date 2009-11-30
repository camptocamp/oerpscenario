@account @addons  
Feature check pay invoice wizard
  In order to test the pay invoice wizard
  As an administator
  I want to see if the basics behaviors work
  
    @billing @account @addons 
    Scenario: make_and_validate_payments_with_pay_invoice_wizard
      Given I have recorded on the 1 jan 2009 a supplier invoice (in_invoice) of 1000,0 CHF without tax called MySupplierInvoicePayWizard
      When I press the valiate button
      And I call the Pay invoice wizard
      When I partially pay 200.0 CHF.- on the 10 jan 2009
      Then I should see a residual amount of 800.0 CHF.-