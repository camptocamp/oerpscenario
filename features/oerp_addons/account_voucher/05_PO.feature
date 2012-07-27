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
  Given I need a "purchase.order" with oid: scen.po_1
    And having:
      | name               | value                               |
      | name               | SI_CM1                              |
      | date_order         | %Y-01-15                            |
      | warehouse_id       | by id: 1                            |
      | location_id        | by name: Stock                      |
      | partner_id         | by oid: scen.supplier_1             |
      | partner_address_id | by oid: scen.partner_1_add          |
      | pricelist_id       | by name: Default Purchase Pricelist |
      | invoice_method     | picking                             |


  Given I need a "purchase.order.line" with oid: scen.po_1_line_1
    And having:
      | name         | value               |
      | order_id     | by oid: scen.po_1   |
      | product_id   | by oid: scenario.p1 |
      | product_qty  | 10                  |
      | name         | invoice line po_1   |
      | price_unit   | 75                  |
      | date_planned | %Y-01-16            |
  Given I find a "purchase.order" with oid: scen.po_1 
  And I confirm the PO
  # simple check peut etre pas indispensable
  Then 1 picking should be created for the PO
  # je voudrais que le stock move généré soit à la date indiqué ci-dessous
  Then I receive the goods for the PO
      | date       | %Y-01-25            |
      | product_id | by oid: scenario.p1 |
      | qty        | 10                  |
  Given I validate the picking for the PO
  Then 1 draft invoice should be created for the PO
  Then I validate the invoice

