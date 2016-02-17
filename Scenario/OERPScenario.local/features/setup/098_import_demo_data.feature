# -*- coding: utf-8 -*-
@swisslux @setup @demo

Feature: Import demo data

  @demo_partner @slow
  Scenario: import some partners
    Given "res.partner" is imported from CSV "demo/res_partner_demo.csv" using delimiter ","
    
  @demo_product
  Scenario: import some products
    Given "product.product" is imported from CSV "demo/product_demo.csv" using delimiter ","