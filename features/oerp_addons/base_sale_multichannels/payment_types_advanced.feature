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

  Scenario: I define a global configuration for all the workflows and some common patterns.
    Each one of them is applied to a list of payment codes.
    I set a reference on each list of codes in order to be able to modify them later, as instance
    to extract one payment code in a different or new pattern.

  @magento_payment_types
  Scenario: Configure trusted payment mode
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
    When I define a "DIRECT TOTAL" payment type pattern with values:
      | key               | value |
      | validate_order    | true  |
      | check_if_paid     | true  |
      | create_invoice    | true  |
      | validate_invoice  | true  |
      | validate_payment  | true  |
      | is_auto_reconcile | true  |
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

    Then I want to use the following payment codes with the "DIRECT TOTAL" payment type with reference "direct_total":
      | Payment Code    |
      | atos_standard   |
      | paypal_standard |
      | free            |

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