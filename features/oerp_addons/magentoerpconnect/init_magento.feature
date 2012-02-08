###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Copyright 2011 Camptocamp SA
#
##############################################################################

# Features Generic tags (none for all)
##############################################################################

# Branch      # Module       # Processes     # System
@init_magento
Feature: Create the Magento Instance and proceed to the initial synchronisations
    In order to have a coherent installation
    I autmated the manual steps.
    
  Scenario: install modules
    Given I update the module list
    Given I install the required modules with dependencies:
     | name |
     |magentoerpconnect|
     |product_m2mcategories|
     |delivery|
     |base_sale_multichannels|
     |product_images_olbs|
     |product_links|
    Then my modules should have been installed and models reloaded
    Given I give all groups right access to admin user


  @instance
  Scenario: Create the Magento instance
    Given an instance with absolute id "base_external.magento" should exist
    Then I set the following attributes on the instance:
      |key|value|
      |name| 'Magento' |
      |import_links_with_product| true | 
      |location| 'http://192.168.0.15:8080' |
      |apiusername| 'openerp_connect' |
      |apipass| 'openerp_connect' |
      
    And I set the instance referential type on "magento1500"
    And I set the instance default language on "en_US"
    And I set the instance default product category on "cat0"
    And I set an absolute id "base_external.magento" on the instance
    And I save the instance
    Then an instance with absolute id "base_external.magento" exists

    
  @mapping_templates
  Scenario: Load or reload the mapping templates
    Given an instance with absolute id "base_external.magento" exists
    Then I reload the referential mapping templates (1 - Reload Referential Mapping Templates)
    Then I reload the referential mapping templates (1 - Reload Referential Mapping Templates)



