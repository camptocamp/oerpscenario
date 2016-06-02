# -*- coding: utf-8 -*-
@upgrade_from_9.0.5
Feature: upgrade to 9.0.6

  Scenario: upgrade
    Given I update the module list
    Given I install the required modules with dependencies:
      | name                                          |
      | specific_product                              |
      | product_dimension                             |
      | account_operation_rule_early_payment_discount |
    Then my modules should have been installed and models reloaded

  @product_category @slow
  Scenario: setup tmp corr for product category
    Given "product.category" is imported from CSV "setup/product.category.csv" using delimiter ","

  @product @slow
  Scenario: setup new fields on existing product
    Given "product.product" is imported from CSV "setup/product.product.csv" using delimiter ","

  @force_translations @slow
  Scenario: Force lang translations
    Given I update the module list
    When I update the following languages
         | lang  |
         | de_DE |

  @payment_term
  Scenario: update payment term
     Given I execute the SQL commands
       """;
         delete from account_payment_term_line;
       """

    Given "account.payment.term" is imported from CSV "setup/payment_term.csv" using delimiter ","

  Scenario: create account operation rule
    Given I need a "account.account" with oid: scenario.account_4090
    And having:
      | key             | value                                      |
      | name            | Skonti                                     |
      | code            | 4090                                       |
      | user_type_id    | by oid: account.data_account_type_expenses |
      | internal_type   | other                                      |

    Given I need a "account.operation.template" with oid: scenario.account_operation_template_skonto
    And having:
      | key          | value                                   |
      | name         | Skonto                                  |
      | label        | Skonto                                  |
      | company_id   | by oid: base.main_company               |
      | account_id   | by oid: scenario.account_4090           |
      | journal_id   | by oid: scenario.journal_ZKB1           |
      | amount_type  | percentage                              |
      | amount       | 100                                     |
      | tax_id       | by name: TVA due à 8.0% (Incl. TN)      |

    Given I need a "account.operation.rule" with oid: scenario.account_operation_rule_skonto
    And having:
      | key          | value                                              |
      | name         | Skonto                                             |
      | rule_type    | early_payment_discount                             |
      | operations   | by oid: scenario.account_operation_template_skonto |

  Scenario: Configure followups
    Given I find an "account_followup.followup" with oid: account_reports_followup.demo_followup1
    And I delete it
    Given I need an "account_followup.followup" with oid: scenario.followup_1
    And having:
      | key        | value                     |
      | company_id | by oid: base.main_company |
    Given I need an "account_followup.followup.line" with oid: scenario.followup_1_line_1
    And having:
      | key         | value                                    |
      | name        | Frist: 20 Tage nach Fälligkeit, per Post |
      | followup_id | by oid: scenario.followup_1              |
      | sequence    | 1                                        |
      | delay       | 20                                       |
      | send_email  | False                                    |
    Given I need an "account_followup.followup.line" with oid: scenario.followup_1_line_2
    And having:
      | key         | value                                    |
      | name        | Frist: 15 Tage nach Fälligkeit, per Post |
      | followup_id | by oid: scenario.followup_1              |
      | sequence    | 2                                        |
      | delay       | 15                                       |
      | send_email  | False                                    |
    Given I need an "account_followup.followup.line" with oid: scenario.followup_1_line_3
    And having:
      | key         | value                                    |
      | name        | Frist: 10 Tage nach Fälligkeit, per Post |
      | followup_id | by oid: scenario.followup_1              |
      | sequence    | 3                                        |
      | delay       | 10                                       |
      | send_email  | False                                    |
    Given I execute the SQL commands
    """
    DELETE FROM ir_translation
    WHERE name = 'account_followup.followup.line,description' AND type = 'model';
    """
    Given I execute the SQL commands
    """
    INSERT INTO ir_translation
    (lang, name, res_id, state, value, type)
    VALUES
    ('de_DE', 'account_followup.followup.line,description', '4', 'translated', '
    Sehr geehrte(r) %(partner_name),
    Wir haben festgestellt, dass die zur Zahlung fälligen Rechnungen noch nicht ausgeglichen wurden. Bitte begleichen Sie die aufgeführten Positionen in den nächsten Tagen.
    Haben Sie die Zahlung bereits veranlasst, so vergessen Sie bitte dieses Schreiben.

    Mit freundlichen Grüßen
    ', 'model'),
    ('fr_FR', 'account_followup.followup.line,description', '4', 'translated', '
    Cher %(partner_name)s,

    Nous avons remarqué que les factures citées ci-dessous ne sont pas encore réglées, cela vous a certainement échappé.
    Nous vous serions très reconnaissants de bien vouloir régler ces factures dans un délai de dix jours.
    Au cas ou le paiement se serait croisé avec le rappel, veuillez considérer ce dernier comme nul et non avenu.

    Veuillez agréer nos salutations distinguées,
    ', 'model'),
    ('it_IT', 'account_followup.followup.line,description', '4', 'translated', '
    Gentile %(partner_name)s,

    Durante un controllo della contabilità abbiamo constatato che le fatture sotto elencate non sono ancora state onorate.
    Vi preghiamo gentilmente di voler pagare l''importo sottoccitato entro 10 giorni.
    Nel caso in cui il pagamento sia stato effettuato negli ultimi giorni vi preghiamo di cestinare questo richiamo.

    Cordiali saluti,
    ', 'model'),
    ('de_DE', 'account_followup.followup.line,description', '5', 'translated', '
    Sehr geehrte(r) %(partner_name),
    Die mit "2" gekennzeichneten Positionen sind überfällig.

    Da Sie auf unsere Zahlungserinnerung bis heute nicht reagiert haben, bitten wir Sie noch einmal höflich, den ausstehenden Betrag innert den nächsten Tagen zu begleichen.

    Mit freundlichen Grüßen
    ', 'model'),
    ('fr_FR', 'account_followup.followup.line,description', '5', 'translated', '
    Cher %(partner_name)s,

    Nous vous rappelons que nous avons déjà repoussé l''échéance de vos  factures. De ce fait le règlement devient très urgent.
    Nous vous prions de bien vouloir vous acquitter du montant global dans un délai de dix jours.

    Veuillez agréer nos salutations distinguées,
    ', 'model'),
    ('it_IT', 'account_followup.followup.line,description', '5', 'translated', '
    Gentile %(partner_name)s,

    Le posizioni contrassegnate con il numero 2 sono scadute da parecchio tempo. Nonostante il nostro precedente richiamo non abbiamo riscontrato alcuna reazione. Vi preghiamo perciò gentilmente di voler pagare l''importo scoperto entro il termine di 10 giorni.

    Cordiali saluti,
    ', 'model'),
    ('de_DE', 'account_followup.followup.line,description', '6', 'translated', '
    Sehr geehrte(r) %(partner_name),

    Unsere Zahlungsaufforderungen sind leider bis heute unbeachtet geblieben. Sollte die Zahlung des fälligen Betrages nicht innerhalb von 5 Tagen erfolgen, müssten wir rechtliche Schritte gegen Sie einleiten.

    Mit freundlichen Grüßen
    ', 'model'),
    ('fr_FR', 'account_followup.followup.line,description', '6', 'translated', '
    Cher %(partner_name)s,

    Malgré nos nombreuses sommations, aucun paiement ni correspondance de votre part ne nous est parvenu avant l''échéance.
    Nous vous prions une dernière fois de bien vouloir nous verser le montant dû dans un ultime délai de 5 jours.
    Si aucun paiement n''est intervenu à l''échéance nous serions obligés de prendre sans délai les mesures nécessaires au recouvrement de la somme due.

    Veuillez agréer nos salutations distinguées,
    ', 'model'),
    ('it_IT', 'account_followup.followup.line,description', '6', 'translated', '
    Gentile %(partner_name)s,

    Purtroppo i nostri richiami di pagamento sono rimasti senza esito. Né abbiamo riscontrato una reazione scritta da parte vostra. Vi preghiamo un''ultima volta di voler versare l''importo scoperto entro 5 giorni.
    Se entro questo termine il pagamento non verrà effettuato saremo purtroppo costretti ad adottare le necessarie misure giuridiche per il recupero della somma dovuta.

    Cordiali saluti,
    ', 'model');

    """
    Then I set the version of the instance to "9.0.6"

  @product_informations @slow
  Scenario: Update supplierinfo
    Given I execute the SQL commands
      """;
      delete from ir_model_data where model='product.supplierinfo';
      """

    Given I execute the SQL commands
      """;
      delete from product_supplierinfo;
      """

    Given "product.supplierinfo" is imported from CSV "setup/product.supplierinfo.csv" using delimiter ","
