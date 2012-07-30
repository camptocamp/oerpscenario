###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Copyright 2012 Camptocamp SA
#
##############################################################################
##############################################################################
# Branch      # Module       # Processes     # System
@addons

Feature: I create manually Purchase Orders

  @PO
  Scenario: Create a purchase order manually
  Given I need a "purchase.order" with name: SI_CM19
    And having:
      | name               | value                               |
      | date_order         | %Y-01-15                            |
      | warehouse_id       | by id: 1                            |
      | location_id        | by name: Stock                      |
      | partner_id         | by oid: scen.supplier_1             |
      | partner_address_id | by oid: scen.partner_1_add          |
      | pricelist_id       | by name: Default Purchase Pricelist |
      | invoice_method     | picking                             |


  Given I need a "purchase.order.line" with name: SI_CM19.line 1
    And having:
      | name         | value               |
      | order_id     | by name: SI_CM19     |
      | product_id   | by oid: scenario.p1 |
      | product_qty  | 10                  |
      | price_unit   | 75                  |
      | date_planned | %Y-01-16            |
  Given I find a "purchase.order" with name: SI_CM19
  And I confirm the PO
  # simple check peut etre pas indispensable
  Then 1 picking should be created for the PO
  # je voudrais que le stock move généré soit à la date indiqué ci-dessous
  Given I process the following product moves:
       | product             | qty | date     |
       | by oid: scenario.p1 |  10 | %Y-01-25 |

  # alternative shortcut:
  # Given I process all moves on %Y-01-25
  And I create a supplier invoice for the picking on %Y-01-25
  Then the picking should be in state done  
  # caution, the following step changes the focus to the invoice
  # if you want to do thing about the PO, you have to use a Given I find... line
  And 1 draft invoice should be created for the PO
  # reuse an existing step which seems to be doing whe we want, but
  # the phrasing is weird as this is a supplier invoice
  Then I open the credit invoice
  

