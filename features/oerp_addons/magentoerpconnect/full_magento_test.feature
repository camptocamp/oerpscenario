###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Copyright 2011 Camptocamp SA
#
##############################################################################

# Features Generic tags (none for all)
##############################################################################

# Branch      # Module       # Processes     # System
@magento

Feature: Create the Magento Instance and proceed to the initial synchronisations

  @init_magento
  Scenario: Create the Magento instance
    Given an instance with absolute id "base_external.customer" should exist
    Then I set the following attributes on the instance:
      |key|value|
      |name| 'customer' |
      |import_links_with_product| true | 
    And I set the instance referential type on "magento1500"
    And I set the instance default language on "fr_FR"
    And I set the instance default product category on "cat0"
    And I set an absolute id "base_external.customer" on the instance
    And I save the instance
    Then an instance with absolute id "base_external.customer" exists

    
  @mapping_templates
  Scenario: Load or reload the mapping templates
    Given an instance with absolute id "base_external.customer" exists
    Then I reload the referential mapping templates
    Then I reload the referential mapping templates


  @referential
  Scenario: Synchronize the referential settings (shop, website, views)
    Given an instance with absolute id "base_external.customer" exists
    Then I synchronize the referential settings


  @store_views
  Scenario: Configure store views
    Given a store view with code "default" exists
    Then I set the store view language on "fr_FR"
    And I save the store view
    Given a store view with code "customer_en" exists
    Then I set the store view language on "en_US"
    And I save the store view
    Given a store view with code "customer_de" exists
    Then I set the store view language on "de_DE"
    And I save the store view
    Given a store view with code "customer_es" exists
    Then I set the store view language on "es_ES"
    And I save the store view

  @attributes
  Scenario: Synchronize the attribute sets, groups, attributes and options
    Given an instance with absolute id "base_external.customer" exists
    Then I import the attribute sets
    Then I import the attribute groups
    Then I import the attributes


  @customer_groups
  Scenario: Import the customer groups from Magento
    Given an instance with absolute id "base_external.customer" exists
    Then I import the customer groups


  @product_categories
  Scenario: Import the product categories
    Given an instance with absolute id "base_external.customer" exists
    Then I import the product categories


  # we need the categories to configure the shops
  @shops
  Scenario: Configure shops
    Given a shop with name "Customer" exists
    Then I set the warehouse of the shop on "stock.warehouse0"
    And I set the price list of the shop on reference "product.list0"
    #And I set the root category of the shop on category with name "Default Category"
    And I set the following attributes on the shop:
      |key|value|
      | allow_magento_order_status_push | false |
      | auto_import | true |
      | order_prefix | 'fr' |
      | default_payment_method | '' |
      | is_tax_included        | true |
    And I save the shop
    Given a shop with name "customer_de" exists
    Then I set the warehouse of the shop on "stock.warehouse0"
    And I set the price list of the shop on reference "product.list0"
    And I set the following attributes on the shop:
      |key|value|
      | allow_magento_order_status_push | false |
      | auto_import | true |
      | order_prefix | 'de' |
      | default_payment_method | '' |
      | is_tax_included        | true |
    And I save the shop
    Given a shop with name "customer_en" exists
    Then I set the warehouse of the shop on "stock.warehouse0"
    And I set the price list of the shop on reference "uk_pricelist"
    And I set the following attributes on the shop:
      |key|value|
      | allow_magento_order_status_push | false |
      | auto_import | true |
      | order_prefix | 'en' |
      | default_payment_method | '' |
      | is_tax_included        | true |
    And I save the shop
    Given a shop with name "customer_es" exists
    Then I set the warehouse of the shop on "stock.warehouse0"
    And I set the price list of the shop on reference "product.list0"
    And I set the following attributes on the shop:
      |key|value|
      | allow_magento_order_status_push | false |
      | auto_import | true |
      | order_prefix | 'es' |
      | default_payment_method | '' |
      | is_tax_included        | true |
    And I save the shop

  @products
  Scenario: Import the products from Magento
    When an instance with absolute id "base_external.customer" exists
    Then I set the instance default product category on category with name "Root Catalog"
    And I save the instance
    Then I import the products
    #And I import the product images
    And I import the product links
