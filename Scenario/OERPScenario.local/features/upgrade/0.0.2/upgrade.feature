# -*- coding: utf-8 -*-
@upgrade_from_0.0.1

Feature: upgrade to 0.0.2

  Scenario: installing sales drop shipping
   Given I update the module list
   Given I install the required modules with dependencies:
     | name |
     | base |

   Then my modules should have been installed and models reloaded
