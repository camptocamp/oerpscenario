# -*- coding: utf-8 -*-
# © 2016 Cyril Gaudin (Camptocamp)
# License AGPL-3.0 or later (http://www.gnu.org/licenses/agpl.html).

from openerp import fields, models


class ProductHarmsysCode(models.Model):
    _name = 'product.harmsys.code'
    name = fields.Char(required=True)
