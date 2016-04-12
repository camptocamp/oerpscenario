# -*- coding: utf8 -*-
from openerp.tests import TransactionCase
from openerp.tests.common import at_install, post_install


class TestProduct(TransactionCase):

    def setUp(self):
        super(TestProduct, self).setUp()
        self.product_model = self.env['product.product']

        self.loc_stock = self.browse_ref('stock.stock_location_stock')
        self.loc_suppliers = self.browse_ref('stock.stock_location_suppliers')
        self.loc_transit = self.browse_ref('scenario.location_transit_cn')

    def test_name_search(self):

        self.product_model.create({
            'name': 'Unittest P1',
            'e_nr': 'fake_enr1_unittest',
            'default_code': 'default_code_1'})
        self.product_model.create({
            'name': 'P2',
            'e_nr': 'fake_enr2',
            'default_code': 'default_code_2'})
        self.assertEqual(1, len(self.product_model.name_search('unittest')))
        self.assertEqual(2, len(self.product_model.name_search('fake')))
        self.assertEqual(1,
                         len(self.product_model.name_search('default_code_1')))
        self.assertEqual(2,
                         len(self.product_model.name_search('default_code')))
        # Only one result should show up by record
        self.assertEqual(1, len(self.product_model.name_search('unittest')))
        # Test with limit=None to highlight name_search little bug
        self.product_model.name_search('unittest_enr', limit=None)

    @at_install(False)
    @post_install(True)
    def test_transit_qty(self):
        def check_quantities(product, available, forecast, transit):
            product.refresh()
            self.assertEqual(available, product.qty_available)
            self.assertEqual(forecast, product.virtual_available)
            self.assertEqual(transit, product.transit_qty)

            # template should return same value without variant
            self.assertEqual(available, product.product_tmpl_id.qty_available)
            self.assertEqual(forecast,
                             product.product_tmpl_id.virtual_available)
            self.assertEqual(transit, product.product_tmpl_id.transit_qty)

        p1 = self.product_model.create({'name': 'Unittest P1'})
        check_quantities(p1, 0, 0, 0)

        # Update quantity on hand: 5 p1
        inventory = self.env['stock.inventory'].create({
            'name': 'Test inventory',
            'location_id': self.loc_stock.id,
            'filter': 'partial'
        })
        inventory.prepare_inventory()

        self.env['stock.inventory.line'].create({
            'inventory_id': inventory.id,
            'product_id': p1.id,
            'location_id': self.loc_stock.id,
            'product_qty': 5
        })
        inventory.action_done()
        check_quantities(p1, 5, 5, 0)

        # Move in but on main warehouse
        self.env['stock.move'].create({
            'name': 'Test move in',
            'state': 'confirmed',
            'product_id': p1.id,
            'product_uom_qty': 3.0,
            'product_uom': p1.uom_id.id,
            'location_id': self.loc_suppliers.id,
            'location_dest_id': self.loc_stock.id,
        })
        check_quantities(p1, 5, 8, 0)

        # Transit move (but default state='draft')
        transit_move = self.env['stock.move'].create({
            'name': 'Test transit move',
            'product_id': p1.id,
            'product_uom_qty': 10.0,
            'product_uom': p1.uom_id.id,
            'location_id': self.loc_suppliers.id,
            'location_dest_id': self.loc_transit.id,
        })
        check_quantities(p1, 5, 8, 0)

        transit_move.state = 'confirmed'
        p1.refresh()
        check_quantities(p1, 5, 8, 10)

    def test_action_transit_move(self):
        p1 = self.product_model.create({'name': 'Unittest P1'})

        transit_view = p1.action_transit_move()
        self.assertEqual('Transit moves', transit_view['name'])
        self.assertEqual('ir.actions.act_window', transit_view['type'])
        self.assertEqual('list', transit_view['view_type'])
        self.assertEqual('list', transit_view['view_mode'])
        self.assertEqual('stock.move', transit_view['res_model'])
        self.assertEqual('current', transit_view['target'])
        self.assertEqual(self.ref('stock.view_move_tree'),
                         transit_view['view_id'])
        self.assertEqual(p1.id,
                         transit_view['context']['search_default_product_id'])

        self.assertEqual(self.loc_transit.complete_name,
                         transit_view['context']['search_default_name'])

        # Check that product_template action return same result
        self.assertEqual(transit_view,
                         p1.product_tmpl_id.action_transit_move())
