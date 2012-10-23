###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Copyright 2009 Camptocamp SA
#
##############################################################################
##############################################################################
# Branch      # Module       # Processes     # System
@credit_control  @credit_control_add_policy

Feature: I add policy to partners already created
  @credit_control_partner_1
  Scenario: Partner_1
    Given I need a "res.partner" with oid: scen.partner_1
    And having:
      | name             | value              |
      | name             | partner_1          |
      | credit_policy_id | by name: No follow |
      
  @credit_control_customer_1
  Scenario: Customer_1
    Given I need a "res.partner" with oid: scen.customer_1
    And having:
      | name             | value                   |
      | name             | customer_1              |
      | credit_policy_id | by name:  2 time policy |
      
  @credit_control_customer_2
  Scenario: Customer_2
    Given I need a "res.partner" with oid: scen.customer_2
    And having:
      | name             | value                   |
      | name             | customer_2              |
      | credit_policy_id | by name:  2 time policy |

  @credit_control_customer_3
  Scenario: Customer_3
    Given I need a "res.partner" with oid: scen.customer_3
    And having:
      | name             | value                   |
      | name             | customer_3              |
      | credit_policy_id | by name:  2 time policy |

  @credit_control_customer_4      
  Scenario: Customer_4
    Given I need a "res.partner" with oid: scen.customer_4
    And having:
      | name             | value                   |
      | name             | customer_4              |
      | credit_policy_id | by name:  3 time policy |

  @credit_control_customer_5      
  Scenario: Customer_5
    Given I need a "res.partner" with oid: scen.customer_5
    And having:
      | name             | value                   |
      | name             | customer_5_usd          |
      | credit_policy_id | by name:  3 time policy |
      
  @credit_control_customer_6      
  Scenario: Customer_6
    Given I need a "res.partner" with oid: scen.customer_6
    And having:
      | name             | value                   |
      | name             | customer_6              |
      | credit_policy_id | by name:  3 time policy |
