# Features Generic tags (none for all)
##############################################################################
# System
@install_database
Feature: Make the scenario to create and install an openerp database

    Scenario: Create an openerp database and reconnect with this database

    Scenario: Change user interface
        Given we select admin user
        Then we activate the extended view on the users
