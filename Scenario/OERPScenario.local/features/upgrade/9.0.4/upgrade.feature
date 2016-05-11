# -*- coding: utf-8 -*-
@upgrade_from_9.0.3
Feature: upgrade to 9.0.4

  Scenario: upgrade
    Given I update the module list
    Given I install the required modules with dependencies:
      | name                       |
      | specific_building_project  |
      | specific_reports           |
      | specific_account           |
    Then my modules should have been installed and models reloaded
    Given I find a "res.company" with oid: base.main_company
    And having:
      | bvr_scan_line_horz | 0.00 |
      | bvr_scan_line_vert | 0.00 |
    Then I set the version of the instance to "9.0.4"
