###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Copyright 2012 Camptocamp SA
#    Author Nicolas Bessi
##############################################################################

# Features Generic tags (none for all)
##############################################################################

@credit_control  @credit_control_run  @credit_control_run_may

Feature: Ensure that mail credit line generation first pass is correct

    @credit_control_mark
  Scenario: mark lines
    Given there is "draft" credit lines
    And I mark all draft mail to state "to_be_sent"
    Then the draft line should be in state "to_be_sent"
  
    @credit_control_run
  Scenario: Create run
    Given I need a "credit.control.run" with oid: credit_control.run5
    And having:
      | name |      value |
      | date | 2012-05-31 |
    When I launch the credit run
    Then my credit run should be in state "done"
    And the generated credit lines should have the following values:
     | balance |   date due | account       | policy       |       date | partner            | canal | level | move line     | policy level            | state     | amount due | currency |
     |    1500 | 2012-04-30 | Debtors       | 2 time policy | 2012-05-31 | customer_2         | mail  |  1.00 | SI_6          | 30 days end of month    | draft     |       1500  |  USD    |
     |    1500 | 2012-04-14 | Debtors       | 2 time policy | 2012-05-31 | customer_3         | mail  |  1.00 | SI_8          | 30 days end of month    | draft     |       1500  |  USD    |    
     |    1050 | 2012-04-30 | Debtors       | 3 time policy | 2012-05-31 | customer_4         | mail  |  1.00 | SI_11         | 10 days net             | draft     |       1050  |  USD    |   
     |    1000 | 2012-02-29 | Debtors       | 2 time policy | 2012-05-31 | customer_2         | manual|  2.00 | SI_4          | 60 days last reminder       | draft     |       1000  |         |           
     |    1000 | 2012-02-17 | Debtors       | 2 time policy | 2012-05-31 | customer_3         | manual|  2.00 | SI_7          | 60 days last reminder       | draft     |       1000  |         |     
     |     840 | 2012-03-31 | Debtors       | 3 time policy | 2012-05-31 | customer_4         | mail  |  2.00 | SI_11         | 30 days end of month    | draft     |        840  |  USD    |     
     |    1500 | 2012-04-14 | Debtors USD   | 3 time policy | 2012-05-31 | customer_5_usd     | mail  |  2.00 | SI_15         | 30 days end of month    | draft     |       1500  |  USD    |
     |     700 | 2012-02-29 | Debtors       | 3 time policy | 2012-05-31 | customer_4         | manual|  3.00 | SI_10         | 10 days last reminder       | draft     |        700  |         |     
     |     450 | 2012-03-15 | Debtors       | 3 time policy | 2012-05-31 | customer_4         | manual|  3.00 | SI_12         | 10 days last reminder       | draft     |        450  |  USD    |     
     |    1200 | 2012-03-16 | Debtors USD   | 3 time policy | 2012-05-31 | customer_5_usd     | manual|  3.00 | SI_14         | 10 days last reminder       | draft     |       1200  |  USD    |        
