# -*- coding: utf-8 -*-
@upgrade_from_9.0.7
Feature: upgrade to 9.0.8

  Scenario: upgrade
    Given I update the module list
    Given I install the required modules with dependencies:
      | name                                          |
      | specific_project                              |
      | specific_building_project                     |
    Then my modules should have been installed and models reloaded
    
    
  @product @slow
  Scenario: adapt account on product
    Given "product.product" is imported from CSV "setup/product.product.csv" using delimiter ","
    
    
    Then I set the version of the instance to "9.0.8"
