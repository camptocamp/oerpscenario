###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Copyright 2012 Camptocamp SA
#
##############################################################################

# Features Generic tags (none for all)
##############################################################################

# Branch      # Module       # Processes     # System
Feature: Ensure base data are present for base config and tests as well
    Scenario: Create Suppliers, Resellers and Customers
    Given there is a partner named "Fournisseur Device" with the following attribute
        | key | value |
        | name | "Fournisseur Device" |
        | lang | "en_US" |
        | ref | "DCE" |
        | supplier | true |
        | customer | false |
        | active | true |
        And I set the and address with the following data for "Fournisseur Device":
        | key | value |
        | name | "Fournisseur Device" |
        | type | "default" |
        | street2 | "BOX ZU" |
        | street | "Street name XY" |
        | email | "mail@email.ch" |
        | active | true |

    Scenario: Create Customer Locations
    Given we create under "Partner Locations" the stock location "All Customers Locations" with
        | key | value |
        | scrap_location | false |
        | usage | "view" |
        | chained_location_type | "none" |
        | chained_auto_packing | "manual" |
        | active | true |
    And I affect the company "My Company" to the location "All Customers Locations"
    
    Given we move the stock location "Customers" under "All Customers Locations" and update it with
        | key | value |
        | name | "Customers" |
        | scrap_location | false |
        | usage | "customer" |
        | chained_location_type | "none" |
        | chained_auto_packing | "manual" |
        | active | true |
    And I affect the company "My Company" to the location "Customers"
 
    Scenario: Warehouses and setup supplier stock default properties
    Given we create a warehouse called "Mission Warehouse/Refurbishment" with the following attribute
        | key | value |
        | lot_output_id | "Supplier Mission Stock" |
        | lot_stock_id | "Supplier Mission Stock" |
        | lot_input_id | "Supplier Mission Stock" |
    And the related partner of the warehouse "Mission Warehouse/Refurbishment" is "Fournisseur Mission"
    And I affect the company "My Company" to the warhouse "Mission Warehouse/Refurbishment"

    Given the "property_stock_supplier" of the partner named "Fournisseur Device" is "Supplier Device Stock"
    And the "property_stock_supplier" of the partner named "Fournisseur Mission" is "Supplier Mission Stock"
