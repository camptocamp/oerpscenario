# -*- coding: utf-8 -*-
# © 2016 Yannick Vaucher (Camptocamp)
# License AGPL-3.0 or later (http://www.gnu.org/licenses/agpl.html).
from openerp import api, fields, models


class SaleOrder(models.Model):
    _inherit = 'sale.order'

    client_order_descr = fields.Char(
        "Client order description",
        help="Description of how the order was made"
    )
    delivery_term = fields.Date(
        "Term of delivery",
    )

    @api.multi
    def action_invoice_create(self):
        invoice = super(SaleOrder, self).action_invoice_create(grouped=False,
                                                               final=False)
        inv_obj = self.env['account.invoice'].browse(invoice)
        inv_obj.client_order_descr = self.client_order_descr
        return inv_obj

    @api.multi
    def get_employee_from_user(self, user_id):
        self.ensure_one()
        resource = self.env['resource.resource'].search([('user_id', '=', user_id.id)])
        hr_employee = self.env['hr.employee'].search([('resource_id', '=', resource.id)])

        return hr_employee

class SaleOrderLine(models.Model):
    _inherit = 'sale.order.line'

    price_unit_discount = fields.Monetary(
        compute='_compute_price_discount', string='Subtotal',
        readonly=True
    )

    @api.one
    @api.depends('price_unit', 'discount')
    def _compute_price_discount(self):
        if self.discount:
            if self.discount == 100:
                discount = 0.0
            else:
                discount = 1 - self.discount / 100.0
            self.price_unit_discount = self.price_unit * discount
        else:
            self.price_unit_discount = self.price_unit
