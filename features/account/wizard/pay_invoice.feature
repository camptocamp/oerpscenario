###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Copyright 2009 Camptocamp SA
#
##############################################################################

@account @addons  
Feature check pay invoice wizard
  In order to test the pay invoice wizard
  As an administator
  I want to see if the basics behaviors work
  
    @invoicing @account @addons @wizard @reconciliation
    Scenario: make_and_validate_payments_with_pay_invoice_wizard
      Given I have recorded on the 1 jan 2009 a supplier invoice (in_invoice) of 1000,0 CHF without tax called MySupplierInvoicePayWizard
      When I press the validate button
      Then I should see the invoice MySupplierInvoicePayWizard open

      When I call the Pay invoice wizard
      And I partially pay 200.0 CHF.- on the 10 jan 2009
      Then I should see a residual amount of 800.0 CHF.-
      
      When I call the Pay invoice wizard
      And I partially pay 200.0 USD.- on the 11 jan 2009
      Then I should see a residual amount of 561.48 CHF.-
      
      When I call the Pay invoice wizard
      And I partially pay 200.0 EUR.- on the 12 jan 2009
      Then I should see a residual amount of 232.68 CHF.-
      
      When I call the Pay invoice wizard
      And I completely pay the residual amount in CHF on the 13 sep 2009
      Then I should see a residual amount of 0.0 CHF.-
      And I should see the invoice MySupplierInvoicePayWizard paid
      