# -*- coding: utf-8 -*-
# © 2016 Camptocamp SA
# License AGPL-3.0 or later (http://www.gnu.org/licenses/agpl.html).

from openerp.tests.common import TransactionCase


class TestSale(TransactionCase):

    def test_onchange_partner(self):
        partner_model = self.env['res.partner']
        invoicing_partner = partner_model.create({
            'name': 'Unittest invoicing partner'
        })

        partner = partner_model.create({
            'name': 'Unittest partner',
            'partner_invoicing_id': invoicing_partner.id
        })

        sale = self.env['sale.order'].create({
            'partner_id': partner.id
        })

        sale.onchange_partner_id()
        self.assertEqual(invoicing_partner, sale.partner_invoice_id)
        self.assertEqual(partner, sale.partner_shipping_id)

        shipping_partner = partner_model.create({
            'name': 'Unittest shipping partner'
        })

        partner.partner_shipping_id = shipping_partner
        sale.onchange_partner_id()
        self.assertEqual(invoicing_partner, sale.partner_invoice_id)
        self.assertEqual(shipping_partner, sale.partner_shipping_id)
