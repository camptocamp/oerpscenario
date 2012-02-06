###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Copyright 2009 Camptocamp SA
#
##############################################################################

# Features Generic tags (none for all)
##############################################################################

# Branch      # Module       # Processes     # System
@addons       @account       @invoicing      @init

Feature: Initialize the settings for account module
  In order ensure the right state before launching the tests suite
  I want to set some parameters and settings
  
  Scenario: Initialize Account settings
      Given the company currency is set to EUR 
      And the following currency rate settings are:
      |code|rate|name|
      |EUR|1.000|01-01-2009|
      |CHF|1.644|01-01-2009|
      |CHF|1.500|09-09-2009|
      |CHF|0.6547|10-10-2009|
      |USD|1.3785|01-01-2009|

      Given a cash journal in USD exists
      And a cash journal in CHF exists
      And a cash journal in EUR exists
      And on all journal entries can be canceled

      Given a purchase tax called 'Buy 19.6%' with a rate of 0.196 exists
      And a sale tax called 'Sale 19.6%' with a rate of 0.196 exists