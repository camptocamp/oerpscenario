###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Copyright 2009 Camptocamp SA
#
##############################################################################

# Features Generic tags (none for all)
##############################################################################

Feature basic initialization
  In order to do BDD
  I want to log me into OpenERP server with the following user
  And run the OERPScenario suite with him

# You can change that with your settings, to run the test with a
# different user. The example bellow is already
# implemented in _init.rb
#
# Example :
#
# Given I am logged as administrator user with password 12345 used
#
# The Background will be run before every feature. 
  Background: login
    I am logged as admin user with the password set in config used
    