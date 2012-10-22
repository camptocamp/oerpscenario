###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Copyright 2012 Camptocamp SA
#    Author Nicolas Bessi
##############################################################################

# Features Generic tags (none for all)
##############################################################################

@credit_management  @credit_management_run  @credit_management_run_jun

Feature: Ensure that mail credit line generation first pass is correct

    @credit_management_mark
  Scenario: mark lines
    Given there is "draft" credit lines
    And I mark all draft mail to state "to_be_sent"
    Then the draft line should be in state "to_be_sent"
  
    @credit_management_run
  Scenario: Create run
    Given I need a "credit.management.run" with oid: credit_management.run6
    And having:
      | name |      value |
      | date | 2012-06-30 |
    When I launch the credit run
    Then my credit run should be in state "done"
    And the generated credit lines should have the following values:
     | balance |   date due | account       | profile       |       date | partner            | canal | level | move line     | policy level            | state     | amount due | currency |
     |    1200 | 2012-03-31 | Debtors       | 2 time policy | 2012-06-30 | customer_2         | manual|  2.00 | SI_5          | 60 days sommation       | draft     |       1200 |   USD    |           
     |    1200 | 2012-03-16 | Debtors       | 2 time policy | 2012-06-30 | customer_3         | manual|  2.00 | SI_8          | 60 days sommation       | draft     |       1200 |   USD    |     
     |    1050 | 2012-04-30 | Debtors       | 3 time policy | 2012-06-30 | customer_4         | mail  |  2.00 | SI_12         | 30 days end of month    | draft     |       1050 |   USD    |     
     |     840 | 2012-03-31 | Debtors       | 3 time policy | 2012-06-30 | customer_4         | manual|  3.00 | SI_11         | 10 days sommation       | draft     |        840 |   USD    |     
     |    1500 | 2012-04-14 | Debtors USD   | 3 time policy | 2012-06-30 | customer_5_usd     | manual|  3.00 | SI_15         | 10 days sommation       | draft     |       1500 |   USD    |        
