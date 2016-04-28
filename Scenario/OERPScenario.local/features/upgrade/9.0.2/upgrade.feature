# -*- coding: utf-8 -*-
@upgrade_from_9.0.1
Feature: upgrade to 9.0.2

  @noupdate_report_template
  Scenario: make report template updatable
    Given I execute the SQL commands
    """;
    update ir_model_data set noupdate='f' where name like 'external_layout_header' and module like 'specific_reports';
    """

  Scenario: upgrade application version

    Given I update the module list
    Given I install the required modules with dependencies:
      | name                       |
      | specific_reports           |
      | specific_product           |
      | report_intrastat           |
      | stock_split_picking        |
      | specific_partner           |
    Then my modules should have been installed and models reloaded

  @ts_activity
  Scenario: setup timesheet activities
    Given "hr.timesheet.sheet.activity" is imported from CSV "setup/hr_timesheet_activity.csv" using delimiter ","
    
  @project
  Scenario: setup default projects
    Given "project.project" is imported from CSV "setup/project.csv" using delimiter ","

  @analytic_account
  Scenario: setup global analytic account
    Given "account.analytic.account" is imported from CSV "setup/analytic_account.csv" using delimiter ","

  @version
  Scenario: setup application version
    Given I set the version of the instance to "9.0.2"
