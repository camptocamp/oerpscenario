# -*- coding: utf-8 -*-
# © 2016 Camptocamp SA
# License AGPL-3.0 or later (http://www.gnu.org/licenses/agpl.html).

from datetime import datetime, timedelta
from openerp.tests.common import TransactionCase
from openerp.tools import DEFAULT_SERVER_DATETIME_FORMAT


class TestStockMove(TransactionCase):
    def setUp(self):
        super(TestStockMove, self).setUp()

        self.move_model = self.env['stock.move']
        self.location_path_model = self.env['stock.location.path']
        self.picking_model = self.env['stock.picking']

        self.p1 = self.env['product.product'].create({
            'name': 'Unittest product'
        })

        self.picking_type_in = self.browse_ref('stock.picking_type_in')

        self.loc_stock = self.browse_ref('stock.stock_location_stock')
        self.loc_suppliers = self.browse_ref('stock.stock_location_suppliers')

        # Create transit location like scenario
        self.loc_transit = self.env['stock.location'].create({
            'name': 'Unittest transit location',
            'usage': 'transit',
            'location_id': self.ref('stock.stock_location_locations')
        })
        self.loc_transit._parent_store_compute()
        self.env['ir.model.data'].create({
            'model': 'stock.location',
            'module': 'scenario',
            'name': 'location_transit_cn',
            'res_id': self.loc_transit.id,
        })

        self.location_path_model.search([]).unlink()
        self.location_path_model.create({
            'name': 'Unittest receive from China',
            'active': True,
            'location_from_id': self.loc_transit.id,
            'location_dest_id': self.loc_stock.id,
            'picking_type_id': self.picking_type_in.id,
        })

    def delta_days(self, str_value, delta):
        value = datetime.strptime(str_value, DEFAULT_SERVER_DATETIME_FORMAT)
        return (
            value + timedelta(days=delta)
        ).strftime(DEFAULT_SERVER_DATETIME_FORMAT)

    def test_scheduled_date(self):
        #  Création d'un picking Suppliers -> Transit pour 10 p1
        picking = self.picking_model.create({
            'picking_type_id': self.picking_type_in.id,
            'location_id': self.loc_suppliers.id,
            'location_dest_id': self.loc_transit.id,
            'move_lines': [
                (0, 0, {
                    'name': 'Test move',
                    'product_id': self.p1.id,
                    'product_uom': self.ref('product.product_uom_unit'),
                    'product_uom_qty': 10,
                    'location_id': self.loc_suppliers.id,
                    'location_dest_id': self.loc_transit.id
                })
            ]
        })

        self.assertEqual(1, self.move_model.search_count([
            ('product_id', '=', self.p1.id)
        ]))

        # Avec la push rule, la confirmation du move va en créer un 2e
        # Transit -> stock
        picking.action_assign()
        self.assertEqual(2, self.move_model.search_count([
            ('product_id', '=', self.p1.id)
        ]))

        next_move = self.move_model.search([
            ('product_id', '=', self.p1.id),
            ('picking_id', '!=', picking.id)
        ])

        self.assertEqual(self.loc_transit, next_move.location_id)
        self.assertEqual(self.loc_stock, next_move.location_dest_id)
        self.assertEqual('waiting', next_move.state)

        next_picking = next_move.picking_id
        self.assertEqual('waiting', next_picking.state)

        # Split first move
        picking.pack_operation_ids.qty_done = 4
        picking.do_split()

        backorder = self.picking_model.search([
            ('backorder_id', '=', picking.id)
        ])
        self.assertEqual(1, len(backorder))

        self.assertEqual(6, picking.move_lines.product_qty)
        self.assertEqual(4, backorder.move_lines.product_qty)

        # So waiting picking has 2 moves
        self.assertEqual(2, len(next_picking.move_lines))

        # Add schedule date on splitted pickings
        picking.min_date = self.delta_days(picking.min_date, 30)
        backorder.min_date = self.delta_days(backorder.min_date, 60)

        next_picking.invalidate_cache()
        self.assertItemsEqual(
            [(6, picking.min_date), (4, backorder.min_date)],
            [(m.product_qty, m.date_expected) for m in next_picking.move_lines]
        )

        # Validate picking and check that next_picking date does not change.
        picking.action_done()
        backorder.action_done()
        self.assertItemsEqual(
            [(6, picking.min_date), (4, backorder.min_date)],
            [(m.product_qty, m.date_expected) for m in next_picking.move_lines]
        )
