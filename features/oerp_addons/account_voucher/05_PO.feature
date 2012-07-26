###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Copyright 2009 Camptocamp SA
#
##############################################################################
##############################################################################
# Branch      # Module       # Processes     # System
@addons        

Feature: I create manually Purchase Orders

  @PO
  Scenario: Create a purchase order manually
  Given I need a "purchase.order" with oid: scen.po_1
    And having:
      | name               | value                              |
      | name               | SI_CM1                             |
      | date_order         | %Y-01-15                           |
      | warehouse_id       | 1                                  |
      | partner_id         | by oid: scen.supplier_1            |
      | pricelist_id       | by name: Default Purchase Pricelist|
      | invoice_method     | picking                            |


    Given I need a "purchase.order.line" with oid: scen.po_1_line_1
    And having:
      | name       | value                           |
      | product_id | by oid: scenario.p1             |
      | product_qty| 10                              |
      | name       | invoice line po_1               |
      | price      | 75                              |

  Then I validate the PO 
  And a pack should be created
  Then I receive the goods 
      | date       | %Y-01-25
      | product_id | by oid: scenario.p1             |
      | qty        | 10                              |
  And I validate the good reception
  
        
