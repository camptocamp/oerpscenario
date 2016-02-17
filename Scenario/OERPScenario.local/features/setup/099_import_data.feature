# -*- coding: utf-8 -*-
@swisslux @setup @import @slow

Feature: import master data

#  @csv @regions
#  Scenario: import specific regions
#    Given "res.partner.region" is imported from CSV "setup/res_partner_region.csv" using delimiter ","

  @csv @products
  Scenario: import some products
    Given "product.product" is imported from CSV "setup/product.product.csv.sample" using delimiter ","

  @csv @products @slow
  Scenario: import products
    Given "product.product" is imported from CSV "setup/product.product.csv" using delimiter ","
  
  @csv @product_expenses @slow
  Scenario: import products for expenses
    Given "product.product" is imported from CSV "setup/product_expenses.csv" using delimiter ","
    
#  @csv @partner @slow
#  Scenario: import some partner
#    Given "res.partner" is imported from CSV "setup/res_partner_demo.csv" using delimiter ","
  
