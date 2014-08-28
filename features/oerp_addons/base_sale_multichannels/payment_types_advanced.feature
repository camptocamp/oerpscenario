###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Copyright 2012 Camptocamp SA
#
##############################################################################

# Features Generic tags (none for all)
##############################################################################

# Branch      # Module       # Processes     # System

Feature: In order to finely configure workflows based on payment type used on Magento, I need to configure them on OpenERP
  and ensure that the steps of the workflow is automatic or not for each action.

  Scenario: I define a global configuration for all the workflows and some common patterns.  Each one of them is applied to a list of payment codes.  I set a reference on each list of codes in order to be able to modify them later, as instance  to extract one payment code in a different or new pattern.

  @payment_types_journal
  Scenario: Create the accounting journals used to create the payments for orders imported from Magento
    Given I need an "account.journal" with reference "paypal_journal"
    When I update it with values:
      | key                       | value                                         |
      | name                      | 'Paypal'                                      |
      | code                      | 'PAYP'                                        |
      | type                      | 'bank'                                        |
      | company_id                | ref('base.main_company')                      |
      # dummy accounts
      | default_debit_account_id  | name('Comptes de liaison des établissements') |
      | default_credit_account_id | name('Comptes de liaison des établissements') |
      | allow_date                | true                                          |
      | view_id                   | 1                                             |
    Then I save it

  @magento_payment_types
  Scenario: Configure payment modes
    Given I delete the "BaseSalePaymentType" with reference "magentoerpconnect.payment_type1"
    And I delete the "BaseSalePaymentType" with reference "magentoerpconnect.payment_type2"

    Given I define the global configuration of the payment types with values:
      | key                          | value      |
      | picking_policy               | 'one'      |
      | invoice_quantity             | 'order'    |
      | order_policy                 | 'postpaid' |
      | validate_order               | false      |
      | check_if_paid                | false      |
      | create_invoice               | false      |
      | validate_invoice             | false      |
      | validate_picking             | false      |
      | validate_manufacturing_order | false      |
      | invoice_date_is_order_date   | false      |
      | days_before_order_cancel     | 30         |
      | validate_payment             | false      |
      | is_auto_reconcile            | false      |
      | payment_term_id              | false      |
      | journal_id                   | false      |

    When I define a "AUTOMATIC" payment type pattern with values:
      | key               | value |
      | validate_order    | true  |
      | check_if_paid     | true  |
      | create_invoice    | true  |
      | validate_invoice  | true  |
      | validate_payment  | true  |
      | is_auto_reconcile | true  |

    When I define a "AUTOMATIC PAYPAL" payment type pattern with values:
      | key               | value                 |
      | journal_id        | ref('paypal_journal') |
    And the other values of "AUTOMATIC PAYPAL" pattern are those of "AUTOMATIC"

    And I define a "CHEQUE" payment type pattern with values:
      | key               | value |
      | validate_order    | false |
      | check_if_paid     | false |
      | create_invoice    | true  |
      | validate_invoice  | true  |
      | validate_payment  | true  |
      | is_auto_reconcile | true  |

    And I define a "FULL MANUAL" payment type pattern with values:
      | key               | value |
      | validate_order    | false |
      | check_if_paid     | false |
      | create_invoice    | false |
      | validate_invoice  | false |
      | validate_payment  | false |
      | is_auto_reconcile | false |

    Then I want to use the following payment codes with the "AUTOMATIC" payment type with reference "direct_total":
      | Payment Code  |
      | atos_standard |
      | free          |

    Then I want to use the following payment codes with the "AUTOMATIC PAYPAL" payment type with reference "direct_paypal":
      | Payment Code    |
      | paypal_standard |

    And I want to use the following payment codes with the "CHEQUE" payment type with reference "cheq_vir":
      | Payment Code |
      | checkmo      |
      | bankpayment  |

    And I want to use the following payment codes with the "FULL MANUAL" payment type with reference "manual":
      | Payment Code      |
      | ccsave            |
      | googlecheckout    |
      | paypayl_express   |
      | paybox_system     |
      | servired_standard |
      | bbva              |
      | cofidis           |
      | cashondelivery    |
