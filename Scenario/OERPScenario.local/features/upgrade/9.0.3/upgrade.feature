# -*- coding: utf-8 -*-
@upgrade_from_9.0.2
Feature: upgrade to 9.0.3

  Scenario: upgrade
    Given I update the module list
    Given I install the required modules with dependencies:
      | name                       |
      | specific_building_project  |
      | specific_reports           |
      | specific_stock             |
      | specific_timesheet         |
    Then my modules should have been installed and models reloaded
  
  @product_informations 
  Scenario: setup new fields for product
    Given "product.class" is imported from CSV "setup/product.class.csv" using delimiter ","
    Given "product.color.code" is imported from CSV "setup/product.colorcode.csv" using delimiter ","
    Given "product.harmsys.code" is imported from CSV "setup/product.harmsyscode.csv" using delimiter ","
    Given "product.manual.code" is imported from CSV "setup/product.manualcode.csv" using delimiter ","

  @product_informations @slow
  Scenario: slow setup new fields for produt
    Given "product.supplierinfo" is imported from CSV "setup/product.supplierinfo.csv" using delimiter ","
  
  @slow @product
  Scenario: setup new fields on existing product
    Given "product.product" is imported from CSV "setup/product.product.csv" using delimiter ","


  @version
  Scenario: setup application version
    Given I set the version of the instance to "9.0.3"
