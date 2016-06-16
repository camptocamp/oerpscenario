# -*- coding: utf-8 -*-
@upgrade_from_9.0.6
Feature: upgrade to 9.0.7

  Scenario: upgrade
    Given I update the module list
    Given I install the required modules with dependencies:
      | name                                          |
      | specific_reports                              |
      | specific_product                              |
      | specific_building_project                     |
    Then my modules should have been installed and models reloaded

  @account_chart_extended
  Scenario: Generate extended account chart for Swisslux AG
    Given "account.account" is imported from CSV "setup/account.account.csv" using delimiter ","

  @product_category
  Scenario: setup tmp corr for product category
    Given "product.category" is imported from CSV "setup/product.category.csv" using delimiter ","

  @force_translations @slow
  Scenario: Force lang translations
    Given I update the module list
    When I update the following languages
         | lang  |
         | de_DE |
         | fr_FR |
         | it_IT |

    Then I set the version of the instance to "9.0.7"
