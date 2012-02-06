###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Copyright 2011 Camptocamp SA
#
##############################################################################

# Features Generic tags (none for all)
##############################################################################

# Branch      # Module       # Processes     # System
@magento @init_magento

Feature: Create the Magento Instance and proceed to the initial synchronisations

  @instance
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
    
