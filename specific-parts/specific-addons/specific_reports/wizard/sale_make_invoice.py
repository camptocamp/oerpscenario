# -*- coding: utf-8 -*-
# © 2015 Swisslux
# © 2016 Denis Leemann (Camptocamp SA)
# License AGPL-3.0 or later (http://www.gnu.org/licenses/agpl.html).

from openerp import api, models


class SaleAdvancePaymentInv(models.TransientModel):
    _inherit = "sale.advance.payment.inv"

    @api.multi
    def _create_invoice(self, order, so_line, amount):
        """ Add client_order_contact_type while creating invoice
        """
        invoice = super(SaleAdvancePaymentInv, self)._create_invoice(
            order,
            so_line,
            amount)

        invoice['client_order_contact_type'] = order.client_order_contact_type
        invoice['client_order_date'] = order.client_order_date
        return invoice

    @api.multi
    def create_invoices(self):
        return super(SaleAdvancePaymentInv, self).create_invoices()
