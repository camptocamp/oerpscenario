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
     | name |
     |base|
     |decimal_precision|
     |web|
     |web_calendar|
     |web_dashboard|
     |web_diagram|
     |web_gantt|
     |web_graph|
     |web_kanban|
     |web_mobile|
     |web_tests|
    Then my modules should have been installed
    Given I give all groups right access to admin user

  Scenario: install lang
   Given I install the following language :
      | lang |
      | fr_FR |
      | de_DE |
   Then the language should be available
   
   
  Scenario: Config lang_locals
    Given I have install "fr_FR" language
    And I set "fr_FR" language to swiss formatting
    Then  "fr_FR" language date format should have changed
  
  Given I have install "de_DE" language
    And I set "de_DE" language to swiss formatting
    Then "de_DE" language date format should have changed

  Scenario: Configure main partner and company
    Given I should have a company
    Given the company has the "logo.png" logo
    And his rml header set to "rml_header.txt"
    Then I set the company with the following data :
       | key | value |
       | name | 'Customer_name' |
    
    And I set the company main partner with the following data :
       | key | value |
       | first_name | 'Customer_name' |
       | lang | 'fr_FR' |     
       | website | 'www.website.com'|
       | customer | false |
    
    And I set the main address with the following data :
       | key | value |
       | zip | '3012' |
       | fax | '+358 9 8561 9901' |  
       | phone | '+41 79 210 98 55' |  
       | email | 'nfo-switzerland@website.com'  | 
       |street | 'Stadtbachstrasse 40' |
       |street2 | '' |
       | city | 'Bern' |
       | name | 'Customer_name System AG' |
    


        
