###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Copyright 2009 Camptocamp SA
#
##############################################################################

# Features Generic tags (none for all)
##############################################################################
# Branch      # Module       # Processes                      # System
@addons       @account       @invoicing @reconciliation       @wizard

Feature: Test the pay invoice wizard
  In order to test the pay invoice wizard
  I want to see if the wizard take care of complex cases
  
    # Scenario specific tags
    ##############################################################################
    @bug511104 @bug496889 @bug497078 
    Scenario: Make payments in different currency with the pay invoice wizard
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
      