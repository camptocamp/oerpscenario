###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Copyright 2009 Camptocamp SA
#
##############################################################################

# Features Generic tags (none for all)
##############################################################################
# Branch      # Module       # Processes     # System
@multicompany_base_finance

Feature: MULTICOMPANY SECURITY RULES TO DESACTIVATE IN ORDER TO SHARE FOLLOWING OBJECTS
 
  @multicompany_base_finance_multicompany_security_rules
  Scenario: MULTICOMPANY SECURITY RULES
     Given I need a "ir.rule" with name: "Partner bank company rule"
     And having:
     | name              | value     |
     | active            | false     |

  @multicompany_base_finance_multicompany_security_rules
  Scenario: MULTICOMPANY SECURITY RULES
     Given I need a "ir.rule" with name: "res.partner company"
     And having:
     | name              | value     |
     | active            | false     | 
      
  @multicompany_base_finance_multicompany_security_rules
  Scenario: MULTICOMPANY SECURITY RULES    
     Given I need a "ir.rule" with name: "Portal Personal Contacts"
     And having:
     | name              | value     |
     | active            | false     |      
 
  @multicompany_base_finance_multicompany_security_rules
  Scenario: MULTICOMPANY SECURITY RULES   
     Given I need a "ir.rule" with name: "res_partner: read access on my partner"
     And having:
     | name              | value     |
     | active            | false     |
 
  @multicompany_base_finance_multicompany_security_rules
  Scenario: MULTICOMPANY SECURITY RULES          
     Given I need a "ir.rule" with name: "Product multi-company"
     And having:
     | name              | value     |
     | active            | false     |

  @multicompany_base_finance_multicompany_security_rules
  Scenario: MULTICOMPANY SECURITY RULES          
     Given I need a "ir.rule" with name: "Location multi-company"
     And having:
     | name              | value     |
     | active            | false     |



