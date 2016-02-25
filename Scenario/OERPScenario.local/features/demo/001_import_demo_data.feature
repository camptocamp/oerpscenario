# -*- coding: utf-8 -*-
@swisslux @demo

Feature: Import demo data

  @demo_partner_customers_only
  Scenario: import some customers
    Given "res.partner" is imported from CSV "demo/partner_customers_demo.csv" using delimiter ","
  
  @demo_partner_vendors_only
  Scenario: import some vendors
    Given "res.partner" is imported from CSV "demo/partner_vendors_demo.csv" using delimiter ","
    
  @demo_partner_both
  Scenario: import some partner with both profile
    Given "res.partner" is imported from CSV "demo/partner_customers_and_vendors_demo.csv" using delimiter ","
    
  @demo_partner_contacts
  Scenario: import some contacts
    Given "res.partner" is imported from CSV "demo/partner_contacts_demo.csv" using delimiter ","

  @demo_product
  Scenario: import some products
    Given "product.product" is imported from CSV "demo/product_demo.csv" using delimiter ","