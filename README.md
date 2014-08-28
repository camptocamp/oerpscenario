OERPScenario - Business Driven Development (BDD) for OpenERP/Odoo
=================================================================

OERPScenario is a tool to allows Business Driven Development (BDD). It allows
non-technical people to write real business cases, that will be tested among
OpenERP to ensure no regressions.

OERPScenario will allow us to detect regressions from one version to another by
running a test suites composed by scenario on a specified OpenERP server
(directly on the customer replication instance, or just on the last stable
release).

We also include in this brand new version written in Python and based on
Erppeek (http://erppeek.readthedocs.org/en/latest/) a complete DSL that allow
you to write tests at the speed of thought.

This means a business specialist can write something like the following:

    Scenario: SO013 CREATION
        Given I need a "sale.order" with name: SO013 and oid: scenario.anglosaxon_SO013
        And having:
            | name | value |
            | date_order | %Y-03-15 |
            | name | SO013 |
            | partner_id | by oid: scenario.customer_1 |
            | pricelist_id | by id: 1 |
            | partner_invoice_id | by oid: scenario.customer_1_add |
            | partner_order_id | by oid: scenario.customer_1_add |
            | partner_shipping_id | by oid: scenario.customer_1_add |
            | shop_id | by id: 1 |
        Given I need a "sale.order.line" with oid: scenario.anglosaxon_SO013_line1
        And having:
            | name | value |
            | name | SO013_line1 |
            | product_id | by oid: scenario.p5 |
            | price_unit | 450 |
            | product_uom_qty | 1.0 |
            | product_uom | by name: PCE |
            | order_id | by oid: scenario.anglosaxon_SO013 |
