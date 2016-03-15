# -*- coding: utf-8 -*-
# © 2015 Laurent Meuwly (Camptocamp)
# © 2016 Yannick Vaucher (Camptocamp)
# License AGPL-3.0 or later (http://www.gnu.org/licenses/agpl.html).
from openerp import fields, models


class SaleOrder(models.Model):
    _inherit = 'sale.order'

    customer_contact_id = fields.Many2one('res.partner', string='Your contact')
