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
      
  @invoicing @account @addons @reconciliation
  Scenario: make_and_validate_payments_with_bank_statement
    Given I have recorded on the 1 jan 2009 a supplier invoice (in_invoice) of 1000,0 CHF without tax called MySupplierInvoiceBankStatement
    When I press the validate button
    Then I should see the invoice MySupplierInvoiceBankStatement open
    And the residual amount = 1000,0
    
    When I create a new bank statement with a CHF account journal
    And import on the 10 jan 2009 the invoice called MySupplierInvoiceBankStatement
    And confirm the statement and see it confirmed
    Then I should see the invoice MySupplierInvoiceBankStatement paid
    And the residual amount = 0,0
    And the invoice should appear as paid invoice (checkbox tic)
    
        # 
        # When I call the Pay invoice wizard
        # And I partially pay 200.0 CHF.- on the 10 jan 2009
        # Then I should see a residual amount of 800.0 CHF.-
        # 
        # When I call the Pay invoice wizard
        # And I partially pay 200.0 USD.- on the 11 jan 2009
        # Then I should see a residual amount of 561.48 CHF.-
        # 
        # When I call the Pay invoice wizard
        # And I partially pay 200.0 EUR.- on the 12 jan 2009
        # Then I should see a residual amount of 232.68 CHF.-
        # 
        # When I call the Pay invoice wizard
        # And I completely pay the residual amount in CHF on the 13 sep 2009
        # Then I should see a residual amount of 0.0 CHF.-
        # 