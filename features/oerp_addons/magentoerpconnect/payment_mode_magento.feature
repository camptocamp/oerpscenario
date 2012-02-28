###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Copyright 2012 Camptocamp SA
#
##############################################################################

# Features Generic tags (none for all)
##############################################################################

# Branch      # Module       # Processes     # System 

Feature: In order to configure the two mains workflows on the sale order importation from Magento. On the Sale order confirmation,
         And ensure  everything will be automatically or manually generated (invoice, payment, etc..).
 
 Scenario: Configure the two mains workflows on the sale order importation from Magento. On the Sale order  confirmation,
   everything will be automatically generated (invoice, payment, etc..). 
 
  @magento_payment_mode
  Scenario: Configure trusted payment mode
    Given I want to configure the following TRUSTED Magento payment mode to AUTOMATICALLY handle related sale orders workflow:
      | Magento payment mode name | Magento payment mode code |
      | Google check out          | googlecheckout            |
      | Paypal express            | paypayl_express           |
      | Paypal standard           | paypal_standard           |
      | Pay box system            | paybox_system             |
      | Servired                  | servired_standard         |
      | BBVA                      | bbva                      |
      | Cofidis                   | cofidis                   |
    And I "allow" partial picking on TRUSTED payment mode

  Scenario: Configure untrusted payment mode
    Given I want to configure the following UNTRUSTED Magento payment mode to MANUALLY handle related sale orders workflow:
      | Magento payment mode name | Magento payment mode code |
      | Cash on delivery          | cashondelivery            |
    And I "forbid" partial picking on UNTRUSTED payment mode