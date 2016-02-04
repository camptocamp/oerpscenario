# -*- coding: utf-8 -*-
@swisslux @setup @sales

Feature: Configure Sales

  @sales_products
  Scenario: Configure Quotations & sales
    Given I set "Default Invoicing" to "Invoice delivered quantities" in "Sales" settings menu    
 
  @sales_quotations
  Scenario: Configure Quotations & sales
    Given I set "Addresses" to "Display 3 fields on sales orders: customer, invoice address, delivery address" in "Sales" settings menu    
    Given I enable "Use pricelists to adapt your price per customers" in "Sales" settings menu
    Given I enable "Show pricelists to customers" in "Sales" settings menu
    Given I set "Order Routing" to "Choose specific routes on sales order lines (advanced)" in "Sales" settings menu

  @sales_discount
  Scenario: Enable discount
    Given I set "Discount" to "Allow discounts on sales order lines" in "Sales" settings menu

  @default_tax
  Scenario: Default tax for sales
    Given I need a "account.config.settings" with oid: scenario.account_settings
     And having:
     | name                 | value                         |
     | default_sale_tax_id  | by name: TVA due a 8.0% (TN)  |
    Then execute the setup

