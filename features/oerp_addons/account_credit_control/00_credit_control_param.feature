###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Copyright 2009 Camptocamp SA
#
##############################################################################
##############################################################################
# Branch      # Module       # Processes     # System
@credit_control    

Feature: In order to validate account voucher behavious as an admin user I prepare data
    
  @credit_control_setup_install_modules
  Scenario: MODULES INSTALLATION

    Given I do not want all demo data to be loaded on install
    And I install the required modules:
      | name                   |
      | account_credit_control |

    Then my modules should have been installed and models reloaded

  @credit_control_policy_2_times
  Scenario: Configure the credit control policy in 2 times
    Given I configure the following accounts on the credit control policy with oid: "account_credit_control.credit_control_2_time":
      | account code |
      | 4111         |
      | 4112         |

  @credit_control_policy_3_times
  Scenario: Configure the credit control policy in 3 times
    Given I configure the following accounts on the credit control policy with oid: "account_credit_control.credit_control_3_time":
      | account code |
      | 4111         |
      | 4112         |
