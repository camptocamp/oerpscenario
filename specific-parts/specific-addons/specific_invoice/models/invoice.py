# -*- coding: utf-8 -*-
# © 2016 Yannick Vaucher (Camptocamp)
# License AGPL-3.0 or later (http://www.gnu.org/licenses/agpl.html).
from openerp import api, models


class AccountInvoice(models.Model):
    _inherit = 'account.invoice'

    @api.onchange('partner_id.country_id')
    def onchange_partner_id_set_bank(self):
        """ Overwrite default partner bank if invoice bank rules are set """
        super(AccountInvoice, self).onchange_partner_id_set_bank()
        if (self.partner_id and
                self.type in ('out_invoice', 'out_refund')):
            bank_ids = self.company_id.partner_id.bank_ids
            if not bank_ids:
                return
            rule_model = self.env['invoice.bank.rule']
            domain = [('country_id', '=', self.partner_id.country_id.id)]
            matching_rule = rule_model.search(domain, limit=1)
            if not matching_rule:
                domain = [('country_id', '=', False)]
                matching_rule = rule_model.search(domain, limit=1)
            if matching_rule:
                self.partner_bank_id = matching_rule.partner_bank_id
