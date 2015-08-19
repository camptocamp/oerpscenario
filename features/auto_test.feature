# -*- coding: utf-8 -*-
@auto_test
Feature: In order to test oerpscenario I use it to test itself

  Scenario: Test database creation
    Given I create database from config file

  Scenario: Test installation of modules
    Given I do not want all demo data to be loaded on install
    And I update the module list
    And I install the required modules with dependencies:
    | name     |
    | base     |
    | document |
    | account  |
    | l10n_fr  |
    Then my modules should have been installed and models reloaded

  Scenario: Test language installation
    Given I install the following languages:
    | lang  |
    | fr_FR |
    Then the language should be available

  Scenario: Test language configuration
    Given I need a "res.lang" with code: en_US
    And having:
    | name              | value     |
    | date_format       | %d/%m/%Y  |
    | grouping          | [3,0]     |
    | thousands_sep     | '         |

    Given I need a "res.lang" with code: fr_FR
    And having:
    | name              | value     |
    | date_format       | %d/%m/%Y  |
    | grouping          | [3,0]     |
    | thousands_sep     | '         |

  Scenario: Test user permission
    Given we select users below:
    | login |
    | admin |
    Then we assign all groups to the users

  Scenario: Test setup account chart
    Given I have the module account installed
    And no account set for company "YourCompany"
    And I want to generate account chart from chart template named "Plan Comptable Général (France)" with "6" digits for company "YourCompany"

  Scenario: Test fiscalyear and date place holder
    Given I need a "account.fiscalyear" with oid: scenario.fy1
    And having:
    | name       | value    |
    | name       | current  |
    | code       | current  |
    | date_start | %y-01-01 |
    | date_stop  | %y-12-31 |

    And I create monthly periods on the fiscal year with reference "scenario.fy1"
    Then I find a "account.fiscalyear" with oid: scenario.f1

  Scenario: Test base DSL using company setting and test data folder lookup
  Given I find a "res.company" with oid: base.main_company
    And having:
         | key         | value                         |
         | name        | Springfield Power Company     |
         | street      | A street                      |
         | street2     | A Street 2                    |
         | zip         | 93310                         |
         | city        | Springfield                   |
         | country_id  | by code: US                   |
         | phone       | 00 00 00 00 00                |
         | fax         | 00 00 00 00 00                |
         | email       | homer@simpson.dummy           |
         | website     | camptocamp.com                |
         | currency_id | by name: EUR and by symbol: € |
    And the company has the "images/c2c-logo.png" logo


  Scenario: Test sql execution
    Given I need a "res.partner" with name: Bart
    And having:
    | key    | value |
    | active | True  |
    Given I execute the SQL commands
    """
    DELETE FROM res_partner WHERE name = 'Lisa';
    DELETE FROM res_partner WHERE name = 'Bart';
    """

    # The relations support the following options:
    # * by {field}: {value}
    # * all by {field}: {value}
    # * add all by {field}: {value}
    # * inactive by {field}: {value}
    # * possibly inactive by {field}: {value}
    # * all inactive by {field}: {value}
    # * add all inactive by {field}: {value}
    # * all possibly inactive by {field}: {value}
    # * add all possibly inactive by {field}: {value}
  Scenario: Test base DSL creation and update of entity and lookup
    Given I need a "res.partner.category" with name: nuke
    And having:
    | key    | value |
    | active | True  |
    Given I need a "res.partner.category" with name: blaster
    And having:
    | key    | value |
    | active | True  |
    Given I need a "res.partner.category" with name: bier
    And having:
    | key    | value      |
    | name   | brown bier |
    | active | True       |
    Given I find a "res.partner.category" with name: brown bier
    Given I need a "res.partner.category" with name: inactive
    And having:
    | key    | value |
    | active | False |
    And I find an inactive "res.partner.category" with name: inactive
    And I find a possibly inactive "res.partner.category" with name: inactive
    Given I need a "res.partner" with name: Homer Simpson and function: Dho
    And having:
    | key         | value                              |
    | category_id | all by name: nuke                  |
    | category_id | add all by name: brown bier        |
    | category_id | add all inactive by name: inactive |
  Scenario: test count and unlink
    Given I need a "res.partner" with name: Lisa
    And having:
    | key    | value |
    | active | True  |
    Given I need a "res.partner" with name: Maggie
    And having:
    | key    | value |
    | active | True  |
    | name   | Lisa  | # hack to have to Lisa
    Given I need a "res.partner" with name: Lisa
    And I have 2 items

    Given I need a "res.partner" with name: Maggie
    And having:
    | key    | value |
    | active | True  |
    Given I need a "res.partner" with name: Maggie
    And I have 1 items
    And I delete it

    Scenario: Test set context regression
      # will set variable ctx.oe_context
    Given I set the context to "{'active_search': False}"

    Scenario: Test Global property setup
   Given I need a "account.account" with oid: scen.acc_bank_eur
    And having:
    | name      | value            |
    | name      | EUR bank account |
    | code      | superbank        |
    | type      | other            |
    | user_type | by name: Cash    |

    Given I set global property named "property_account_receivable" for model "res.partner" and field "property_account_receivable"
    And the property is related to model "account.account" using column "code" and value "superbank"
