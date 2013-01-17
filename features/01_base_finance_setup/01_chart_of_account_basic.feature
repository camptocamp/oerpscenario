###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Copyright 2009 Camptocamp SA
#
##############################################################################
##############################################################################
# Branch      # Module       # Processes     # System
@base_finance   @base_commercial_management 

Feature: GENERIC CHART OF ACCOUNT CREATION AND PROPERTIES SETTINGS

  Scenario: Ensure the db is available
    Given the server is up and running OpenERP 7.0
    And the database "behave" exists
    Then user "admin" log in with password "admin"


  @base_finance_setup_chart
  Scenario: GENERIC CHART OF ACCOUNT CREATION
    Given I need a "account.account" with oid: scen.root
    And having:
    | name        | value               |
    | name        | Chart               |
    | code        | C0                  |
    | type        | view                |
    | user_type   | by name: Root/View  |

     Given I need a "account.account" with oid: scen.acc_stock_var
    And having:
    | name        | value               |
    | name        | Stock variation     |
    | code        | 603                 |
    | type        | other               |
    | parent_id   | by code: C0         |
    | user_type   | by name: Expense    |

     Given I need a "account.account" with oid: scen.acc_fx
    And having:
    | name        | value               |
    | name        | Curr. fx gain&loss  |
    | code        | 666                 |
    | type        | other               |
    | parent_id   | by code: C0         |
    | user_type   | by name: Expense    |

     Given I need a "account.account" with oid: scen.acc_wo
    And having:
    | name        | value               |
    | name        | Write-off           |
    | code        | 658                 |
    | type        | other               |
    | parent_id   | by code: C0         |
    | user_type   | by name: Expense    |

     Given I need a "account.account" with oid: scen.acc_exp
    And having:
    | name        | value               |
    | name        | Other expenses      |
    | code        | 699                 |
    | type        | other               |
    | parent_id   | by code: C0         |
    | user_type   | by name: Expense    |

     Given I need a "account.account" with oid: scen.acc_inc
    And having:
    | name        | value               |
    | name        | Other incomes       |
    | code        | 799                 |
    | parent_id   | by code: C0         |
    | type        | other               |
    | user_type   | by name: Income     |

     Given I need a "account.account" with oid: scen.acc_sales
    And having:
    | name        | value               |
    | name        | Sales               |
    | code        | 707                 |
    | parent_id   | by code: C0         |
    | type        | other               |
    | user_type   | by name: Income     |

     Given I need a "account.account" with oid: scen.acc_purchases
    And having:
    | name        | value               |
    | name        | Purchases           |
    | code        | 607                 |
    | parent_id   | by code: C0         |
    | type        | other               |
    | user_type   | by name: Expense    |

     Given I need a "account.account" with oid: scen.acc_dep
    And having:
    | name        | value               |
    | name        | Depreciation        |
    | code        | 6821                |
    | parent_id   | by code: C0         |
    | type        | other               |
    | user_type   | by name: Expense    |

     Given I need a "account.account" with oid: scen.acc_fi_dep
    And having:
    | name        | value               |
    | name        | Fi. depreciation    |
    | code        | 686                 |
    | type        | other               |
    | parent_id   | by code: C0         |
    | user_type   | by name: Expense    |

     Given I need a "account.account" with oid: scen.acc_pl
    And having:
    | name        | value               |
    | name        | Profit/Loss         |
    | code        | 120                 |
    | parent_id   | by code: C0         |
    | type        | other               |
    | user_type   | by name: Liability  |

     Given I need a "account.account" with oid: scen.acc_receivable_eur
    And having:
    | name        | value               |
    | name        | Debtors             |
    | code        | 4111                |
    | parent_id   | by code: C0         |
    | type        | receivable          |
    | user_type   | by name: Receivable |
    | reconcile   | true                |

     Given I need a "account.account" with oid: scen.acc_payable_eur
    And having:
    | name        | value               |
    | name        | Creditors           |
    | code        | 4011                |
    | parent_id   | by code: C0         |
    | type        | payable             |
    | user_type   | by name: Payable    |
    | reconcile   | true                |
    
     Given I need a "account.account" with oid: scen.acc_receivable_usd
    And having:
    | name        | value               |
    | name        | Debtors USD         |
    | code        | 4112                |
    | parent_id   | by code: C0         |
    | type        | receivable          |
    | user_type   | by name: Receivable |
    | reconcile   | true                |
    
     Given I need a "account.account" with oid: scen.acc_receivable_gbp
    And having:
    | name        | value               |
    | name        | Debtors GBP         |
    | code        | 4113                |
    | parent_id   | by code: C0         |
    | type        | receivable          |
    | user_type   | by name: Receivable |
    | reconcile   | true                |    

     Given I need a "account.account" with oid: scen.acc_payable_usd
    And having:
    | name        | value               |
    | name        | Creditors USD       |
    | code        | 4012                |
    | parent_id   | by code: C0         |
    | type        | payable             |
    | user_type   | by name: Payable    |
    | reconcile   | true                |

     Given I need a "account.account" with oid: scen.acc_sales_vat
    And having:
    | name        | value               |
    | name        | Sales VAT           |
    | code        | 4457                |
    | parent_id   | by code: C0         |
    | type        | other               |
    | user_type   | by name: Liability  |

     Given I need a "account.account" with oid: scen.acc_purchases_vat
    And having:
    | name        | value               |
    | name        | Purchases VAT       |
    | code        | 4456                |
    | parent_id   | by code: C0         |
    | type        | other               |
    | user_type   | by name: Asset      |
    
         Given I need a "account.account" with oid: scen.acc_EU_purchases_vat
    And having:
    | name        | value               |
    | name        | Purchases UE VAT    |
    | code        | 445662              |
    | parent_id   | by code: C0         |
    | type        | other               |
    | user_type   | by name: Liability  |

     Given I need a "account.account" with oid: scen.acc_EU_purchases_rev_vat
    And having:
    | name        | value               |
    | name        | Purchases UE Reverse VAT |
    | code        | 4452                |
    | parent_id   | by code: C0         |
    | type        | other               |
    | user_type   | by name: Asset      |
    
      Given I need a "account.account" with oid: scen.acc_asset
    And having:
    | name        | value               |
    | name        | Asset               |
    | code        | 210                 |
    | parent_id   | by code: C0         |
    | type        | other               |
    | user_type   | by name: Asset      |

      Given I need a "account.account" with oid: scen.prov
    And having:
    | name        | value               |
    | name        | Provision bs acc.   |
    | code        | 1515                |
    | parent_id   | by code: C0         |
    | type        | other               |
    | user_type   | by name: Liability  |

      Given I need a "account.account" with oid: scen.unrealized_loss
    And having:
    | name        | value               |
    | name        | Unrealized fx loss  |
    | code        | 476                 |
    | parent_id   | by code: C0         |
    | type        | other               |
    | user_type   | by name: Asset      |

      Given I need a "account.account" with oid: scen.unrealized_gain
    And having:
    | name        | value               |
    | name        | Unrealized fx gain  |
    | code        | 477                 |
    | parent_id   | by code: C0         |
    | type        | other               |
    | user_type   | by name: Liability  |


      Given I need a "account.account" with oid: scen.acc_inv
    And having:
    | name        | value               |
    | name        | Inventory           |
    | code        | 370                 |
    | parent_id   | by code: C0         |
    | type        | other               |
    | user_type   | by name: Asset      |


   Given I need a "account.account" with oid: scen.acc_bank_eur
    And having:
    | name        | value               |
    | name        | EUR bank account    |
    | code        | 5121                |
    | parent_id   | by code: C0         |
    | type        | other               |
    | user_type   | by name: Cash       |

    Given I need a "account.account" with oid: scen.acc_bank_usd
    And having:
    | name        | value               |
    | name        | USD bank account    |
    | code        | 5122                |
    | parent_id   | by code: C0         |
    | type        | other               |
    | user_type   | by name: Cash       |
    | currency_id | by name: USD        |

    Given I need a "account.account" with oid: scen.acc_bank_gbp
    And having:
    | name        | value               |
    | name        | GBP bank account    |
    | code        | 5123                |
    | parent_id   | by code: C0         |
    | type        | other               |
    | user_type   | by name: Cash       |
    | currency_id | by name: GBP        |

  

  @base_finance_setup_properties
  Scenario: DEFAULT ACCOUNT SETTINGS (PROPERTIES)

    Given I need a "res.company" with oid: base.main_company
    And having:
    | name                                 | value                |
    | expense_currency_exchange_account_id | by name: Currency fx |
    | income_currency_exchange_account_id  | by name: Currency fx |

    Given I set global property named "property_account_receivable" for model "res.partner" and field "property_account_receivable"
    And the property is related to model "account.account" using column "code" and value "4111"

    Given I set global property named "property_account_payable" for model "res.partner" and field "property_account_payable"
    And the property is related to model "account.account" using column "code" and value "4011"

    Given I set global property named "property_account_expense" for model "product.template" and field "property_account_expense"
    And the property is related to model "account.account" using column "code" and value "607"

    Given I set global property named "property_account_income" for model "product.template" and field "property_account_income"
    And the property is related to model "account.account" using column "code" and value "707"
    
    Given I set global property named "property_stock_account_input" for model "product.template" and field "property_stock_account_input"
    And the property is related to model "account.account" using column "code" and value "603"

    Given I set global property named "property_stock_account_output" for model "product.template" and field "property_stock_account_output"
    And the property is related to model "account.account" using column "code" and value "603"

