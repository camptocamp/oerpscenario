###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Copyright 2011 Camptocamp SA
#
##############################################################################

# Features Generic tags (none for all)
##############################################################################

# Branch      # Module       # Processes     # System
@magento @synchro_magento

Feature: Do the Magento initial synchronisations

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