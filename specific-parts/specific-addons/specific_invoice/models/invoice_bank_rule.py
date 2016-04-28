# -*- coding: utf-8 -*-
# © 2016 Yannick Vaucher (Camptocamp)
# License AGPL-3.0 or later (http://www.gnu.org/licenses/agpl.html).
from openerp import fields, models


class InvoicerBankRule(models.Model):
    """ Rule to automatically select a bank on invoices """
    _name = 'invoice.bank.rule'

    _order = 'partner_bank_id'

    name = fields.Char()
    partner_bank_id = fields.Many2one(
        'res.partner.bank',
        required=True,
        string="Company Bank account",
        domain="[('partner_id', '=', company_partner_id)]",
    )
    country_id = fields.Many2one(
        'res.country',
        string="Country",
        help="If not defined will be applied for all non listed countries"
    )
    company_id = fields.Many2one(
        'res.company',
        string="Company",
        required=True,
        default=lambda rec: rec.env.user.company_id
    )
    company_partner_id = fields.Many2one(
        'res.partner',
        related='company_id.partner_id',
    )
