###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Copyright 2009 Camptocamp SA
#
##############################################################################

# Features Generic tags (none for all)
##############################################################################

# Branch      # Module       # Processes     # System
@mail @sample_mail

Feature: Ensure that mail configuration is correct
    Scenario: Configure outgoing sever


  @crm_mail_outgoing
  Scenario: Configure smtp emails outgoing
    Given I delete the "IrMail_server" with reference "base.ir_mail_server_localhost0"
    And I need a "IrMail_server" with reference "openerp_smtp_contact"
    When I update it with values:
      | key      | value                |
      | name     | 'openerp_smtp_contact' |
      | sequence | 5                    |
    And I save it
    Then I should have a "IrMail_server" with reference "openerp_smtp_contact"


  @crm_mail_incoming
  Scenario: Configure emails incoming
    Given I need a "FetchmailServer" with reference "openerp_imap_contact"
    When I update it with values:
      | key  | value                  |
      | name | 'openerp_imap_contact' |
    And I set the incoming mail new record on model "crm.lead"
    And I save it
    Then I should have a "FetchmailServer" with reference "openerp_imap_contact"
    And I test and confirm the fetchmail server with reference "openerp_imap_contact"