# -*- coding: utf-8 -*-
@swisslux @setup @product

Feature: Manage product informations

  @product_taxes
  Scenario: create taxes
    Given I need an "account.tax" with oid: scenario.tax_vrg_700180
    And having:
      | key    | value           |
      | name   | Taxe VRG 700180 |
      | amount | 999             |
    Given I need an "account.tax" with oid: scenario.tax_vrg_700200
    And having:
      | key    | value           |
      | name   | Taxe VRG 700200 |
      | amount | 999             |

  @product_account
  Scenario: create account 4620 and 6622
    Given I need an "account.account" with oid: scenario.account_4620
    And having:
      | key          | value             |
      | name         | 4620              |
      | code         | 4620              |
      | user_type_id | by name: Expenses |
    Given I need an "account.account" with oid: scenario.account_6622
    And having:
      | key          | value             |
      | name         | 6622              |
      | code         | 6622              |
      | user_type_id | by name: Expenses |


  @csv @product_categories
  Scenario: import product categories
    Given "product.category" is imported from CSV "setup/product.category.csv" using delimiter ","