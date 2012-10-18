###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Copyright 2012 Camptocamp SA
#    Author Nicolas Bessi
##############################################################################

# Features Generic tags (none for all)
##############################################################################

@credit_management      @credit_management_feb

Feature: Ensure that mail credit line generation first pass is correct

  @credit_management_first_run
  Scenario: Create run
    Given I need a "credit.management.run" with oid: credit_management.run1
    And having:
      | name |      value |
      | date | 2012-02-28 |
    When I launch the credit run
    Then my credit run should be in state "done"
    And credit lines should have following values:
     | balance |   date due | account       | profile       |       date | partner            | canal | level | move line     | profile rule            | state | amount due | currency |
     |     360 | 2012-01-18 | Debtors       | 3 time policy | 2012-02-28 | customer_4         | mail  |  1.00 | SI_11         | 10 days net             | draft |        360 |  USD     |
     |    1000 | 2012-02-17 | Debtors USD   | 3 time policy | 2012-02-28 | customer_5_usd     | mail  |  1.00 | SI_13         | 10 days net             | draft |       1000 |  USD     |
     |     300 | 2012-02-18 | Debtors       | 3 time policy | 2012-02-28 | customer_4         | mail  |  2.00 | SI_10         | 30 days end of month    | draft |        300 |          |      