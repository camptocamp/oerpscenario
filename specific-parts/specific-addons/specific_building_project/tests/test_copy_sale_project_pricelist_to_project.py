# -*- coding: utf-8 -*-
# © 2016 Yannick Vaucher (Camptocamp)
# License AGPL-3.0 or later (http://www.gnu.org/licenses/agpl.html).
from openerp.tests import common


class TestCopySalePricelistToProject(common.TransactionCase):

    def test_no_project_on_so(self):
        self.sale.project_id = False
        self.sale.project_pricelist_id = self.pricelist40
        self.assertEqual(len(self.project.customer_discount_ids), 0)

    def test_no_pricelist_on_so(self):
        self.sale.project_pricelist_id = False
        self.assertEqual(len(self.project.customer_discount_ids), 0)

    def test_new_pricelist_on_so(self):
        self.sale.project_pricelist_id = self.pricelist40
        self.assertEqual(len(self.project.customer_discount_ids), 1)
        self.assertEqual(self.project.customer_discount_ids.partner_id,
                         self.partner)
        self.assertEqual(self.project.customer_discount_ids.pricelist_id,
                         self.pricelist40)

    def test_new_pricelist_on_new_so(self):
        self.sale = self.env['sale.order'].create({
            'partner_id': self.partner.id,
            'order_line': [(0, 0, {
                'product_id': self.product.id,
                'product_uom': self.product.uom_id.id,
                'name': '/',
            })],
            'project_id': self.project.analytic_account_id.id,
            'project_pricelist_id': self.pricelist40.id

        })
        self.assertEqual(len(self.project.customer_discount_ids), 1)
        self.assertEqual(self.project.customer_discount_ids.partner_id,
                         self.partner)
        self.assertEqual(self.project.customer_discount_ids.pricelist_id,
                         self.pricelist40)

    def test_existing_pricelist(self):
        """ Setting a pricelist for a customer listed in project discount
        doesn't change the pricelist
        """
        self.project_pl = self.env['building.project.pricelist'].create({
            'building_project_id': self.project.id,
            'partner_id': self.partner.id,
            'pricelist_id': self.pricelist40.id,
        })
        self.sale.pricelist_id = self.pricelist50
        self.assertEqual(len(self.project.customer_discount_ids), 1)
        self.assertEqual(self.project.customer_discount_ids.partner_id,
                         self.partner)
        self.assertEqual(self.project.customer_discount_ids.pricelist_id,
                         self.pricelist40)

    def setUp(self):
        super(TestCopySalePricelistToProject, self).setUp()

        self.product = self.env.ref('product.product_product_57')
        self.listprice = self.product.list_price
        self.partner = self.env.ref('base.res_partner_12')
        self.project = self.env['building.project'].create({
            'name': 'Building Project',
        })
        self.sale = self.env['sale.order'].create({
            'partner_id': self.partner.id,
            'order_line': [(0, 0, {
                'product_id': self.product.id,
                'product_uom': self.product.uom_id.id,
                'name': '/',
            })],
            'project_id': self.project.analytic_account_id.id

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
