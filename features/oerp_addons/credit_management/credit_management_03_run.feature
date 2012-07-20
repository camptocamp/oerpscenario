###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Copyright 2012 Camptocamp SA
#    Author Nicolas Bessi
##############################################################################

# Features Generic tags (none for all)
##############################################################################

@credit_management_module @credit_management_mark_mail

Feature: Ensure that mail credit line generation first pass is correct


  @credit_management_mark
  Scenario: mark lines
    Given there is "draft" credit lines
    And I mark all draft mail to state "to_be_sent"
    Then the draft line should be in state "to_be_sent"

  @credit_management_mail
  Scenario: mail lines
    Given there is "to_be_sent" credit lines
    And I mail all ready lines
    Then All sent lines should be linked to a mail and in mail status "sent"
