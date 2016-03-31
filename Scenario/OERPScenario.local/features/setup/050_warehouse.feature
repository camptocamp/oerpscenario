# -*- coding: utf-8 -*-
@swisslux @setup @warehouse

Feature: Configure Warehouse and Logistic processes

  @traceability
  Scenario: Configure traceability
    Given I set "Lots and Serial Numbers" to "Track lots or serial numbers" in "Inventory" settings menu
    Given I enable "Barcode scanner support" in "Inventory" settings menu

  @accounting
  Scenario: Inventory valuation
    Given I set "Inventory Valuation" to "Periodic inventory valuation (recommended)" in "Inventory" settings menu

  @location
  Scenario: Location & Warehouse configuration
    Given I set "Multi Locations" to "Manage several locations per warehouse" in "Inventory" settings menu
    Given I set "Routes" to "Advanced routing of products using rules" in "Inventory" settings menu
    Given I set "Dropshipping" to "Allow suppliers to deliver directly to your customers" in "Inventory" settings menu

  @wh_config
  Scenario: Configure main warehouse
    Given I find a "stock.warehouse" with oid: stock.warehouse0
    And having:
      | key             | value         |
      | reception_steps | three_steps   |
      | delivery_steps  | ship_only     |

  @transit_location
  Scenario: Configure dedicated transit location for supplier in China
    Given I need an "stock.location" with oid: scenario.location_transit_cn
    And having:
      | key             | value                                     |
      | name            | Swisslux AG: Transit from China           |
      | usage           | transit                                   |
      | location_id     | by oid: stock.stock_location_locations    |
      | active          | True                                      |
      | return_location | False                                     |
      | scrap_location  | False                                     |

  @picking_type
  Scenario: Configure dedicated picking type to receive goods from transit location
    Given I need an "stock.picking.type" with oid: scenario.picking_type_receive_cn
    And having:
      | key                         | value                                 |
      | name                        | Receive from China                    |
      | default_location_dest_id    | by oid: scenario.location_transit_cn  |
      | code                        | incoming                              |
      | sequence_id                 | by name: Swisslux AG Sequence in      |
      | warehouse_id                | by oid: stock.warehouse0              |
      | return_picking_type_id      | by oid: stock.picking_type_out        |

   @push_rules
   Scenario: Add a global push rule to receive goods from transit location
     Given I need an "stock.location.path" with oid: scenario.location_path_transit_to_slx
     And having:
      | key                 | value                                 |
      | name                | Receive from China                    |
      | active              | True                                  |
      | location_from_id    | by oid: scenario.location_transit_cn  |
      | location_dest_id    | by oid: stock.stock_location_company  |
      | auto                | manual                                |
      | picking_type_id     | by oid: stock.picking_type_in         |
      | delay               | 60                                    |

  @reception_text_company
  Scenario: set default company reception text
    Given I execute the SQL commands
    """;
    update res_company set receipt_checklist = '
    Logistik:
    _____ Anleitung Deutsch
    _____ Anleitung Franz.
    _____ Anleitung Ital.
    _____ Verpackung
    _____ Lieferumfang
    _____ Funktionstest

    Technik:
    Produktenews: JA / NEIN
    Visum: ____________________________';
    """

  @reception_text_product
  Scenario: set default product reception text
    Given I execute the SQL commands
    """;
    update product_template set receipt_checklist = '
    Technik (DRINGEND):
    Lieferumfang Logistik:

    Label aussen

    Labal innen

    Anleitungen D+F

    Merkblatt V5.0';
    """