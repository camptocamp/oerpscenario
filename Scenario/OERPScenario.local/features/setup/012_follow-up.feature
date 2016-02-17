# -*- coding: utf-8 -*-
@swisslux @setup @followup

Feature: Initial setup of the payment term
  
  @payment_term
  Scenario: remove default payment term
    Given I find an "account.payment.term" with oid: account.account_payment_term_15days
    And I delete it
    Given I find an "account.payment.term" with oid: account.account_payment_term_net
    And I delete it
    Given I find an "account.payment.term" with oid: account.account_payment_term_immediate
    And I delete it
    
  @payment_term
  Scenario: import payment term
    Given "account.payment.term" is imported from CSV "setup/payment_term.csv" using delimiter ","
