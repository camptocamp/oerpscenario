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

Feature: COMPANIES SETTINGS


############################### COMPANY 0 ###############################

 @multicompany_base_finance_init_holding_company
  Scenario: CONFIGURE MAIN PARTNER AND COMPANY
      Given I need a "res.company" with oid: scen.holding_company
      And having:
         | name | value          |
         | name | HOLDING        |


      Given the company has the "c2c_logo.png" logo
      And the company currency is "CHF" with a rate of "1.00"

      Given I need a "res.partner" with oid: scen.holding_partner
      And having:
         | name       | value                    |
         | name       | HOLDING                  |
         | lang       | fr_FR                    |
         | customer   | 1                        |
         | supplier   | 1                        |
         | street     | Quartier de l'innovation |
         | street2    | PSE A                    |
         | city       | Lausanne                 |
         | zip        | 1000                     |
         | phone      | 0800 000 000             |
         | fax        | 01 01 01 01 01           |
         | country_id | by code: FR              |

############################### COMPANY 1 ###############################

  @multicompany_base_finance_init_main_company
  Scenario: CONFIGURE MAIN PARTNER AND COMPANY
      Given I need a "res.company" with oid: base.main_company
      And having:
         | name             | value                        |
         | name             | MA SOCIETE FR                |
         | company_registry | RCS Paris 504595158          |
         | siret            | 50459515800024               |
         | ape              | 4791B                        |
         | parent_id        | by oid: scen.holding_company |


      Given the company has the "c2c_logo.png" logo
      And the company currency is "EUR" with a rate of "1.00"

      Given I need a "res.partner" with oid: base.main_partner
      And having:
         | name                        | MA SOCIETE FR                                  |
         | lang                        | fr_FR                                          |
         | website                     | www.camptocamp.com                             |
         | customer                    | 1                                              |
         | supplier                    | 1                                              |
         | street                      | Quartier de l'innovation                       |
         | street2                     | PSE A                                          |
         | city                        | Lausanne                                       |
         | zip                         | 1000                                           |
         | phone                       | 0800 000 000                                   |
         | fax                         | 01 01 01 01 01                                 |
         | email                       | c2c@c2c.com                                    |
         | country_id                  | by code: FR                                    |
         | vat                         | FR91504595158                                  |

############################### COMPANY 2 ###############################

  @multicompany_base_finance_init_CH_company
  Scenario: CONFIGURE PARTNER AND COMPANY
      Given I need a "res.company" with oid: scen.CH_company
      And having:
         | name             | value                        |
         | name             | MA SOCIETE CH                |
         | company_registry | RC RB 37 1987                |
         | siret            | 1400867803                   |
         | parent_id        | by oid: scen.holding_company |

      Given I need a "res.partner" with oid: scen.CH_partner
      And having:
         | name       | value                     |
         | name       | MA SOCIETE CH             |
         | lang       | fr_FR                     |
         | website    | www.c2c.ch                |
         | customer   | 1                         |
         | supplier   | 1                         |
         | street     | Otto-Hahn-Strasse 10      |
         | street2    |                           |
         | city       |                           |
         | zip        | 77694                     |
         | phone      | 0 7851899760              |
         | fax        | 0 7854987310              |
         | email      | c2c@c2c.com               |
         | country_id | by code: DE               |
         | vat        | DE814430975               |

      Given I need a "res.company" with oid: scen.CH_company
      And having:
         | name             | value                        |
         | partner_id       | by oid:     scen.CH_partner  |

      Given the company has the "central_optics.png" logo
      And the company currency is "CHF" with a rate of "1.00"

