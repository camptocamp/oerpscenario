###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Copyright 2009 Camptocamp SA
#
##############################################################################

# Features Generic tags (none for all)
##############################################################################
# Branch      # Module       # Processes     # System
@multicompany_base_finance

Feature: PRE-DEFINED USERS FOR GO LIVE
   As an administrator, I do the following installation steps.

  @multicompany_base_finance_users
  Scenario: USER RIGHTS SETTINGS
    Given we select users below:
        | login |
        | admin |
    Then we assign all groups to the users

 @multicompany_base_finance_users
  Scenario: USERS SETTINGS
  Given I need a "res.users" with oid: scen.fr_main_user
     And having:
     | name                     | value                        |
     | name                     | fr                           |
     | login                    | fr                           |
     | password                 | fr                           |
     | lang                     | fr_FR                        |
     | company_id               | by oid: base.main_company    |
     | company_ids              | all by oid: base.main_company|

    And we assign to user the groups bellow:
     | group_name                       |
     | Contact Creation                 |
     | Settings                         |
     | Access Rights                    |
     | Multi Companies                  |
     | Multi Currencies                 |
     | Technical Features               |
     | Manager                          |
     | User                             |
     | Analytic Accounting              |
     | Sales Pricelists                 |
     | Purchase Pricelists              |
     | Costing Method                   |
     | Manage Multiple Units of Measure |
     | Manage Secondary Unit of Measure |
     | Manage Product Packaging         |
     | Manage Properties of Product     |
     | User                             |
     | Invoicing & Payments             |
     | Employee                         |
     | Accountant                       |
     | Financial Manager                |

 @multicompany_base_finance_users
  Scenario: USERS SETTINGS
  Given I need a "res.users" with oid: scen.ch_main_user
     And having:
     | name        | value                       |
     | name        | ch                          |
     | login       | ch                          |
     | password    | ch                          |
     | lang        | fr_FR                       |
     | company_id  | by oid: scen.CH_company     |
     | company_ids | all by oid: scen.CH_company |

    And we assign to user the groups bellow:
     | group_name                       |
     | Contact Creation                 |
     | Settings                         |
     | Access Rights                    |
     | Multi Companies                  |
     | Multi Currencies                 |
     | Technical Features               |
     | Manager                          |
     | User                             |
     | Analytic Accounting              |
     | Sales Pricelists                 |
     | Purchase Pricelists              |
     | Costing Method                   |
     | Manage Multiple Units of Measure |
     | Manage Secondary Unit of Measure |
     | Manage Product Packaging         |
     | Manage Properties of Product     |
     | User                             |
     | Invoicing & Payments             |
     | Employee                         |
     | Accountant                       |
     | Financial Manager                |

