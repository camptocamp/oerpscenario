###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Copyright 2012 Camptocamp SA
#    Author Nicolas Bessi
##############################################################################

# Features Generic tags (none for all)
##############################################################################

@credit_management_module

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
    And I should have "2" credit lines of level "1"
    And credit lines should have following values:
     | balance |   date due | account                         | profile       |       date | partner                     | canal | level | move line                           | profile rule | state | amount due | currency |
     |     170 | 2012-02-15 | Not so trusted Debtors - (test) | 3 time policy | 2012-03-01 | Credit m. untrusted partner | mail  |  1.00 | Untrusted invoice                   | 10 days net  | draft |        170 |          |
     |     200 | 2012-02-15 | Not so trusted Debtors - (test) | 3 time policy | 2012-03-01 | Credit m. lambda partner    | mail  |  1.00 | lamba invoice with untrusted policy | 10 days net  | draft |        200 |          |
