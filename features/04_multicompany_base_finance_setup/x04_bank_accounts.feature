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
Feature: COMPANIES BANK ACCOUNTS 
         (THIS AUTOMATICALY GENERATE FINANCIAL JOURNALS TO AMEND/COMPLETE ON NEXT SCENARIO)

############################### COMPANY 1 ###############################
  @multicompany_base_finance_bank_account
  Scenario: CONFIGURE BANQUE ACCOUNT:
     Given I need a "res.partner.bank" with oid: scen.main_bank1
     And having:
         | name                 | value                         |
         | partner_id           | by oid: base.main_partner     |
         | company_id           | by oid: base.main_company     |
         | bank_name            | BNP LA DEFENSE ENTREPRISE     |
         | street               | 5 bis Place de la Defense     |
         | city                 | Puteaux                       |
         | zip                  | 92800                         |
         | country_id           | by code: FR                   |
         | state                | rib                           |
         | bank_code            | 30004                         |
         | office               | 01328                         |
         | rib_acc_number       | 00012460722                   |
         | key                  | 04                            |
         | acc_number           | FR7630004013280001246072204   |
         | bank_bic             | BNPAFRPPPTX                   |



############################### COMPANY 2 ###############################

  @multicompany_base_finance_bank_account
  Scenario: CONFIGURE BANQUE ACCOUNT:
     Given I need a "res.partner.bank" with oid: scen.main_bank
     And having:
         | name             | value                     |
         | partner_id       | by oid: scen.CH_partner   |
         | company_id       | by oid: scen.CH_company   |
         | zip              | CH-1000                   |
         | country_id       | by code: CH               |
         | state            | bvr                       |
         | street           | Chemin de la Gravière 8   |
         | acc_number       | 01-4544-9                 |
         | bvr_adherent_num | 935430                    |
         | print_bank       | 0                         |
         | print_account    | 1                         |
         | bank_name        | CREDIT SUISSE             |
         | bank_bic         | CRESCHZZ80A               |
         | currency_id      | by name: CHF              |

     Given I need a "res.partner.bank" with oid: scen.main_bank_dta
     And having:
         | name             | value                      |
         | partner_id       | by oid: scen.CH_partner    |
         | company_id       | by oid: scen.CH_company    |
         | zip              | CH-1000                    |
         | country_id       | by code: CH                |
         | state            | bank                       |
         | street           | Chemin de la Gravière 8    |
         | acc_number       | CH23 0483 5072 1562 3100 3 |
         | bank_name        | CREDIT SUISSE              |
         | bank_bic         | CRESCHZZ80A                |
         | currency_id      | by name: CHF               |

  @multicompany_base_finance_bank_account
  Scenario: CONFIGURE BANQUE ACCOUNT:
     Given I need a "res.bank" with oid: scen.CH_b1
     And having:
         | name       | value                   |
         | name       | Commerzbank             |
         | street     | Hauptstrasse 2          |
         | city       | Kehl                    |
         | zip        | 77694                   |
         | country    | by code: CH             |
         | bic        | DRESDEFF680             |

     Given I need a "res.partner.bank" with oid: scen.CH_bank1
     And having:
         | name       | value                       |
         | partner_id | by oid: scen.CH_partner     |
         | company_id | by oid: scen.CH_company     |
         | bank_name  | Commerzbank                 |
         | street     | Hauptstrasse 2              |
         | city       | Kehl                        |
         | zip        | 77694                       |
         | country_id | by code: CH                 |
         | state      | iban                        |
         | acc_number | DE16 6808 0030 0553 0349 00 |
         | bank_bic   | DRESDEFF680                 |
         | bank       | by oid: scen.CH_b1          |

  
#USD
     Given I need a "res.bank" with oid: scen.CH_b4
     And having:
         | name    | value              |
         | name    | UniCredit Bank     |
         | street  |                    |
         | city    | Budapest           |
         | zip     |                    |
         | country | by code: HU        |
         | bic     | BACXHUHB           |


     Given I need a "res.partner.bank" with oid: scen.CH_bank4
     And having:
         | name       | value                              |
         | partner_id | by oid: scen.CH_partner            |
         | company_id | by oid: scen.CH_company            |
         | bank_name  | UniCredit Bank                     |
         | street     |                                    |
         | city       | Budapest                           |
         | zip        |                                    |
         | country_id | by code: HU                        |
         | state      | iban                               |
         | acc_number | HU76 1091 8001 0000 0056 8267 0008 |
         | bank_bic   | BACXHUHB                           |
         | bank       | by oid: scen.CH_b4                 |

#GBP
     Given I need a "res.bank" with oid: scen.CH_b5
     And having:
         | name       | value                    |
         | name       | Fio Banka                |
         | street     |                          |
         | city       |                          |
         | zip        |                          |
         | country    | by code: HU              |
         | bic        | FIOBCZPPXXX              |

     Given I need a "res.partner.bank" with oid: scen.CH_bank5
     And having:
         | name       | value                    |
         | partner_id | by oid: scen.CH_partner  |
         | company_id | by oid: scen.CH_company  |
         | bank_name  | Fio Banka                |
         | street     |                          |
         | city       |                          |
         | zip        |                          |
         | country_id | by code: HU              |
         | state      | iban                     |
         | acc_number | CZ6620100000002600039960 |
         | bank_bic   | FIOBCZPPXXX              |
         | bank       | by oid: scen.CH_b5       |

