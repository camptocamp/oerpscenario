# -*- coding: utf-8 -*-
@upgrade_from_9.0.10
Feature: upgrade to 9.0.11

  Scenario: upgrade
    Given I update the module list
    Given I install the required modules with dependencies:
      | name                                          |
      | base_technical_features                       |
      | specific_building_project                     |
      | specific_pad                                  |
    Then my modules should have been installed and models reloaded

  @remove_building_projects
  Scenario: Remove all building projects
    Given I execute the SQL commands
    """;
    DELETE FROM calendar_event WHERE building_project_id IS NOT NULL OR opportunity_id IN (SELECT id FROM crm_lead WHERE building_project_id IS NOT NULL);
    DELETE FROM crm_lead WHERE building_project_id IS NOT NULL;
    DELETE FROM res_partner_role WHERE building_project_id IS NOT NULL;
    DELETE FROM building_project_pricelist;
    DELETE FROM building_project;
    """

  Scenario: remove modules
    Given I uninstall the following modules:
      | name                      |
      | specific_project          |

    Then I set the version of the instance to "9.0.11"
