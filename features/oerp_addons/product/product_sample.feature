###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Copyright 2009 Camptocamp SA
#
##############################################################################

# Features Generic tags (none for all)
##############################################################################

# Branch      # Module       # Processes     # System
@product @product_sample
Feature: Create the needed product
    Scenario: Test product categories
    Given there is a product category named "Devices"
    Given there is a product category named "Missions"

    Scenario: Create Device and Mission
    Given there is a product named "Device 1.0" with the following attributes :
         | key            | value           |
         | weight_net     | "0.0"           |
         | name           | "Device 1.0"    |
         | sale_ok        | false           |
         | sale_delay     | "7.0"           |
         | weight         | "0.0"           |
         | volume         | "0.0"           |
         | type           | "product"       |
         | purchase_ok    | true            |
         | produce_delay  | "1.0"           |
         | procure_method | "make_to_stock" |
         | supply_method  | "buy"           |
         | standard_price | "10.0"          |
         | warranty       | "0.0"           |
         | uos_coeff      | "1.0"           |
         | mes_type       | "fixed"         |
         | list_price     | "20.0"          |
         | cost_method    | "standard"      |
         | default_code   | "DEV1"          |
         | price_extra    | "0.0"           |
         | price_margin   | "1.0"           |
         | active         | true            |
         | is_device_lot  | true            |
    And product is in category "Devices"
    And the supplier of the product is "Fournisseur Device"
    


    Scenario: create Supplier 
    Given I need a "res.partner" with name: Pro living and oid: scenario.main_supplier
    And having
     | name       | value                           |
     | lang       | fr_FR                           |
     | company_id | by name: MyCompany |
     | supplier   | 1                               |

    Given I need a "res.partner.address" with name: Pro living and oid: scenario.main_supplier_add
    And having
     | name | value |
     | partner_id | by oid: scenario.main_supplier |
     | country_id | by code: FR |


    Scenario: Set product suplier rel on all product
     Given I set on supplier line on all product using supplier "scenario.main_supplier"

