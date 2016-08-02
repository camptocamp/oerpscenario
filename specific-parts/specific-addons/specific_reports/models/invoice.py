# -*- coding: utf-8 -*-
# © 2016 Yannick Vaucher (Camptocamp)
# License AGPL-3.0 or later (http://www.gnu.org/licenses/agpl.html).
from openerp import api, fields, models

import openerp.addons.decimal_precision as dp


class AccountInvoice(models.Model):
    _inherit = 'account.invoice'

    client_order_ref = fields.Char(
        "Client order reference",
        help="Reference for the client"
    )

    client_order_contact_type = fields.Selection(
        [('email', 'Per E-Mail'),
         ('in_person', 'Persönlich'),
         ('post', 'Per Post'),
         ('tel', 'Per Telefon'),
         ('fax', 'Per Fax'),
         ('stand', 'Messestand')],
        "Client order contact type",
        help="Description of how the order was made"
    )
    client_order_date = fields.Date(
        "Client order date",
        help="When the order was made"
    )
    delivery_term = fields.Date(
        "Term of delivery",
    )

    @api.multi
    def get_employee_from_user(self, user_id):
        self.ensure_one()
        resource = self.env['resource.resource'].search(
            [('user_id', '=', user_id.id)])
        hr_employee = self.env['hr.employee'].search(
            [('resource_id', '=', resource.id)])

        return hr_employee


class InvoiceOrderLine(models.Model):
    _inherit = 'account.invoice.line'

    price_unit_discount = fields.Float(
        compute='_compute_price_discount', digits=dp.get_precision('Product Price'), string='Subtotal', readonly=True
    )
    project_discount = fields.Float(string='Object Discount (%)')
    public_discount = fields.Float(string='Discount (%)')

    @api.multi
    def _compute_price_discount(self):
        for rec in self:
            if rec.discount:
                if rec.discount == 100:
                    discount = 0.0
                else:
                    discount = 1 - rec.discount / 100.0
                rec.price_unit_discount = rec.price_unit * discount
            else:
                rec.price_unit_discount = rec.price_unit
        return self
