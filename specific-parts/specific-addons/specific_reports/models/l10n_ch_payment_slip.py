# -*- coding: utf-8 -*-
# © 2016 Yannick Vaucher (Camptocamp SA)
# License AGPL-3.0 or later (http://www.gnu.org/licenses/agpl.html).

from openerp import models, api, _
from reportlab.lib.units import inch


class PaymentSlip(models.Model):
    _inherit = 'l10n_ch.payment_slip'

    @api.multi
    def _draw_description_line(self, canvas, print_settings, initial_position,
                               font):
        """ Overwrite description line to redefine message by removing due date
        """
        x, y = initial_position
        # align with the address
        x += print_settings.bvr_add_horz * inch
        invoice = self.move_line_id.invoice_id
        message = _('Payment slip related to invoice %s')
        canvas.setFont(font.name, font.size)
        canvas.drawString(x, y, message % (invoice.number,))
