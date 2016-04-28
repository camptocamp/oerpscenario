# -*- coding: utf-8 -*-
# © 2016 Cyril Gaudin (Camptocamp)
# License AGPL-3.0 or later (http://www.gnu.org/licenses/agpl.html).

from openerp import fields, models


class ProductSupplierInfo(models.Model):
    _inherit = 'product.supplierinfo'

    lastproduct_code = fields.Char('Last Product Code')
