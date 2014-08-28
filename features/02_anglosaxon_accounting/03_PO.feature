###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Copyright 2012 Camptocamp SA
#
##############################################################################
##############################################################################
# Branch      # Module       # Processes     # System
@anglosaxon_accounting_data_population


Feature: PURCHASE ORDERS CREATION

  @anglosaxon_PO011
  Scenario: Create a purchase order manually
  Given I need a "purchase.order" with name: PO011
  And having:
      | name               | value                               |
      | date_order         | %Y-01-15                            |
      | warehouse_id       | by id: 1                            |
      | location_id        | by name: Stock                      |
      | partner_id         | by oid: scen.supplier_1             |
      | partner_address_id | by oid: scen.supplier_1_add         |
      | pricelist_id       | by name: Default Purchase Pricelist |
      | invoice_method     | picking                             |
  And containing the following purchase order lines:
      | product_id          | product_qty | uom          | price_unit | date_planned |
      | by oid: scenario.p5 |          1  | by name: PCE |        345 | %Y-01-20     |

  When I confirm the PO
  Then 1 picking should be created for the PO
  When I process the following product moves:
      | product             | qty | date     |
      | by oid: scenario.p5 |  1  | %Y-01-25 |
  And I create a supplier invoice for the picking on %Y-01-25
  Then the picking should be in state done
  And 1 draft invoice should be created for the PO
  When I open the supplier invoice

  @anglosaxon_PO012
  Scenario: Create a purchase order manually
  Given I need a "purchase.order" with name: PO012
  And having:
      | name               | value                               |
      | date_order         | %Y-02-15                            |
      | warehouse_id       | by id: 1                            |
      | location_id        | by name: Stock                      |
      | partner_id         | by oid: scen.supplier_1             |
      | partner_address_id | by oid: scen.supplier_1_add         |
      | pricelist_id       | by name: Default Purchase Pricelist |
      | invoice_method     | picking                             |
  And containing the following purchase order lines:
      | product_id          | product_qty | uom          | price_unit | date_planned |
      | by oid: scenario.p5 |          1  | by name: PCE |        370 | %Y-02-20     |

  When I confirm the PO
  Then 1 picking should be created for the PO
  When I process the following product moves:
      | product             | qty | date     |
      | by oid: scenario.p5 |  1  | %Y-02-25 |
  And I create a supplier invoice for the picking on %Y-02-25
  Then the picking should be in state done
  And 1 draft invoice should be created for the PO
  When I open the supplier invoice
 