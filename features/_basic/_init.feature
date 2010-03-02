###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Copyright 2009 Camptocamp SA
#
##############################################################################

Feature basic initialization
  In order to do BDD
  As a power user
  I want to initialize OERPScenario

  Background: login
    Given I am loged as admin user with password admin used
    