###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Copyright 2012 Camptocamp SA
#    Author Nicolas Bessi
##############################################################################

# Features Generic tags (none for all)
##############################################################################

@credit_management_module @credit_management_base_data

Feature: Ensure that mail credit management is correct


  @credit_management_data
  Scenario: Create data
    Given I need a "ir.module.module" with name: account_credit_management
    And having:
      |name|value|
      | demo | 1 |
    Given I install the required modules:
      | name |
      | account_credit_management |
    Given I need a "res.partner" with oid: credit_management.trusted_partner
    And having:
      | name              | value                    |
      | name              | Credit m. trusted partner |
      | customer          | 1                        |
      | credit_profile_id | by name: No follow       |

    Given I need a "res.partner.address" with oid: credit_management.trusted_address
    And having:
      | name       | value                                     |
      | name       | Luc Maurer                                |
      | zip        | 1015                                      |
      | city       | lausanne                                  |
      | email      | openerp@locahost.dummy                    |
      | phone      | +41 21 619 10 12                          |
      | street     | PSE-A, EPF                                |
      | partner_id | by oid: credit_management.trusted_partner |


    Given I need a "res.partner" with oid: credit_management.not_so_trusted_partner
    And having:
      | name              | value                            |
      | name              | Credit m. not so trusted partner |
      | customer          | 1                                |
      | credit_profile_id | by name:  2 time policy          |

    Given I need a "res.partner.address" with oid: credit_management.not_so_trusted_address
    And having:
      | name       | value                                            |
      | name       | Not so trusted                                   |
      | zip        | 1015                                             |
      | city       | lausanne                                         |
      | email      | openerp@locahost.dummy                           |
      | phone      | +41 21 619 10 12                                 |
      | street     | PSE-A, EPF                                       |
      | partner_id | by oid: credit_management.not_so_trusted_partner |


    Given I need a "res.partner" with oid: credit_management.untrusted_partner
    And having:
      | name              | value                      |
      | name              | Credit m. untrusted partner |
      | customer          | 1                          |
      | credit_profile_id | by name:  3 time policy    |

    Given I need a "res.partner.address" with oid: credit_management.untrusted_address
    And having:
      | name       | value                                       |
      | name       | Untrusted                                   |
      | zip        | 1015                                        |
      | city       | lausanne                                    |
      | email      | openerp@locahost.dummy                      |
      | phone      | +41 21 619 10 12                            |
      | street     | PSE-A, EPF                                  |
      | partner_id | by oid: credit_management.untrusted_partner |


    Given I need a "res.partner" with oid: credit_management.lambda_partner
    And having:
      | name              | value                      |
      | name              | Credit m. lambda partner |
      | customer          | 1                          |

    Given I need a "res.partner.address" with oid: credit_management.lambda_address
    And having:
      | name       | value                                    |
      | name       | Lambda                                   |
      | zip        | 1015                                     |
      | city       | lausanne                                 |
      | email      | openerp@locahost.dummy                   |
      | phone      | +41 21 619 10 12                         |
      | street     | PSE-A, EPF                               |
      | partner_id | by oid: credit_management.lambda_partner |



    @inv1
    Scenario: invoices
    # trusted invoice on trusted partner no follow
    Given I need a "account.invoice" with oid: credit_management.inv1
    And having:
      | name               | value                                     |
      | name               | trusted invoice 1                         |
      | date_invoice       | 2012-01-01                                |
      | date_due           | 2012-02-15                                |
      | address_invoice_id | by oid: credit_management.trusted_address |
      | partner_id         | by oid:  credit_management.trusted_partner |
      | account_id         | by name: Trusted Debtors - (test)         |
      | journal_id         | by name: Sales Journal - (test)           |


    Given I need a "account.invoice.line" with oid: credit_management.inv_line1
    And having:
      | name       | value                           |
      | name       | trusted invoice line 1          |
      | quantity   | 1                               |
      | price_unit | 100                             |
      | account_id | by name: Product Sales - (test) |
      | invoice_id | by oid: credit_management.inv1  |
    Given I find a "account.invoice" with oid: credit_management.inv1
    And I open the credit invoice



    Given I need a "account.invoice" with oid: credit_management.inv2
    And having:
      | name               | value                                    |
      | name               | lambda invoice 1                         |
      | date_invoice       | 2012-01-01                               |
      | date_due           | 2012-02-15                               |
      | address_invoice_id | by oid: credit_management.lambda_address |
      | partner_id         | by oid: credit_management.lambda_partner |
      | account_id         | by name: Not so trusted Debtors - (test) |
      | journal_id         | by name: Sales Journal - (test)          |

    Given I need a "account.invoice.line" with oid: credit_management.inv_line2
    And having:
      | name       | value                           |
      | name       | lambda invoice line 1           |
      | quantity   | 1                               |
      | price_unit | 130                             |
      | account_id | by name: Product Sales - (test) |
      | invoice_id | by oid: credit_management.inv2  |
    Given I find a "account.invoice" with oid: credit_management.inv2
    And I open the credit invoice


    Given I need a "account.invoice" with oid: credit_management.inv3
    And having:
      | name               | value                                            |
      | name               | Not so trusted invoice                           |
      | date_invoice       | 2012-01-01                                       |
      | date_due           | 2012-02-15                                       |
      | address_invoice_id | by oid: credit_management.not_so_trusted_address |
      | partner_id         | by oid: credit_management.not_so_trusted_partner |
      | account_id         | by name: Not so trusted Debtors - (test)         |
      | journal_id         | by name: Sales Journal - (test)                  |


    Given I need a "account.invoice.line" with oid: credit_management.inv_line3
    And having:
      | name       | value                           |
      | name       | Not so trusted invoice line 1 |
      | quantity   | 1                               |
      | price_unit | 150                             |
      | account_id | by name: Product Sales - (test) |
      | invoice_id | by oid: credit_management.inv3  |
    Given I find a "account.invoice" with oid: credit_management.inv3
    And I open the credit invoice




    Given I need a "account.invoice" with oid: credit_management.inv4
    And having:
      | name               | value                                       |
      | name               | Untrusted invoice                           |
      | date_invoice       | 2012-01-01                                  |
      | date_due           | 2012-02-15                                  |
      | address_invoice_id | by oid: credit_management.untrusted_address |
      | partner_id         | by oid: credit_management.untrusted_partner |
      | account_id         | by name: Not so trusted Debtors - (test)    |
      | journal_id         | by name: Sales Journal - (test)             |


    Given I need a "account.invoice.line" with oid: credit_management.inv_line4
    And having:
      | name       | value                           |
      | name       | Un trusted invoice line 1       |
      | quantity   | 1                               |
      | price_unit | 170                             |
      | account_id | by name: Product Sales - (test) |
      | invoice_id | by oid: credit_management.inv4  |
    Given I find a "account.invoice" with oid: credit_management.inv4
    And I open the credit invoice


    Given I need a "account.invoice" with oid: credit_management.inv5
    And having:
      | name               | value                                    |
      | name               | lamba invoice with untrusted policy      |
      | date_invoice       | 2012-01-01                               |
      | date_due           | 2012-02-15                               |
      | address_invoice_id | by oid: credit_management.lambda_address |
      | partner_id         | by oid: credit_management.lambda_partner |
      | account_id         | by name: Not so trusted Debtors - (test) |
      | journal_id         | by name: Sales Journal - (test)          |
      | credit_profile_id  | by name: 3 time policy                   |


    Given I need a "account.invoice.line" with oid: credit_management.inv_line5
    And having:
      | name       | value                           |
      | name       | Un trusted invoice line 1       |
      | quantity   | 1                               |
      | price_unit | 200                             |
      | account_id | by name: Product Sales - (test) |
      | invoice_id | by oid: credit_management.inv5 |
    Given I find a "account.invoice" with oid: credit_management.inv5
    And I open the credit invoice
