###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Copyright 2009 Camptocamp SA
#
##############################################################################

# Features Generic tags (none for all)
##############################################################################

# Branch      # Module       # Processes
@addons       @account       @reconciliation @invoicing

Feature Test the Bank statement
  In order to test the invoicing process and modules
  I want to see if the basic bank statement features works

  # Scenario specific tags
  ##############################################################################
  @bug491892
  Scenario: Reconcile a confirmed invoice using a bank statement
    Given I have recorded on the 1 jan 2009 a supplier invoice (in_invoice) of 1000,0 CHF without tax called MySupplierInvoiceBankStatement2
    When I press the validate button
    Then I should see the invoice MySupplierInvoiceBankStatement2 open
    And the residual amount = 1000,0
    
    When I create a new bank statement with a CHF account journal
    And import on the 10 jan 2009 the invoice called MySupplierInvoiceBankStatement2
    And confirm the statement and see it confirmed
    Then I should see the invoice MySupplierInvoiceBankStatement2 paid
    And the residual amount = 0,0
    And the invoice should appear as paid invoice (checkbox tic)
  
  # Scenario specific tags
  ##############################################################################
  @bug485281
  Scenario: Validate rollback entries when confirming a bank statement
    Given I have recorded on the 1 jan 2009 a supplier invoice (in_invoice) of 1000,0 CHF without tax called MyFirstSupplierInvoiceBankStatement
    When I press the validate button
    Then I should see the invoice MyFirstSupplierInvoiceBankStatement open
    And the residual amount = 1000,0

    Given I have recorded on the 1 jan 2009 a supplier invoice (in_invoice) of 1000,0 CHF without tax called MySecondSupplierInvoiceBankStatement
    When I press the validate button
    Then I should see the invoice MySecondSupplierInvoiceBankStatement open
    And the residual amount = 1000,0
    
    Given I create a new bank statement called MyBankStatement with a CHF account journal
    And I import on the 1 jan 2009, the following invoice (order matters) : MySecondSupplierInvoiceBankStatement, MyFirstSupplierInvoiceBankStatement
    Then I should see an draft bank statement with 2 lines
    
    Given I take the created invoice MyFirstSupplierInvoiceBankStatement
    When I call the Pay invoice wizard
    And I completely pay the residual amount in CHF on the 13 sep 2009
    Then I should see a residual amount of 0.0 CHF.-
    And I should see the invoice MyFirstSupplierInvoiceBankStatement paid
	And the invoice should appear as paid invoice (checkbox tic)
    
    Given I take the bank statement called MyBankStatement
    When push the confirm button of the statement it should raise a warning because one invoice is already reconciled
    And no entries should be created by the bank statement
    