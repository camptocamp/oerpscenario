###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Copyright 2009 Camptocamp SA
#
##############################################################################

# Features Generic tags (none for all)
##############################################################################
# Branch      # Module       # Processes     # System
@dsl_samples

Feature: Make some DSL samples
  Scenario: Create/Update a user
      Given I need a "res.users" with name: Cucumber and login: is rocking
      And having:
          | name | value |
          | password | my_pass |
          | context_lang | en_us |
          | company_id | by name: My company | 
          # "by" has a special meaning it will look for relation matching args

    Scenario: Create/Update with some subtility
      Given I need a "res.users" with name: Scenario and login: rulezzz
      And having:
          | name | value |
          | password | my_pass |
          | context_lang | en_us |
          | company_id | by name!: My company | 
          # you can see here the ! it will raise an error


   Scenario: Create/Update a user with some other subtility
      Given I need a "res.users" with name: Scenario and login: rulezzz
      And having:
          | name | value |
          | password | my_pass |
          | context_lang | en_us |
          | company_id | by name: My company and account_no: my-number|  
          # You can cumulate args


    Scenario: Ensure user is unique at creation
      # This will raise en error because it will ensure that user does not exists
      Given I create a "res.users" with name: Scenario and login: rulezzz 
      And having:
          | name | value |
          | password | my_pass |
          | context_lang | en_us |
          | company_id | by name: My company and account_no: my-number|  
          # You can cumulate args


    Scenario: Ensure Someting exists
      Given I find a "res.users" with name: Scenario and login: rulezzz 
      # This will raise if noting found
      And having:
          | name | value |
          | password | my_pass |
          | context_lang | en_us |
          | company_id | by name: My company and account_no: my-number|  
          # You can cumulate args

    Scenario: find all 
      Given I find all "res.partner" with customer: 1  
      # It will find all customers
     

  # oid is a special key word it creates ok look for an xml id in OpenERP
  Scenario: Create a Sale Order with DSL and system wide id
      Given I need a "sale.order" with name: SO Device Reseller and oid: scenario.so_reseller
      And having:
          | name | value |
          | name | SO Device Reseller |
          | partner_id | by oid: scenario.my_partner |
          | pricelist_id | by oid: product.list0 |
          | partner_invoice_id | by oid: scenario.my_partner_add |
          | partner_order_id | by oid: scenario.my_partner_add |
          | partner_shipping_id | by oid: scenario.my_partner_add |
          | shop_id | by name: Your Company |
      Given I need a "sale.order.line" with name: SO Line 1 Device Reseller and oid: scenario.so_reseller_line1
      And having:
          | name | value |
          | name | SO Line 1 Device Reseller |
          | product_id | by oid: scenario.device1 |
          | price_unit | 30.0 |
          | product_uom_qty | 5.0 |
          | product_uom | by name: PCE |
          | order_id | by oid: scenario.so_reseller |