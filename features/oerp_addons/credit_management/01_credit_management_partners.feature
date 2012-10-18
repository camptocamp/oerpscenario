###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Copyright 2009 Camptocamp SA
#
##############################################################################
##############################################################################
# Branch      # Module       # Processes     # System
@credit_management  @credit_management_add_profile

Feature: I add profile to partners already created
  @credit_management_partner_1
  Scenario: Partner_1
    Given I need a "res.partner" with oid: scen.partner_1
    And having:
      | name                       | value                  |
      | name                       | partner_1              |
      | credit_profile_id          | by name: No follow     |
      
  @credit_management_customer_1
  Scenario: Customer_1
    Given I need a "res.partner" with oid: scen.customer_1
    And having:
      | name                       | value                  |
      | name                       | customer_1             |
      | credit_profile_id          | by name:  2 time policy|
      
  @credit_management_customer_2
  Scenario: Customer_2
    Given I need a "res.partner" with oid: scen.customer_2
    And having:
      | name                       | value                  |
      | name                       | customer_2             |
      | credit_profile_id          | by name:  2 time policy|

  @credit_management_customer_3
  Scenario: Customer_3
    Given I need a "res.partner" with oid: scen.customer_3
    And having:
      | name                       | value                  |
      | name                       | customer_3             |
      | credit_profile_id          | by name:  2 time policy|

  @credit_management_customer_4      
  Scenario: Customer_4
    Given I need a "res.partner" with oid: scen.customer_4
    And having:
      | name                       | value                  |
      | name                       | customer_4             |
      | credit_profile_id          | by name:  3 time policy|

  @credit_management_customer_5      
  Scenario: Customer_5
    Given I need a "res.partner" with oid: scen.customer_5
    And having:
      | name                       | value                  |
      | name                       | customer_5_usd         |
      | credit_profile_id          | by name:  3 time policy|
      
  @credit_management_customer_6      
  Scenario: Customer_6
    Given I need a "res.partner" with oid: scen.customer_5
    And having:
      | name                       | value                  |
      | name                       | customer_6             |
      | credit_profile_id          | by name:  3 time policy|
