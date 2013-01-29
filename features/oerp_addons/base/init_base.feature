###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Copyright 2012 Camptocamp SA
#
##############################################################################

# Features Generic tags (none for all)
##############################################################################

@init_base
Feature: Param the new database
  In order to have a coherent installation
  I autmated the manual steps.

  Scenario: install modules
    Given I update the module list
    Given I install the required modules with dependencies:
     | name              |
     | base              |
     | decimal_precision |
     | web               |
     | web_calendar      |
     | web_dashboard     |
     | web_diagram       |
     | web_gantt         |
     | web_graph         |
     | web_kanban        |
     | web_mobile        |
     | web_tests         |
    Then my modules should have been installed and models reloaded
    Given I give all groups right access to admin user
    And we select admin user
    And we activate the extended view on the users

  Scenario: install lang
   Given I install the following language :
      | lang  |
      | fr_FR |
   Then the language should be available


  Scenario: Config lang_locals
    Given I have install "fr_FR" language
    And I set "fr_FR" language to swiss formatting
    Then  "fr_FR" language date format should have changed

  Scenario: Configure main partner and company
    Given I should have a company
    Given the company has the "logo.png" logo
    And his rml header set to "rml_header.txt"
      Then I set the company with the following data :
         | key         | value                                                     |
         | name        | 'Doremi'                                  |
         | rml_header1 | ''                                                        |
         | lib_path    | '/srv/openerp/instances/webkit_library/wkhtmltopdf-amd64' |
      And the main company currency is "EUR" with a rate of "1.00"


    And I set the company main partner with the following data :
       | key        | value                        |
       | first_name | 'Doremi Technologies'        |
       | lang       | 'fr_FR'                      |
       | website    | 'http://www.doremilabs.com/' |
       | customer   | false                        |

    And I set the main address with the following data :
       | key     | value                     |
       | zip     | '06905'                   |
       | fax     | '+33 (0)492 954 281'      |
       | phone   | '+33 (0)492 954 280'      |
       | email   | 'info@doremitechno.org'   |
       | street  | '1900, Route des Crêtes'  |
       | street2 | 'BP 298'                  |
       | city    | 'Sophia Antipolis'        |
       | name    | 'Doremi Technologies' |


        
