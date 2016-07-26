# -*- coding: utf-8 -*-
# © 2015 Swisslux
# © 2016 Yannick Vaucher (Camptocamp)
# License AGPL-3.0 or later (http://www.gnu.org/licenses/agpl.html).
from openerp import api, models


class SaleOrder(models.Model):
    _inherit = 'sale.order'

    @api.multi
    @api.onchange('partner_id')
    def onchange_partner_id(self):
        super(SaleOrder, self).onchange_partner_id()
        values = {}
        partner = None
        if self.partner_id.company_id:
            partner = self.partner_id
        elif self.partner_id.parent_id:
            partner = self.partner_id.parent_id
        if partner:
            if partner.partner_invoicing_id:
                values['partner_invoice_id'] = partner.partner_invoicing_id
            if partner.partner_shipping_id:
                values['partner_shipping_id'] = partner.partner_shipping_id
        if values:
            self.update(values)
