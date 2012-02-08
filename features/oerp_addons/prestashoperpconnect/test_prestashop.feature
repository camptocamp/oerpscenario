###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Copyright 2011 Camptocamp SA
#
##############################################################################

# Features Generic tags (none for all)
##############################################################################

# Branch      # Module       # Processes     # System
@test_prestashop @synchro_prestashop

Feature: Do the Prestashop initial synchronisations
  @referential
  Scenario: Synchronize the referential settings (shop, website, views)
    Given an instance with absolute id "base_external.prestashop" exists
    Then I synchronize the referential settings (2 - Synchronize Referential Settings)
  
  @store_views
  Scenario: Configure store views
    Given a store view with code "default" exists
    Then I set the store view language on "en_US"
    And I save the store view
 
  @customer_groups
  Scenario: Import the customer groups from Prestashop
    Given an instance with absolute id "base_external.prestashop" exists
    Then I import the customer groups (1 - Import Customer Groups (Partner Categories))

  @product_categories
  Scenario: Import the product categories
    Given an instance with absolute id "base_external.prestashop" exists
    Then I import the product categories (2 - Import Product Categories)

  @attributes
  Scenario: Synchronize the attribute sets, groups, attributes and options
    Given an instance with absolute id "base_external.prestashop" exists
    Then I import the attribute sets (3 - Import Product Attribute Sets)
    Then I import the attribute groups (4 - Import Attribute Groups)
    Then I import the attributes (5 - Import Product Attributes)

  # we need the categories to configure the shops
  @shops
  Scenario: Configure shops
    Given a shop with name "Main Website Store" exists
    Then I set the warehouse of the shop on "stock.warehouse0"
    And I set the price list of the shop on reference "product.list0"
    #And I set the root category of the shop on category with name "Default Category"
    And I set the following attributes on the shop:
      |key|value|
      | allow_magento_order_status_push | false |
      | auto_import | true |
      | order_prefix | 'en' |
      | default_payment_method | '' |
      | is_tax_included        | true |
    And I save the shop

  @products_import
  Scenario: Import the products from Prestashop
    When an instance with absolute id "base_external.prestashop" exists
    Then I set the instance default product category on category with name "Root Catalog"
    And I save the instance
    Then I import the products (6 - Import Products)
    And I import the product images (7 - Import Images)
    And I import the product links (8 - Import Product Links)
    
  @sale_import
  Scenario: Import the sales oders from Prestashop
    When an instance with absolute id "base_external.prestashop" exists
    And a shop with name "Main Website Store" exists
    Then I import the products sale orders (Import Orders)

    
