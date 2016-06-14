# -*- coding: utf-8 -*-
@upgrade_from_9.0.6
Feature: upgrade to 9.0.7

  Scenario: upgrade
    Given I update the module list
    Given I install the required modules with dependencies:
      | name                                          |
      | specific_reports                              |
      | specific_product                              |
    Then my modules should have been installed and models reloaded

  @force_translations @slow
  Scenario: Force lang translations
    Given I update the module list
    When I update the following languages
         | lang  |
         | de_DE |

    Then I set the version of the instance to "9.0.6"
