###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Copyright 2009 Camptocamp SA
#
##############################################################################
##############################################################################
# Branch      # Module       # Processes     # System
@addons       @account_voucher       @account_voucher_addons     @param

Feature: As an admin user I prepare data

  @account_voucher_init
  Scenario: setting journals
   Given I need a "account.journal" with oid: scen.voucher_eur_journal
   And having:
     | name                      | value                           |
     | name                      | EUR bank                        |
     | code                      | BEUR                            |
     | type                      | bank                            |
     | journal_user              | 1                               |
     | check_dtls                | 1                               |
     | default_debit_account_id  | by code: 5121                   |
     | default_credit_account_id | by code: 5121                   |
     | view_id                   | by name: Bank/Cash Journal View |
     | allow_date                | t                               |       
  
   Given I need a "account.journal" with oid: scen.voucher_usd_journal
   And having:
     | name                      | value                           |
     | name                      | USD bank                        |
     | code                      | BUSD                            |
     | type                      | bank                            |
     | currency                  | by name: USD                    |
     | journal_user              | 1                               |
     | check_dtls                | 1                               |
     | default_debit_account_id  | by code: 5122                   |
     | default_credit_account_id | by code: 5122                   |
     | view_id                   | by name: Bank/Cash Journal View |
     | allow_date                | t                               |  
         
   Given I need a "account.journal" with oid: scen.voucher_gbp_journal
   And having:
      | name                      | value                           |
      | name                      | GBP bank                        |
      | code                      | BGBP                            |
      | type                      | bank                            |
      | currency                  | by name: GBP                    |
      | journal_user              | 1                               |
      | check_dtls                | 1                               |
      | default_debit_account_id  | by code: 5123                   |
      | default_credit_account_id | by code: 5123                   |
      | view_id                   | by name: Bank/Cash Journal View |
      | allow_date                | t                                   |      
            
   Given I need a "account.journal" with oid: scen.sales_journal
   And having:
      | name                      | value                               |
      | name                      | Sales                               |
      | code                      | SAJ                                 |
      | type                      | sale                                |
      | journal_user              | 1                                   |
      | check_dtls                | 1                                   |
      | default_debit_account_id  | by code: 707                        |
      | default_credit_account_id | by code: 707                        |
      | view_id                   | by name: Sale/Purchase Journal View |
      | group_invoice_lines       | f                                   |
      | allow_date                | t                                   |      
                  
     Given I need a "account.journal" with oid: scen.ref_sales_journal
   And having:
      | name                      | value                               |
      | name                      | Sales credit notes                  |
      | code                      | SCNJ                                |
      | type                      | sale_refund                         |
      | journal_user              | 1                                   |
      | check_dtls                | 1                                   |
      | default_debit_account_id  | by code: 707                        |
      | default_credit_account_id | by code: 707                        |
      | view_id                   | by name: Sale/Purchase Journal View |    
      | group_invoice_lines       | f                                   |
      | allow_date                | t                                   |      
                  
    Given I need a "account.journal" with oid: scen.purchases_journal
   And having:
      | name                      | value                               |
      | name                      | Purchases                           |
      | code                      | PUJ                                 |
      | type                      | purchase                            |
      | journal_user              | 1                                   |
      | check_dtls                | 1                                   |
      | default_debit_account_id  | by code: 607                        |
      | default_credit_account_id | by code: 607                        |
      | view_id                   | by name: Sale/Purchase Journal View |
      | group_invoice_lines       | f                                   |
      | allow_date                | t                                   |      
                        
     Given I need a "account.journal" with oid: scen.ref_purchases_journal
   And having:
      | name                      | value                               |
      | name                      | Purchases credit notes              |
      | code                      | PCNJ                                |
      | type                      | purchase_refund                     |
      | journal_user              | 1                                   |
      | check_dtls                | 1                                   |
      | default_debit_account_id  | by code: 607                        |
      | default_credit_account_id | by code: 607                        |
      | view_id                   | by name: Sale/Purchase Journal View |         
      | group_invoice_lines       | f                                   |
      | allow_date                | t                                   |      
                        
     Given I need a "account.journal" with oid: scen.misc_journal
   And having:
      | name                      | value                               |
      | name                      | Miscellaneous                       |
      | code                      | MISC                                |
      | type                      | general                             |
      | journal_user              | 1                                   |
      | check_dtls                | 1                                   |
      | view_id                   | by name: Journal View               |     
      | allow_date                | t                                   |    
                   
     Given I need a "account.journal" with oid: scen.misc_journal
   And having:
      | name                      | value                               |
      | name                      | Opening journal                     |
      | code                      | OPEN                                |
      | type                      | situation                           |
      | journal_user              | 1                                   |
      | check_dtls                | 1                                   |
      | default_debit_account_id  | by code: 120                        |
      | default_credit_account_id | by code: 120                        |
      | view_id                   | by name: Journal View               |   
      | centralisation            | t                                   |
    
      
      
   Given I allow cancelling entries on all journals
