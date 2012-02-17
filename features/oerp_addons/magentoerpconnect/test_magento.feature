###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Copyright 2011 Camptocamp SA
#
##############################################################################

# Features Generic tags (none for all)
##############################################################################

# Branch      # Module       # Processes     # System
@test_magento @synchro_magento

Feature: Do the Magento initial synchronisations
  @referential_magento
  Scenario: Synchronize the referential settings (shop, website, views)
    Given an instance with absolute id "base_external.magento" exists
    Then I synchronize the referential settings (2 - Synchronize Referential Settings)
  
  @store_views_magento
  Scenario: Configure store views
    Given a store view with code "default" exists
    Then I set the store view language on "en_US"
    And I save the store view
 
  @customer_groups_magento
  Scenario: Import the customer groups from Magento
    Given an instance with absolute id "base_external.magento" exists
    Then I import the customer groups (1 - Import Customer Groups (Partner Categories))

  @product_categories_magento
  Scenario: Import the product categories
    Given an instance with absolute id "base_external.magento" exists
    Then I import the product categories (2 - Import Product Categories)

  @attributes_magento
  Scenario: Synchronize the attribute sets, groups, attributes and options
    Given an instance with absolute id "base_external.magento" exists
    Then I import the attribute sets (3 - Import Product Attribute Sets)
    Then I import the attribute groups (4 - Import Attribute Groups)
    Then I import the attributes (5 - Import Product Attributes)

  # we need the categories to configure the shops
  @shops_magento
  Scenario: Configure shops
    Given a shop with name "Main Website Store" exists
    Then I set the warehouse of the shop on "stock.warehouse0"
    And I set the price list of the shop on reference "product.list0"
    #And I set the root category of the shop on category with name "Default Category"
    And I set the following attributes on the shop:
      | key                             | value |
      | allow_magento_order_status_push | false |
      | auto_import                     | true  |
      | order_prefix                    | 'en'  |
      | default_payment_method          | ''    |
      | is_tax_included                 | true  |
    And I save the shop

  @products_import_magento
  Scenario: Import the products from Magento
    When an instance with absolute id "base_external.magento" exists
    Then I set the instance default product category on category with name "Root Catalog"
    And I save the instance
    Then I import the products (6 - Import Products)
    And I import the product images (7 - Import Images)
    And I import the product links (8 - Import Product Links)
    
  @sale_config_magento
  Scenario: Set options for payment type to validate the process
    Given I the payment type with the name "Essaie" exists
    When I set the following options:
      | key               | value      |
      | picking_policy    | 'one'      |
      | order_policy      | 'postpaid' |
      | invoice_quantity  | 'order'    |
      | validate_order    | true       |
      | validate_picking  | true       |
      | create_invoice    | true       |
      | validate_payment  | true       |
      | is_auto_reconcile | true       |
    And I set the payment journal on "EUR C"
    Then I save the payment type

  @sale_import_magento
  Scenario: Import the sales orders from Magento
    When an instance with absolute id "base_external.magento" exists
    And a shop with name "Main Website Store" exists
    Then I import the sale orders (Import Orders)
    Then the sale orders should have been created
    Then I should see this sale order order_name open

  @sale_statut_magento
  Scenario: Export the sale order status and verify it in magento
#    Given I have test state
#    export statut
#    check magento statut
#    check magento packing

#  @invoicing_process_magento
#Then /^I should have a related draft invoice created$/ do
#Given /^I take the related invoice$/ do
#    open invoice
#    check reconcile
#    export statut
#    check magento statut
#    check magento invoice
