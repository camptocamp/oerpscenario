# -*- coding: utf-8 -*-
# © 2016 Yannick Vaucher (Camptocamp)
# License AGPL-3.0 or later (http://www.gnu.org/licenses/agpl.html).
from openerp.tests import common


class TestInvoiceBankRule(common.TransactionCase):

    def test_no_bank(self):
        self.env.user.company_id.partner_id.bank_ids = False
        self.invoice.partner_id = self.partner_us
        self.invoice.onchange_partner_id_set_bank()
        self.assertFalse(self.invoice.partner_bank_id)

    def test_no_bank_rule(self):
        self.invoice.partner_id = self.partner_us
        self.invoice.onchange_partner_id_set_bank()
        self.assertEqual(self.invoice.partner_bank_id,
                         self.env.user.company_id.partner_id.bank_ids[0])

    def test_invoice_us_customer(self):
        self.setup_rules()
        self.invoice.partner_id = self.partner_us
        self.invoice.onchange_partner_id_set_bank()
        self.assertEqual(self.invoice.partner_bank_id,
                         self.bank_us)

    def test_invoice_fr_customer(self):
        self.setup_rules()
        self.invoice.partner_id = self.partner_fr
        self.invoice.onchange_partner_id_set_bank()
        self.assertEqual(self.invoice.partner_bank_id,
                         self.bank_fr)

    def test_invoice_no_country_customer(self):
        self.setup_rules()
        self.invoice.partner_id = self.partner_other
        self.invoice.onchange_partner_id_set_bank()
        self.assertEqual(self.invoice.partner_bank_id,
                         self.bank_other)

    def setup_rules(self):
        self.env['invoice.bank.rule'].create(
            {'partner_bank_id': self.bank_fr.id,
             'country_id': self.ref('base.fr'),
             'company_id': self.cp.id}
        )
        self.env['invoice.bank.rule'].create(
            {'partner_bank_id': self.bank_us.id,
             'country_id': self.ref('base.us'),
             'company_id': self.cp.id}
        )
        self.env['invoice.bank.rule'].create(
            {'partner_bank_id': self.bank_other.id,
             'country_id': False,
             'company_id': self.cp.id}
        )

    def setUp(self):
        super(TestInvoiceBankRule, self).setUp()

        cp_partner = self.env.ref('base.main_partner')
        self.cp = self.env.ref('base.main_company')
        self.partner_us = self.env.ref('base.res_partner_10')
        self.partner_fr = self.env.ref('base.res_partner_12')
        self.partner_other = self.env.ref('base.res_partner_1')

        self.bank_us = self.env['res.partner.bank'].create(
            {'acc_number': 'test_inv_bank_1',
             'partner_id': cp_partner.id}
        )
        self.bank_fr = self.env['res.partner.bank'].create(
            {'acc_number': 'test_inv_bank_2',
             'partner_id': cp_partner.id}
        )
        self.bank_other = self.env['res.partner.bank'].create(
            {'acc_number': 'test_inv_bank_3',
             'partner_id': cp_partner.id}
        )

        self.invoice = self.env['account.invoice'].new(
            {'type': 'out_invoice',
             'company_id': self.cp}
        )
