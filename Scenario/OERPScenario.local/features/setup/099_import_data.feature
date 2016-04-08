# -*- coding: utf-8 -*-
@swisslux @setup @import

Feature: import master data

  @csv @regions
  Scenario: import specific regions
    Given "res.partner.region" is imported from CSV "setup/res.partner.region.csv" using delimiter ","

  @csv @zip
  Scenario: import specific regions
    Given "res.better.zip" is imported from CSV "setup/res.better.zip.csv" using delimiter ","

  @csv @product_categories
  Scenario: import product categories
    Given "product.category" is imported from CSV "setup/product.category.csv" using delimiter ","

  @csv @product_expenses
  Scenario: import products for expenses
    Given "product.product" is imported from CSV "setup/product_expenses.csv" using delimiter ","

  @csv @products @slow
  Scenario: import products
    Given "product.product" is imported from CSV "setup/product.product.csv" using delimiter ","

  @update_reception_text_product @product
  Scenario: set default product reception text
    Given I execute the SQL commands
    """;
    update product_template set receipt_checklist = '
    Technik (DRINGEND):
    Lieferumfang Logistik:

    Label aussen

    Labal innen

    Anleitungen D+F

    Merkblatt V5.0';
    """

  @partner_title
  Scenario: add Department title
    Given I need a "res.partner.title" with oid: scenario.partner_title_department
      And having:
        | key  | value     |
        | name | Department |

  @csv @suppliers
  Scenario: import specific suppliers
    Given "res.partner" is imported from CSV "setup/suppliers.csv" using delimiter ","

  @csv @suppliers_contacts @slow
  Scenario: import specific suppliers contacts
    Given "res.partner" is imported from CSV "setup/supplierscontact.csv" using delimiter ","

  @csv @supplierinfo @slow
  Scenario: import specific supplierinfo
    Given "product.supplierinfo" is imported from CSV "setup/product.supplierinfo.csv" using delimiter ","

  @csv @pricelists
  Scenario: import specific pricelist
    Given "product.pricelist" is imported from CSV "setup/product.pricelist.csv" using delimiter ","

  @csv @pricelist_items
  Scenario: import specific pricelist items
    Given "product.pricelist.item" is imported from CSV "setup/product.pricelist.item.csv" using delimiter ","

  @csv @orderpoint @slow
  Scenario: import specific orderpoint
    Given "stock.warehouse.orderpoint" is imported from CSV "setup/stock.warehouse.orderpoint.csv" using delimiter ","

  @csv @bom @slow
  Scenario: import specific bom
    Given "mrp.bom" is imported from CSV "setup/mrp.bom.csv" using delimiter ","

  @csv @bomlines @slow
  Scenario: import specific bom
    Given "mrp.bom.line" is imported from CSV "setup/mrp.bom.line.csv" using delimiter ","
