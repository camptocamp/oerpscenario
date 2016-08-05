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
  
    Given I find a "project.task.type" with name: Advanced
    And I delete it
    Given I find a "project.task.type" with name: Basic
    And I delete it
    Given I find a "project.task.type" with name: New1
    And I delete it

    Given I need a "project.task.type" with oid: <stage_oid>
    And having:
      | key         | value         |
      | name        | <stage_name>  |
      | sequence    | <sequence>    |
      | fold        | False         |
      | closed      | False         |

    Examples: Task Stages
      | stage_oid           | stage_name        | sequence  |
      | scenario.stage_01   | New               | 1         |
      | scenario.stage_02   | In Progress       | 2         |
      | scenario.stage_03   | Postponed         | 3         |
      | scenario.stage_04   | Completed         | 4         |

    Given I set the context to "{'lang':'de_DE'}"
    Given "project.task.type" is imported from CSV "setup/project_task_stages_de.csv" using delimiter ","    
    Given I set the context to "{'lang':'fr_FR'}"
    Given "project.task.type" is imported from CSV "setup/project_task_stages_fr.csv" using delimiter ","
    Given I set the context to "{'lang':'it_IT'}"
    Given "project.task.type" is imported from CSV "setup/project_task_stages_it.csv" using delimiter ","
    Given I set the context to "{'lang':'en_US'}"  
