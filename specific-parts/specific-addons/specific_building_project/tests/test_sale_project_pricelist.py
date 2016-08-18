# -*- coding: utf-8 -*-
# © 2016 Yannick Vaucher (Camptocamp)
# License AGPL-3.0 or later (http://www.gnu.org/licenses/agpl.html).
from openerp.tests import common


class TestSalePricelist(common.TransactionCase):

    def test_standard_pricelist(self):
        self.sale.button_update_unit_prices()
        self.assertAlmostEqual(self.sale.order_line.price_unit, self.listprice)

    def test_sale_discount_pricelist(self):
        self.sale.pricelist_id = self.pricelist40
        self.sale.button_update_unit_prices()
        self.assertAlmostEqual(
            self.sale.order_line.price_subtotal,
            self.listprice * 0.6,
        )

    def test_project_without_discount(self):
        self.sale.project_id = self.project.analytic_account_id
        self.sale.button_update_unit_prices()
        self.assertAlmostEqual(
            self.sale.order_line.price_subtotal,
            self.listprice,
        )

    def test_project_discount_pricelist(self):
        self.sale.project_pricelist_id = self.pricelist50
        self.sale.button_update_unit_prices()
        self.assertAlmostEqual(
            self.sale.order_line.price_subtotal,
            self.listprice * 0.5,
        )

    def test_both_discount_pricelist(self):
        self.sale.project_pricelist_id = self.pricelist50
        self.sale.pricelist_id = self.pricelist40
        self.sale.button_update_unit_prices()
        self.assertAlmostEqual(
            self.sale.order_line.price_subtotal,
            self.listprice * 0.5 * 0.6,
        )

    def setUp(self):
        super(TestSalePricelist, self).setUp()

        product = self.env['product.product'].create({
            'name': 'Unittest product',
            'list_price': 23500,
        })
        self.listprice = product.list_price

        self.partner = self.env['res.partner'].create({
            'name': 'Unittest partner'
        })

        self.sale = self.env['sale.order'].create({
            'partner_id': self.partner.id,
            'order_line': [(0, 0, {
                'product_id': product.id,
                'product_uom': product.uom_id.id,
                'name': '/',
            })]
        })

        self.pricelist40 = self.env['product.pricelist'].create({
            'name': '40%',
            'item_ids': [(0, 0, {
                'compute_price': 'percentage',
                'percent_price': '40.0',
            })]
        })
        self.pricelist50 = self.env['product.pricelist'].create({
            'name': '50%',
            'item_ids': [(0, 0, {
                'compute_price': 'percentage',
                'percent_price': '50.0',
            })]
        })

        self.project = self.env['building.project'].create({
            'name': 'Building Project',
        })
        self.project_pl = self.env['building.project.pricelist'].create({
            'building_project_id': self.project.id,
            'partner_id': self.partner.id,
        })
