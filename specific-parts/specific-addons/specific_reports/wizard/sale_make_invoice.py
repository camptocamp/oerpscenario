import time

from openerp import api, fields, models, _
import openerp.addons.decimal_precision as dp
from openerp.exceptions import UserError

class SaleAdvancePaymentInv(models.TransientModel):
    _inherit = "sale.advance.payment.inv"

    @api.multi
    def _create_invoice(self, order, so_line, amount):
        """ Add client_order_descr while creating invoice
        """
        invoice = super(SaleAdvancePaymentInv, self)._create_invoice(order, so_line, amount)

        # invoice['client_order_ref'] = order.client_order_ref
        invoice['client_order_descr'] = order.client_order_descr
        return invoice