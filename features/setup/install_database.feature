# Features Generic tags (none for all)
##############################################################################
# System
@install_database
Feature: Make the scenario to create and install an openerp database

    Scenario: Create an openerp database and reconnect with this database
        Given I have created a database with the following attributes:
            |key|value|
            |url|http://localhost:8069/xmlrpc|
            |db_password|admin|
            |database|db_magento|
            |demo_data|false|
            |lang|en_US|
            |password|admin|

        Given I reconnect with the database db_magento

    Scenario: Change user interface
        Given we select admin user
        Then we activate the extended view on the users
