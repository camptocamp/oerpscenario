# -*- coding: utf-8 -*-
@upgrade_from_9.0.9
Feature: upgrade to 9.0.10

  Scenario: upgrade
    Given I update the module list
    Given I install the required modules with dependencies:
      | name                                          |
      | specific_reports                              |
      | specific_project                              |
    Then my modules should have been installed and models reloaded
  
  
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
      
    Given I find a "project.task.type" with name: Advanced
    And I delete it
    Given I find a "project.task.type" with name: Basic
    And I delete it
    Given I find a "project.task.type" with name: New
    And I delete it
        
    Then I set the version of the instance to "9.0.10"
