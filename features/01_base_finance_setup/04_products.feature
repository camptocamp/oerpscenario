###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Copyright 2009 Camptocamp SA
#
##############################################################################
##############################################################################
# Branch      # Module       # Processes     # System
@addons       @account_voucher       @account_voucher_addons     @param

Feature: I create a list of partners

  @product_creation
  Scenario: Product category creation
    Given I need a "product.category" with name: Cat_A and oid: scenario.cat_A
     And having:
          | name                            | value             |
          | type                            | normal            |  
          | property_income_account_categ   | by code: 707      |
          | property_expense_account_categ  | by code: 607      |

  @product_creation
  Scenario: Product category creation
    Given I need a "product.category" with name: Cat_B and oid: scenario.cat_B
     And having:
          | name                            | value             |
          | type                            | normal            |  
          | property_income_account_categ   | by code: 707      |
          | property_expense_account_categ  | by code: 607      |

  @product_creation
  Scenario: Product category creation
    Given I need a "product.category" with name: Cat_C and oid: scenario.cat_C
     And having:
          | name                            | value             |
          | type                            | normal            |  
          | property_income_account_categ   | by code: 707      |
          | property_expense_account_categ  | by code: 607      |


  @product_creation
  Scenario: Product creation
     Given I need a "product.product" with name: P1 and oid: scenario.p1
     And having:
          | name            | value             |
          | active          | 1                 |
          | sale_ok         | 1                 |
          | purchase_ok     | 0                 |
          | default_code    | P1                |
          | name            | Product_1         |
          | type            | product           |
          | procure_method  | make_to_order     |
          | supply_method   | buy               |    
          | list_price      | 1000.0            |
          | cost_method     | average           |
          | standard_price  | 100.0             |
          | weight_net      | 0.0               |
          | weight          | 0.0               |
          | volume          | 0.0               |
          | sale_delay      | 7.0               |
          | produce_delay   | 1.0               |
          | warranty        | 0.0               |
          | uos_coeff       | 1.0               |
          | mes_type        | fixed             |
          | categ_id        | by name: Cat_A    |
          
  @product_creation
  Scenario: Product creation
     Given I need a "product.product" with name: P2 and oid: scenario.p2
     And having:
          | name            | value             |
          | active          | 1                 |
          | sale_ok         | 1                 |
          | purchase_ok     | 0                 |
          | default_code    | P2                |
          | name            | Product_2         |
          | type            | product           |
          | procure_method  | make_to_order     |
          | supply_method   | buy               |    
          | list_price      | 500.0             |
          | cost_method     | average           |
          | standard_price  | 50.0              |
          | weight_net      | 0.0               |
          | weight          | 0.0               |
          | volume          | 0.0               |
          | sale_delay      | 7.0               |
          | produce_delay   | 1.0               |
          | warranty        | 0.0               |
          | uos_coeff       | 1.0               |
          | mes_type        | fixed             |
          | categ_id        | by name: Cat_B    |

  @product_creation
  Scenario: Product creation
     Given I need a "product.product" with name: P3 and oid: scenario.p3
     And having:
          | name            | value             |
          | active          | 1                 |
          | sale_ok         | 1                 |
          | purchase_ok     | 0                 |
          | default_code    | P3                |
          | name            | Product_3         |
          | type            | product           |
          | procure_method  | make_to_order     |
          | supply_method   | buy               |    
          | list_price      | 400.0             |
          | cost_method     | average           |
          | standard_price  | 40.0              |
          | weight_net      | 0.0               |
          | weight          | 0.0               |
          | volume          | 0.0               |
          | sale_delay      | 7.0               |
          | produce_delay   | 1.0               |
          | warranty        | 0.0               |
          | uos_coeff       | 1.0               |
          | mes_type        | fixed             |
          | categ_id        | by name: Cat_B    |

  @product_creation
  Scenario: Product creation
     Given I need a "product.product" with name: P4 and oid: scenario.p4
     And having:
          | name            | value             |
          | active          | 1                 |
          | sale_ok         | 1                 |
          | purchase_ok     | 0                 |
          | default_code    | P4                |
          | name            | Product_4         |
          | type            | product           |
          | procure_method  | make_to_order     |
          | supply_method   | buy               |    
          | list_price      | 800.0             |
          | cost_method     | average           |
          | standard_price  | 80.0              |
          | weight_net      | 0.0               |
          | weight          | 0.0               |
          | volume          | 0.0               |
          | sale_delay      | 7.0               |
          | produce_delay   | 1.0               |
          | warranty        | 0.0               |
          | uos_coeff       | 1.0               |
          | mes_type        | fixed             |
          | categ_id        | by name: Cat_C    |
          
  @product_creation
  Scenario: Product creation
     Given I need a "product.product" with name: P5 and oid: scenario.p5
     And having:
          | name            | value             |
          | active          | 1                 |
          | sale_ok         | 1                 |
          | purchase_ok     | 0                 |
          | default_code    | P5                |
          | name            | Product_5         |
          | type            | consu             |
          | procure_method  | make_to_order     |
          | supply_method   | buy               |    
          | list_price      | 300.0             |
          | cost_method     | average           |
          | standard_price  | 30.0              |
          | weight_net      | 0.0               |
          | weight          | 0.0               |
          | volume          | 0.0               |
          | sale_delay      | 7.0               |
          | produce_delay   | 1.0               |
          | warranty        | 0.0               |
          | uos_coeff       | 1.0               |
          | mes_type        | fixed             |
          | categ_id        | by name: Cat_C    |
