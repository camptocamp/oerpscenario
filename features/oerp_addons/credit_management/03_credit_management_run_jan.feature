###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Copyright 2012 Camptocamp SA
#    Author Nicolas Bessi
##############################################################################

# Features Generic tags (none for all)
##############################################################################

@credit_management        @credit_management_run    @credit_management_run_jan

Feature: Ensure that mail credit line generation first pass is correct


  @credit_management_first_run
  Scenario: clean data
    Given I clean all the credit lines
    #Given I unreconcile and clean all move line

  @credit_management_first_run
  Scenario: Create run
    Given I need a "credit.management.run" with oid: credit_management.run1
    And having:
      | name |      value |
      | date | 2012-01-31 |
    When I launch the credit run
    Then my credit run should be in state "done"
    And credit lines should have following values:
     | balance |   date due | account       | profile       |       date | partner            | canal | level | move line     | profile rule | state | amount due | currency |
     |     300 | 2012-01-18 | Debtors       | 3 time policy | 2012-01-31 | customer_4         | mail  |  1.00 | SI_10         | 10 days net  | draft |        300 |          |
   