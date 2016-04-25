# -*- coding: utf-8 -*-
# © 2016 Cyril Gaudin (Camptocamp)
# License AGPL-3.0 or later (http://www.gnu.org/licenses/agpl.html).

from openerp import fields, models


class ProductColorCode(models.Model):
    _name = 'product.color.code'

    name = fields.Char(string="Color Name", required=True)
    code = fields.Char("NCS/RAL Code", required=True)
    feller_name = fields.Char("Color Name Feller", required=True)
