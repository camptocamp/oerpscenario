###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Copyright 2012 Camptocamp SA
#
##############################################################################
##############################################################################
# Branch      # Module       # Processes     # System
@anglosaxon_accounting_data_population


Feature: SALE ORDERS CREATION

  @anglosaxon_SO013
  Scenario: SO013 CREATION
    Given I need a "sale.order" with name: SO013 and oid: scenario.anglosaxon_SO013
    And having:
        | name                        | value                                     |
        | date_order                  | %Y-03-15                                  |      
        | name                        | SO013                                     |
        | partner_id                  | by oid: scen.customer_1                   |
        | pricelist_id                | by id: 1                                  |
        | partner_invoice_id          | by oid: scen.customer_1_add               |
        | partner_order_id            | by oid: scen.customer_1_add               |
        | partner_shipping_id         | by oid: scen.customer_1_add               |
        | shop_id                     | by id: 1                                  |
    Given I need a "sale.order.line" with oid: scenario.anglosaxon_SO013_line1
    And having:
        | name                        | value                                     |
        | name                        | SO013_line1                               |
        | product_id                  | by oid: scenario.p5                       |
        | price_unit                  | 450                                       |
        | product_uom_qty             | 1.0                                       |
        | product_uom                 | by name: PCE                              |
        | order_id                    | by oid: scenario.anglosaxon_SO013         |
      
# pas de phrase prete pour la suite