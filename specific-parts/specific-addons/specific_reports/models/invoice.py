# -*- coding: utf-8 -*-
# © 2016 Yannick Vaucher (Camptocamp)
# License AGPL-3.0 or later (http://www.gnu.org/licenses/agpl.html).
from openerp import api, fields, models


# WIP

class SaleOrder(models.Model):
    _inherit = 'account.invoice'

    client_order_ref = fields.Char(
        "Client order reference",
        help="Reference for the client"
    )

    client_order_descr = fields.Char(
        "Client order description",
        help="Description of how the order was made"
    )
    delivery_term = fields.Date(
        "Term of delivery",
    )


class SaleOrderLine(models.Model):
    _inherit = 'sale.order.line'

    price_unit_discount = fields.Monetary(
        compute='_compute_price_discount', string='Subtotal',
        readonly=True
    )

    @api.multi
    @api.depends('price_unit', 'discount')
    def _compute_price_discount(self):
        self.ensure_one()
        if self.discount:
            if self.discount == 100:
                discount = 0.0
            else:
                discount = 1 - self.discount / 100.0
            self.price_unit_discount = self.price_unit * discount
        else:
            self.price_unit_discount = self.price_unit