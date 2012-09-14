###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Copyright 2012 Camptocamp SA
#
##############################################################################
##############################################################################
# Branch      # Module       # Processes     # System
@base_commercial_management	    @so_creation


Feature: SALE ORDERS CREATION

  @SO1000
  Scenario: SO1000 CREATION
    Given I need a "sale.order" with name: SO1000 and oid: scenario.SO1000
    And having:
        | name                        | value                                     |
        | date_order                  | %Y-01-15                                  |      
        | name                        | SO1000                                    |
        | partner_id                  | by oid: scen.supplier_1                   |
        | pricelist_id                | by id: 1                                  |
        | partner_invoice_id          | by oid: scen.supplier_1_add               |
        | partner_order_id            | by oid: scen.supplier_1_add               |
        | partner_shipping_id         | by oid: scen.supplier_1_add               |
        | shop_id                     | by id: 1                                  |
    Given I need a "sale.order.line" with oid: scenario.SO1000_line1
    And having:
        | name                        | value                                     |
        | name                        | SO1000_line1                              |
        | product_id                  | by oid: scenario.p1                       |
        | price_unit                  | 100                                       |
        | product_uom_qty             | 5.0                                       |
        | product_uom                 | by name: PCE                              |
        | order_id                    | by oid: scenario.SO1000                   |
      
#    Given I have recorded on the %Y-01-15 a sale order of 500 EUR without tax called SO1000
#    And change the shipping policy to 'Shipping & Manual Invoice'
#    When I press the confirm button
#    Then I should see the sale order SO1000 manual in progress
#    And the total amount = 500,0
    
#    When I press the create invoice button from SO
#    Then I should see the sale order SO1000 in progress
#    And I should have a related draft invoice created
    
#    Given I take the related invoice
#    And change the description for SO1000_invoice and the date to 15 jan 2012
#    When I press the validate button
#    Then I should see the invoice SO1000_invoice open
    
  And I confirm the SO
  Then 1 picking should be created for the SO
  When I process the following product moves:
      | product             | qty | date     |
      | by oid: scenario.p1 |  5  | %Y-01-25 |

  # alternative shortcut:
  #When I process all moves on %Y-01-25
  
  And I create a customer invoice for the picking on %Y-01-25
  Then the picking should be in state done

    When I press the create invoice button from SO
    Then I should see the sale order SO1008 in progress
    And I should have a related draft invoice created

  
  # caution, the following step changes the focus to the invoice
  # if you want to do thing about the PO, you have to use a Given I find... line
  
#  And 1 draft invoice should be created for the SO
  
  # reuse an existing step which seems to be doing whe we want, but
  # the phrasing is weird as this is a supplier invoice
  
#  When I open the credit invoice  
  



##############################################################################################################
  @SO1008
  Scenario: Create a sale order manually
  Given I need a "sale.order" with name: SO1008 and oid: scenario.SO1008
  And having:
      | name                        | value                                     |
      | date_order                  | %Y-01-15                                  |      
      | name                        | SO1008                                    |
      | partner_id                  | by oid: scen.supplier_1                   |
      | pricelist_id                | by id: 1                                  |
      | partner_invoice_id          | by oid: scen.supplier_1_add               |
      | partner_order_id            | by oid: scen.supplier_1_add               |
      | partner_shipping_id         | by oid: scen.supplier_1_add               |
      | shop_id                     | by id: 1                                  |
  And containing the following sale order lines:
      | product_id          | product_qty | uom          | price_unit | date_planned |
      | by oid: scenario.p1 |          10 | by name: PCE |         75 | %Y-01-16     |

  When I confirm the SO
  Then 1 picking should be created for the SO

#  When I process the following product shipment:
#      | product             | qty | date     |
#      | by oid: scenario.p1 |  10 | %Y-01-25 |

# alternative shortcut:
  When I process all shipments on %Y-01-25
   
  When I press the create invoice button from SO
  Then I should see the sale order SO1008 in progress
  And I should have a related draft invoice created 
 

 