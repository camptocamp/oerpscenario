###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Copyright 2009 Camptocamp SA
#
##############################################################################

# Features Generic tags (none for all)
##############################################################################
# Branch      # Module       # Processes     # System
@multicompany_base_finance

Feature: ACTIVATE SETTINGS (NO MODULES INSTALLED HERE - ONLY GROUPS) 

 @multicompany_base_finance_sales_settings
  Scenario: SALES SETTINGS
     Given I need a "sale.config.settings" with oid: scen.sale_settings
     And having:
     | name                             | value                        |
     | group_sale_delivery_address      | true                         |
     | group_discount_per_so_line       | true                         |                   
     | group_multiple_shops             | true                         |                   
     Then execute the setup

 @multicompany_base_finance_accounting_settings
  Scenario: ACCOUNTING SETTINGS
  Given I need a "account.config.settings" with oid: scen.account_settings
     And having:
     | name                             | value                        |
     | group_multi_currency             | true                         |
     | group_analytic_accounting        | true                         |         
   Then execute the setup

  @multicompany_base_finance_hide_useless_menu
  Scenario: GROUP TO HIDE USELESS MENU
    Given I need a "res.groups" with name: 'hidden menus' and oid: scen.no_voucher_group
     And having:
        | name        | value                         |
        | name        | hidden menus                  |
        | category_id | by name: Accounting & Finance |

     Given I need a "ir.ui.menu" with name: Sales Receipts
       And having:
        | name      | value                         |
        | groups_id | by oid: scen.no_voucher_group |

     Given I need a "ir.ui.menu" with name: Customer Payments
       And having:
        | name      | value                         |
        | groups_id | all by oid: scen.no_voucher_group |

     Given I need a "ir.ui.menu" with name: Purchase Receipts
       And having:
        | name      | value                         |
        | groups_id | by oid: scen.no_voucher_group |

     Given I need a "ir.ui.menu" with name: Supplier Payments
       And having:
        | name      | value                         |
        | groups_id | by oid: scen.no_voucher_group |

     Given I need a "ir.ui.menu" with name: Journal Vouchers
       And having:
        | name      | value                         |
        | groups_id | by oid: scen.no_voucher_group |

     Given I need a "ir.ui.menu" with name: Automatic Reconciliation
       And having:
        | name      | value                         |
        | groups_id | by oid: scen.no_voucher_group |

     Given I need a "ir.ui.menu" with name: Multi-Currencies
       And having:
        | name      | value                         |
        | groups_id | by oid: scen.no_voucher_group |