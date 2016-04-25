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
    Then my modules should have been installed and models reloaded

  @version
  Scenario: setup application version
    Given I set the version of the instance to "9.0.2"
