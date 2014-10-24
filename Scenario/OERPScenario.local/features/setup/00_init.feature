# -*- coding: utf-8 -*-
@core_setup

Feature: Parameter the new database
  In order to have a coherent installation
  I've automated the manual steps.

  @no_login
  Scenario: CREATE DATABASE
    Given I create database from config file

  @webkit_path
  Scenario: SETUP WEBKIT path before running YAML tests
    Given I need a "res.company" with oid: base.main_company
    And I set the webkit path to "/srv/openerp/webkit_library/wkhtmltopdf-amd64"

  @modules
  Scenario: install modules
    Given I install the required modules with dependencies:
        | name                           |
        # oca/ocb
        | account                        |
