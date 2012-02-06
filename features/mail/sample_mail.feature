###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Copyright 2009 Camptocamp SA
#
##############################################################################

# Features Generic tags (none for all)
##############################################################################

# Branch      # Module       # Processes     # System
@mail @sample_mail

Feature: Ensure that mail configuration is correct
    Scenario: Configure outgoing sever
    
    Given I have no outgoing mail conf named "localhost"
    Given I have a outgoing mailconf  named "vilant_out"
    
    Scenario: Configure incoming sever
    
    Given I have a incoming mail conf named "vilant_in"
    And the incoming conf generate "crm.lead"
    When I save the incoming conf it should be ok
    
    Given I activate the incoming conf