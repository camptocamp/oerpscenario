###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Copyright 2012 Camptocamp SA
#
##############################################################################
##############################################################################
# Branch      # Module       # Processes     # System
@base_finance_setup @base_comercial_mgmt


Feature: I create manually several Purchase Orders (PO)

  @PO000
  Scenario: Create a purchase order manually
  Given I need a "purchase.order" with name: PO1000
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
      | by oid: scenario.p1 |          10 | by name: PCE |         75 | %Y-01-16     |

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

  @PO001
  Scenario: Create a purchase order manually
  Given I need a "purchase.order" with name: PO1001
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
      | by oid: scenario.p1 |          10 | by name: PCE |         75 | %Y-01-20     |
      | by oid: scenario.p2 |          23 | by name: PCE |         35 | %Y-01-19     |
      | by oid: scenario.p3 |          36 | by name: PCE |         66 | %Y-01-26     |

  When I confirm the PO
  Then 1 picking should be created for the PO
  When I process all moves on %Y-01-25
  And I create a supplier invoice for the picking on %Y-01-25
  Then the picking should be in state done
  And 1 draft invoice should be created for the PO
  When I open the credit invoice

  @PO002
  Scenario: Create a purchase order manually
  Given I need a "purchase.order" with name: PO1002
  And having:
      | name               | value                               |
      | date_order         | %Y-01-02                            |
      | warehouse_id       | by id: 1                            |
      | location_id        | by name: Stock                      |
      | partner_id         | by oid: scen.supplier_2             |
      | partner_address_id | by oid: scen.supplier_2_add         |
      | pricelist_id       | by name: Default Purchase Pricelist |
      | invoice_method     | picking                             |
  And containing the following purchase order lines:
      | product_id          | product_qty | uom          |price_unit | date_planned |
      | by oid: scenario.p1 |          24 | by name: PCE |        87 | %Y-01-19     |
      | by oid: scenario.p2 |          43 | by name: PCE |        37 | %Y-01-19     |
      | by oid: scenario.p3 |          46 | by name: PCE |        62 | %Y-01-26     |
  When I confirm the PO
  Then 1 picking should be created for the PO
  When I process all moves on %Y-01-17
  And I create a supplier invoice for the picking on %Y-01-17
  Then the picking should be in state done
  And 1 draft invoice should be created for the PO
  When I open the credit invoice

  @PO003
  Scenario: Create a purchase order manually
  Given I need a "purchase.order" with name: PO1003
  And having:
      | name               | value                               |
      | date_order         | %Y-01-07                            |
      | warehouse_id       | by id: 1                            |
      | location_id        | by name: Stock                      |
      | partner_id         | by oid: scen.supplier_3             |
      | partner_address_id | by oid: scen.supplier_3_add         |
      | pricelist_id       | by name: Default Purchase Pricelist |
      | invoice_method     | picking                             |
  And containing the following purchase order lines:
      | product_id          | product_qty | uom          | price_unit | date_planned |
      | by oid: scenario.p1 |          14 | by name: PCE |         80 | %Y-01-26     |
      | by oid: scenario.p2 |          23 | by name: PCE |         31 | %Y-01-26     |
      | by oid: scenario.p3 |          16 | by name: PCE |         52 | %Y-01-25     |
  When I confirm the PO
  Then 1 picking should be created for the PO
  When I process all moves on %Y-01-27
  And I create a supplier invoice for the picking on %Y-01-27
  Then the picking should be in state done
  And 1 draft invoice should be created for the PO
  When I open the credit invoice

  @PO004
  Scenario: Create a purchase order manually
  Given I need a "purchase.order" with name: PO1004
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
      | by oid: scenario.p1 |          10 | by name: PCE |         75 | %Y-02-20     |
      | by oid: scenario.p2 |          23 | by name: PCE |         35 | %Y-02-19     |
      | by oid: scenario.p3 |          36 | by name: PCE |         66 | %Y-02-26     |

  When I confirm the PO
  Then 1 picking should be created for the PO
  When I process all moves on %Y-02-25
  And I create a supplier invoice for the picking on %Y-02-25
  Then the picking should be in state done
  And 1 draft invoice should be created for the PO
  When I open the credit invoice

  @PO005
  Scenario: Create a purchase order manually
  Given I need a "purchase.order" with name: PO1005
  And having:
      | name               | value                               |
      | date_order         | %Y-02-02                            |
      | warehouse_id       | by id: 1                            |
      | location_id        | by name: Stock                      |
      | partner_id         | by oid: scen.supplier_2             |
      | partner_address_id | by oid: scen.supplier_2_add         |
      | pricelist_id       | by name: Default Purchase Pricelist |
      | invoice_method     | picking                             |
  And containing the following purchase order lines:
      | product_id          | product_qty | uom          | price_unit | date_planned |
      | by oid: scenario.p1 |          24 | by name: PCE |         87 | %Y-02-19     |
      | by oid: scenario.p2 |          43 | by name: PCE |         37 | %Y-02-19     |
      | by oid: scenario.p3 |          46 | by name: PCE |         62 | %Y-02-26     |
  When I confirm the PO
  Then 1 picking should be created for the PO
  When I process all moves on %Y-02-17
  And I create a supplier invoice for the picking on %Y-02-17
  Then the picking should be in state done
  And 1 draft invoice should be created for the PO
  When I open the credit invoice

  @PO006
  Scenario: Create a purchase order manually
  Given I need a "purchase.order" with name: PO1006
  And having:
      | name               | value                               |
      | date_order         | %Y-02-07                            |
      | warehouse_id       | by id: 1                            |
      | location_id        | by name: Stock                      |
      | partner_id         | by oid: scen.supplier_3             |
      | partner_address_id | by oid: scen.supplier_3_add         |
      | pricelist_id       | by name: Default Purchase Pricelist |
      | invoice_method     | picking                             |
  And containing the following purchase order lines:
      | product_id          | product_qty | uom          | price_unit | date_planned |
      | by oid: scenario.p1 |          14 | by name: PCE |         80 | %Y-02-26     |
      | by oid: scenario.p2 |          23 | by name: PCE |         31 | %Y-02-26     |
      | by oid: scenario.p3 |          16 | by name: PCE |         52 | %Y-02-25     |
  When I confirm the PO
  Then 1 picking should be created for the PO
  When I process all moves on %Y-02-27
  And I create a supplier invoice for the picking on %Y-02-27
  Then the picking should be in state done
  And 1 draft invoice should be created for the PO
  When I open the credit invoice
