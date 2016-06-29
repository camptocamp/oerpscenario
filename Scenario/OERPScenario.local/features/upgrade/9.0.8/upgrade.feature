# -*- coding: utf-8 -*-
@upgrade_from_9.0.7
Feature: upgrade to 9.0.8

  Scenario: upgrade
    Given I update the module list
    Given I install the required modules with dependencies:
      | name                                          |
      | specific_project                              |
      | specific_building_project                     |
      | specific_product                              |
      | l10n_ch_sepa                                  |
    Then my modules should have been installed and models reloaded

  @product @slow
  Scenario: adapt account on product
    Given "product.product" is imported from CSV "setup/product.product.csv" using delimiter ","

  @csv @projects
  Scenario: import specific projects
    Given "project.project" is imported from CSV "setup/project.csv" using delimiter ","
  
  @ts_activity
  Scenario: setup timesheet activities
    Given "hr.timesheet.sheet.activity" is imported from CSV "setup/hr_timesheet_activity.csv" using delimiter ","
    
  @update_reception_text_company
  Scenario: set default company reception text
    Given I execute the SQL commands
    """;
    update res_company set receipt_checklist = '
    _____ Anleitung Deutsch
    _____ Anleitung Franz.
    _____ Anleitung Ital.
    _____ Verpackung
    _____ Lieferumfang
    _____ Funktionstest

    Charge:  __________________________

    Technik:
    Produktenews: JA / NEIN
    Visum: ____________________________';
    """

  @force_translations @slow
  Scenario: Force lang translations
    Given I update the module list
    When I update the following languages
         | lang  |
         | de_DE |

    Then I set the version of the instance to "9.0.8"
