@swisslux @setup @delivery

Feature: Configure the deliveries

  @postlogistics_config
  Scenario: I configure postlogistics authentification
    Given I need a "res.company" with oid: base.main_company
    And having:
      | name                                | value                       |
      | postlogistics_username              | TUW003693                   |
      | postlogistics_password              | 8cB{0tHf))C%                |
      | postlogistics_office                |                             |
      | postlogistics_default_label_layout  | by code: A7                 |
      | postlogistics_default_output_format | by code: PDF                |
      | postlogistics_default_resolution    | by code: 300                |

  @postlogistics_licenses
  Scenario Outline: I configure postlogistics frankling licenses
    Given I need a "postlogistics.license" with oid: <oid>
    And having:
      | name       | value                     |
      | name       | <name>                    |
      | number     | <number>                  |
      | company_id | by oid: base.main_company |
      | sequence   | <sequence>                |

    Examples:
      | sequence | name      | number   | oid                             |
      | 1        | License 1 | 42133507 | scenario.postlogistics_license1 |
      | 2        | License 2 | 60004890 | scenario.postlogistics_license2 |

  @postlogistics_options_update
  Scenario: I update postlogistics services (It will take 1 minute)
    Given I am configuring the company with ref "base.main_company"
    And I update postlogistics services
