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

  @followup_clean
  Scenario: remove demo followup
    Given I find an "account_followup.followup" with oid: account_reports_followup.demo_followup1
    And I delete it

  @followup_new
  Scenario: Create followup
    Given I need an "account_followup.followup" with oid: scenario.followup_1
    And having:
      | key        | value                     |
      | company_id | by oid: base.main_company |
    Given I need an "account_followup.followup.line" with oid: scenario.followup_1_line_1
    And having:
      | key         | value                                    |
      | name        | 1. Mahnung                               |
      | followup_id | by oid: scenario.followup_1              |
      | sequence    | 1                                        |
      | delay       | 20                                       |
      | send_email  | False                                    |
    Given I need an "account_followup.followup.line" with oid: scenario.followup_1_line_2
    And having:
      | key         | value                                    |
      | name        | 2. Mahnung                               |
      | followup_id | by oid: scenario.followup_1              |
      | sequence    | 2                                        |
      | delay       | 15                                       |
      | send_email  | False                                    |
      | description | STHOESUTHOE |
    Given I need an "account_followup.followup.line" with oid: scenario.followup_1_line_3
    And having:
      | key         | value                                    |
      | name        | 3. Mahnung                               |
      | followup_id | by oid: scenario.followup_1              |
      | sequence    | 3                                        |
      | delay       | 10                                       |
      | send_email  | False                                    |

  @followup_trans
  Scenario: Translate followup
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
    Sehr geehrte Damen und Herren,
    
    Wir haben festgestellt, dass die zur Zahlung fälligen Rechnungen noch nicht ausgeglichen wurden. Bitte begleichen Sie die aufgeführten Positionen in den nächsten Tagen.
    Haben Sie die Zahlung bereits veranlasst, so vergessen Sie bitte dieses Schreiben.

    Mit freundlichen Grüssen
    ', 'model'),
    ('fr_FR', 'account_followup.followup.line,description', '4', 'translated', '
    Madame, Monsieur,

    Nous avons remarqué que les factures citées ci-dessous ne sont pas encore réglées, cela vous a certainement échappé.
    Nous vous serions très reconnaissants de bien vouloir régler ces factures dans un délai de dix jours.
    Au cas ou le paiement se serait croisé avec le rappel, veuillez considérer ce dernier comme nul et non avenu.

    Veuillez agréer nos salutations distinguées,
    ', 'model'),
    ('it_IT', 'account_followup.followup.line,description', '4', 'translated', '
    Signori e signore,

    Durante un controllo della contabilità abbiamo constatato che le fatture sotto elencate non sono ancora state onorate.
    Vi preghiamo gentilmente di voler pagare l''importo sottoccitato entro 10 giorni.
    Nel caso in cui il pagamento sia stato effettuato negli ultimi giorni vi preghiamo di cestinare questo richiamo.

    Cordiali saluti,
    ', 'model'),
    ('de_DE', 'account_followup.followup.line,description', '5', 'translated', '
    Sehr geehrte Damen und Herren,
    
    Die mit "2" gekennzeichneten Positionen sind überfällig.

    Da Sie auf unsere Zahlungserinnerung bis heute nicht reagiert haben, bitten wir Sie noch einmal höflich, den ausstehenden Betrag innert den nächsten Tagen zu begleichen.

    Mit freundlichen Grüssen
    ', 'model'),
    ('fr_FR', 'account_followup.followup.line,description', '5', 'translated', '
    Madame, Monsieur,

    Nous vous rappelons que nous avons déjà repoussé l''échéance de vos  factures. De ce fait le règlement devient très urgent.
    Nous vous prions de bien vouloir vous acquitter du montant global dans un délai de dix jours.

    Veuillez agréer nos salutations distinguées,
    ', 'model'),
    ('it_IT', 'account_followup.followup.line,description', '5', 'translated', '
    Signori e signore,

    Le posizioni contrassegnate con il numero 2 sono scadute da parecchio tempo. Nonostante il nostro precedente richiamo non abbiamo riscontrato alcuna reazione. Vi preghiamo perciò gentilmente di voler pagare l''importo scoperto entro il termine di 10 giorni.

    Cordiali saluti,
    ', 'model'),
    ('de_DE', 'account_followup.followup.line,description', '6', 'translated', '
    Sehr geehrte Damen und Herren,
    
    Unsere Zahlungsaufforderungen sind leider bis heute unbeachtet geblieben. Sollte die Zahlung des fälligen Betrages nicht innerhalb von 5 Tagen erfolgen, müssten wir rechtliche Schritte gegen Sie einleiten.

    Mit freundlichen Grüssen
    ', 'model'),
    ('fr_FR', 'account_followup.followup.line,description', '6', 'translated', '
    Madame, Monsieur,

    Malgré nos nombreuses sommations, aucun paiement ni correspondance de votre part ne nous est parvenu avant l''échéance.
    Nous vous prions une dernière fois de bien vouloir nous verser le montant dû dans un ultime délai de 5 jours.
    Si aucun paiement n''est intervenu à l''échéance nous serions obligés de prendre sans délai les mesures nécessaires au recouvrement de la somme due.

    Veuillez agréer nos salutations distinguées,
    ', 'model'),
    ('it_IT', 'account_followup.followup.line,description', '6', 'translated', '
    Signori e signore,

    Purtroppo i nostri richiami di pagamento sono rimasti senza esito. Né abbiamo riscontrato una reazione scritta da parte vostra. Vi preghiamo un''ultima volta di voler versare l''importo scoperto entro 5 giorni. 
    Se entro questo termine il pagamento non verrà effettuato saremo purtroppo costretti ad adottare le necessarie misure giuridiche per il recupero della somma dovuta.

    Cordiali saluti,
    ', 'model');

    """
