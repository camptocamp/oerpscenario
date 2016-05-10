# -*- coding: utf-8 -*-
# © 2015 Swisslux
# © 2016 Denis Leemann (Camptocamp SA)
# License AGPL-3.0 or later (http://www.gnu.org/licenses/agpl.html).

from openerp import api, models


class SaleAdvancePaymentInv(models.TransientModel):
    _inherit = "sale.advance.payment.inv"


    def action_invoice_create(self):
        import pdb; pdb.set_trace()

    @api.multi
    def _create_invoice(self, order, so_line, amount):
        import pdb; pdb.set_trace()
        """ Add client_order_descr while creating invoice
        """
        invoice = super(SaleAdvancePaymentInv, self)._create_invoice(
            order,
            so_line,
            amount)

        # invoice['client_order_ref'] = order.client_order_ref
        invoice['client_order_descr'] = order.client_order_descr
        return invoice

    @api.multi
    def create_invoices(self):
        # import pdb; pdb.set_trace()
        return super(SaleAdvancePaymentInv, self).create_invoices()
