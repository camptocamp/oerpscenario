@account @addons  @invoicing
Feature ensure finance test
  In order to be sure that the data are set correctely to run finance set
  As an administator
  I want to see if the basics settings are done
  
  @account @addons @invoicing 
  Background:
      Given I am loged as admin user with password admin used
      And the company currency is set to EUR 
      And the following currency rate settings are:
      |code|rate|name|
      |EUR|1.000|01-01-2009|
      |CHF|1.644|01-01-2009|
      |CHF|1.500|09-09-2009|
      |USD|1.3785|01-01-2009|
      And a cash journal in USD exists
      And a cash journal in CHF exists
      And a cash journal in EUR exists