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
  Given I need a "purchase.order" with name: SI_CM31
  And having:
      | name               | value                               |
      | date_order         | %Y-01-15                            |
      | warehouse_id       | by id: 1                            |
      | location_id        | by name: Stock                      |
      | partner_id         | by oid: scen.supplier_1             |
      | partner_address_id | by oid: scen.partner_1_add          |
      | pricelist_id       | by name: Default Purchase Pricelist |
      | invoice_method     | picking                             |
  And containing the following purchase order lines:
      | product_id          | product_qty | price_unit | date_planned |
      | by oid: scenario.p1 |          10 |         75 | %Y-01-16     |

  When I confirm the PO
  # simple check peut etre pas indispensable
  Then 1 picking should be created for the PO
  # je voudrais que le stock move généré soit à la date indiqué ci-dessous
  When I process the following product moves:
      | product             | qty | date     |
      | by oid: scenario.p1 |  10 | %Y-01-25 |

  # alternative shortcut:
  #When I process all moves on %Y-01-25
  And I create a supplier invoice for the picking on %Y-01-25
  Then the picking should be in state done  
  # caution, the following step changes the focus to the invoice
  # if you want to do thing about the PO, you have to use a Given I find... line
  And 1 draft invoice should be created for the PO
  # reuse an existing step which seems to be doing whe we want, but
  # the phrasing is weird as this is a supplier invoice
  When I open the credit invoice
  # write me 

