# -*- coding: utf-8 -*-
@swisslux @setup @project

Feature: Cleanup project from example data

  @project_archive_default_data
  Scenario: Archive default data of project_data.xml
    Given I find a "project.project" with oid: project.project_project_data
    And having:
      | name   | value |
      | active | False |

  @configure_project
  Scenario: Activate time tracking on task
    Given I set "Time on Tasks" to "Manage time estimation on tasks" in "Project" settings menu
    
  @task_stages
  Scenario Outline: Define default stages for Swisslux tasks
    Given I need a "project.task.type" with oid: <stage_oid>
    And having:
      | key         | value         |
      | name        | <stage_name>  |
      | sequence    | <sequence>    |
      | fold        | False         |
      | closed      | False         |

    Examples: Bank Accounts
      | stage_oid           | stage_name        | sequence  |
      | scenario.stage_01   | Neu               | 1         |
      | scenario.stage_02   | in Bearbeitung    | 2         |
      | scenario.stage_03   | zurückgestellt    | 3         |
      | scenario.stage_04   | abgeschlossen     | 4         |
