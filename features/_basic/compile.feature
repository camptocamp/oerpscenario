###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Copyright 2009 Camptocamp SA
#
##############################################################################


# Features Generic tags (none for all)
##############################################################################

# System
@compile

Feature: Compilation tests
  In order to verify everything is working
  And all needed packages are installed
  And the OERPScenario's settings are well done
  I want to launch a test scenario
  
    Scenario: Compile Test
        Given Build is OK
        Given I have file "Rakefile"
        Given module "base" is installed