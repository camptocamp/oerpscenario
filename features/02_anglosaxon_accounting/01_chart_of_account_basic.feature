
###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Copyright 2009 Camptocamp SA
#
##############################################################################
##############################################################################
# Branch      # Module       # Processes     # System
@anglosaxon_accounting

Feature: GENERIC CHART OF ACCOUNT CREATION AND PROPERTIES SETTINGS

  @anglosaxon_setup_chart
  Scenario: GENERIC CHART OF ACCOUNT CREATION
    Given I need a "account.account" with oid: scen.acc_grni
    And having:
    | name        | value               |
    | name        | Goods received not invoiced  |
    | code        | 405                 |
    | parent_id   | by code: C0         |
    | type        | other               |
    | user_type   | by name: Liability  |

    Given I need a "account.account" with oid: scen.acc_gdni
    And having:
    | name        | value               |
    | name        | Goods delivered not invoiced  |
    | code        | 415                 |
    | parent_id   | by code: C0         |
    | type        | other               |
    | user_type   | by name: Asset      |

    Given I need a "account.account" with oid: scen.acc_cogs
    And having:
    | name        | value               |
    | name        | Cost of goods sold  |
    | code        | 690                 |
    | parent_id   | by code: C0         |
    | type        | other               |
    | user_type   | by name: Expense    |

    Given I need a "account.account" with oid: scen.acc_pricediff
    And having:
    | name        | value               |
    | name        | Price difference    |
    | code        | 688                 |
    | parent_id   | by code: C0         |
    | type        | other               |
    | user_type   | by name: Expense    |


  @anglosaxon_base_finance_setup_properties
  Scenario: DEFAULT ACCOUNT SETTINGS (PROPERTIES)
  
    Given I set global property named "property_stock_account_input" for model "product.template" and field "property_stock_account_input"
    And the property is related to model "account.account" using column "code" and value "405"

    Given I set global property named "property_stock_account_output" for model "product.template" and field "property_stock_account_output"
    And the property is related to model "account.account" using column "code" and value "415"

    Given I set global property named "property_account_expense" for model "product.template" and field "property_account_expense"
    And the property is related to model "account.account" using column "code" and value "690"



