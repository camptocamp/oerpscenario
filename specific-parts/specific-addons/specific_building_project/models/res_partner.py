# -*- coding: utf-8 -*-
# © 2015 Yannick Vaucher (Camptocamp)
# License AGPL-3.0 or later (http://www.gnu.org/licenses/agpl.html).
from openerp import models, fields


class ResPartner(models.Model):
    _inherit = 'res.partner'

    architect = fields.Boolean()
    electrician = fields.Boolean()
    engineer = fields.Boolean()
    wholesaler = fields.Boolean()
