# -*- coding: utf-8 -*-
###############################################################################
#
#    oerpscenario, openerp functional tests
#    copyright 2015 camptocamp sa
#
##############################################################################
@swisslux @setup @hr

Feature: configure users, departments and employees

  ############################################################################
  # As the employee is attached to a department, and the department manager
  # is an employee, I have to import datas in the following sequence:
  # - import just department name, and hierarchy if any
  # - import employee
  # - import updated department list (with manager information)
  ############################################################################
  
  @admin_user
  Scenario: set admin user correctly
    Given I find a "res.users" with oid: base.user_root
    And having:
      | key         | value         |
      | tz          | Europe/Zurich |
  
  @csv @department
  Scenario: import departments
    Given "hr.department" is imported from CSV "setup/hr_department.csv" using delimiter ","
    
#  Scenario: import groups
#    Given "res.groups" is imported from CSV "setup/res_groups.csv" using delimiter ","
    
  Scenario: import users
    Given "res.users" is imported from CSV "setup/res_users.csv" using delimiter ","

#  Scenario: import personal address for employees
#    Given "res.partner" is imported from CSV "setup/hr_employee_home_address.csv" using delimiter ","
    
  @employee  
  Scenario: import employees
    Given "hr.employee" is imported from CSV "setup/hr_employee.csv" using delimiter ","
    
#  Scenario: update partner informations for employees
#    Given "res.partner" is imported from CSV "setup/hr_employee_partner.csv" using delimiter ","
  
  @dpt_mgr
  Scenario: import departments manager
    Given "hr.department" is imported from CSV "setup/hr_department_mgr.csv" using delimiter ","  

  @employee_picture
  Scenario: set the picture to employee (and related user)
  
    # Administrator
    Given I find a "hr.employee" with oid: hr.employee
    #And the user has the "images/portrait/admin.png" image
    Given I find a "res.users" with oid: base.user_root
    And the user has the "images/portrait/admin.png" image
  
    # Patrick Glauser
    Given I find a "hr.employee" with oid: scenario.hr_employee_pgl
    And the user has the "images/portrait/pgl.jpg" image
    Given I find a "res.users" with oid: scenario.res_users_pgl
    And the user has the "images/portrait/pgl.jpg" image    
    
    # René Glauser
    Given I find a "hr.employee" with oid: scenario.hr_employee_rgl
    And the user has the "images/portrait/rgl.jpg" image
    Given I find a "res.users" with oid: scenario.res_users_rgl
    And the user has the "images/portrait/rgl.jpg" image
    
    # Marcel Glauser
    Given I find a "hr.employee" with oid: scenario.hr_employee_mgl
    And the user has the "images/portrait/mgl.jpg" image
    Given I find a "res.users" with oid: scenario.res_users_mgl
    And the user has the "images/portrait/mgl.jpg" image
    
    # Sabrina Glauser
    #Given I find a "hr.employee" with oid: scenario.hr_employee_sgl
    #And the user has the "images/portrait/sgl.jpg" image
    #Given I find a "res.users" with oid: scenario.res_users_sgl
    #And the user has the "images/portrait/sgl.jpg" image
    
    # Corinne Fröhlich
    Given I find a "hr.employee" with oid: scenario.hr_employee_cfr
    And the user has the "images/portrait/cfr.jpg" image
    Given I find a "res.users" with oid: scenario.res_users_cfr
    And the user has the "images/portrait/cfr.jpg" image
    
    # Csilla Keller
    Given I find a "hr.employee" with oid: scenario.hr_employee_cke
    And the user has the "images/portrait/cke.jpg" image
    Given I find a "res.users" with oid: scenario.res_users_cke
    And the user has the "images/portrait/cke.jpg" image
    
    # Dave Würgler
    #Given I find a "hr.employee" with oid: scenario.hr_employee_dwu
    #And the user has the "images/portrait/dwu.jpg" image
    #Given I find a "res.users" with oid: scenario.res_users_dwu
    #And the user has the "images/portrait/dwu.jpg" image

    # Stefan Kull
    Given I find a "hr.employee" with oid: scenario.hr_employee_sku
    And the user has the "images/portrait/sku.jpg" image
    Given I find a "res.users" with oid: scenario.res_users_sku
    And the user has the "images/portrait/sku.jpg" image
    
    # Roger Morf
    #Given I find a "hr.employee" with oid: scenario.hr_employee_rmo
    #And the user has the "images/portrait/rmo.jpg" image
    #Given I find a "res.users" with oid: scenario.res_users_rmo
    #And the user has the "images/portrait/rmo.jpg" image
    
    # Csilla Keller
    Given I find a "hr.employee" with oid: scenario.hr_employee_cke
    And the user has the "images/portrait/cke.jpg" image
    Given I find a "res.users" with oid: scenario.res_users_cke
    And the user has the "images/portrait/cke.jpg" image
    
    # Michael Wyss
    Given I find a "hr.employee" with oid: scenario.hr_employee_mwy
    And the user has the "images/portrait/mwy.jpg" image
    Given I find a "res.users" with oid: scenario.res_users_mwy
    And the user has the "images/portrait/mwy.jpg" image
  
