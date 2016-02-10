# -*- coding: utf-8 -*-
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
  
  @csv @users  
  Scenario: import users
    Given "res.users" is imported from CSV "setup/res_users.csv" using delimiter ","

  @csv @employee_address
  Scenario: import personal address for employees
    Given "res.partner" is imported from CSV "setup/hr_employee_home_address.csv" using delimiter ","
    
  @csv @employee  
  Scenario: import employees
    Given "hr.employee" is imported from CSV "setup/hr_employee.csv" using delimiter ","
    
#  Scenario: update partner informations for employees
#    Given "res.partner" is imported from CSV "setup/hr_employee_partner.csv" using delimiter ","
  
  @csv @dpt_mgr
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
    Given I find a "hr.employee" with name: Patrick Glauser
    And the user has the "images/portrait/pgl.jpg" image
    Given I find a "res.users" with oid: scenario.res_users_pgl
    And the user has the "images/portrait/pgl.jpg" image    
    
    # René Glauser
    Given I find a "hr.employee" with name: René Glauser
    And the user has the "images/portrait/rgl.jpg" image
    Given I find a "res.users" with oid: scenario.res_users_rgl
    And the user has the "images/portrait/rgl.jpg" image
    
    # Marcel Glauser
    Given I find a "hr.employee" with name: Marcel Glauser
    And the user has the "images/portrait/mgl.jpg" image
    Given I find a "res.users" with oid: scenario.res_users_mgl
    And the user has the "images/portrait/mgl.jpg" image
    
    # Sabrina Glauser
    #Given I find a "hr.employee" with name: Sabrina Glauser
    #And the user has the "images/portrait/sgl.jpg" image
    #Given I find a "res.users" with oid: scenario.res_users_sgl
    #And the user has the "images/portrait/sgl.jpg" image
    
    # Corinne Fröhlich
    Given I find a "hr.employee" with name: Corinne Fröhlich
    And the user has the "images/portrait/cfr.jpg" image
    Given I find a "res.users" with oid: scenario.res_users_cfr
    And the user has the "images/portrait/cfr.jpg" image
    
    # Csilla Keller
    Given I find a "hr.employee" with name: Csilla Keller
    And the user has the "images/portrait/cke.jpg" image
    Given I find a "res.users" with oid: scenario.res_users_cke
    And the user has the "images/portrait/cke.jpg" image
    
    # Dave Hunziker
    #Given I find a "hr.employee" with name: Dave Hunziker
    #And the user has the "images/portrait/dhu.jpg" image
    #Given I find a "res.users" with oid: scenario.res_users_dhu
    #And the user has the "images/portrait/dhu.jpg" image

    # Stefan Kull
    Given I find a "hr.employee" with name: Stefan Kull
    And the user has the "images/portrait/sku.jpg" image
    Given I find a "res.users" with oid: scenario.res_users_sku
    And the user has the "images/portrait/sku.jpg" image
    
    # Roger Morf
    #Given I find a "hr.employee" with name: Roger Morf
    #And the user has the "images/portrait/rmo.jpg" image
    #Given I find a "res.users" with oid: scenario.res_users_rmo
    #And the user has the "images/portrait/rmo.jpg" image
    
    # Michael Wyss
    Given I find a "hr.employee" with name: Michael Wyss
    And the user has the "images/portrait/mwy.jpg" image
    Given I find a "res.users" with oid: scenario.res_users_mwy
    And the user has the "images/portrait/mwy.jpg" image
 