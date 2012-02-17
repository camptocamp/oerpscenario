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
