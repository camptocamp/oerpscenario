###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Copyright 2009 Camptocamp SA
#
##############################################################################

# Features Generic tags (none for all)
##############################################################################
# Branch      # Module       # Processes     # System
@addons      @sale          @sales

Feature: Test sales process
  In order to test the sale process and modules
  As an administator
  I want to see if the sales features and workflow work well 
      
  Scenario: Validate a confirmed sale order
    Given I have recorded on the 1 jan 2009 a sale order of 1000,0 CHF without tax called MySimpleSO
    And change the shipping policy to 'Shipping & Manual Invoice'
    When I press the confirm button
    Then I should see the sale order MySimpleSO manual in progress
    And the total amount = 1000,0
    
    When I press the create invoice button from SO
    Then I should see the sale order MySimpleSO in progress
    And I should have a related draft invoice created
    
    Given I take the related invoice
    And change the description for SORelatedAccountCheck and the date to 1 jan 2009
    When I press the validate button
    Then I should see the invoice SORelatedAccountCheck open
    
    Given I take the related invoice
    Then I should have a linked account move with 2 lines and a posted status
    And the associated credit account move line should use the account choosen in the invoice line and have the following values:
    | debit  | amount_currency | currency | status |
    | 608.27 | -1000.0         | CHF      | valid  |
    And the associated debit account move line should use the account of the partner account payable property and have the following values:
    | credit | amount_currency | currency | status |
    | 608.27 | 1000.0          | CHF      | valid  |

  # Scenario specific tags
  ##############################################################################
  @workflow
  Scenario: Validate exception when cancelling a related invoice
    Given I have recorded on the 1 jan 2009 a sale order of 1000,0 CHF without tax called MyCanceledInvoiceSO
    And change the shipping policy to 'Shipping & Manual Invoice'
    When I press the confirm button
    Then I should see the sale order MyCanceledInvoiceSO manual in progress
    And the total amount = 1000,0
    
    When I press the create invoice button from SO
    Then I should see the sale order MyCanceledInvoiceSO in progress
    And I should have a related draft invoice created
    
    Given I take the related invoice
    And change the description for GeneratedBySO and the date to 1 jan 2009
    When I press the validate button
    Then I should see the invoice GeneratedBySO open
    
    Given I take the related invoice
    When I press the cancel button on this invoice
    Then I should see the invoice GeneratedBySO cancel 
    
    Given I take the related invoice
    When then I press the set to draft button
    Then I should see the invoice GeneratedBySO draft
    And the SO should be in invoice exception
    
    Given I take the related invoice
    When I press the validate button
    And then I press the invoice corrected button in the SO
    Then I should see the sale order MyCanceledInvoiceSO in progress
    
    
    
    
    
    
