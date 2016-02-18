# -*- coding: utf-8 -*-
# © 2016 Yannick Vaucher (Camptocamp)
# License AGPL-3.0 or later (http://www.gnu.org/licenses/agpl.html).
from openerp import api, fields, models
from openerp.osv import expression


class ProductTemplate(models.Model):
    _inherit = 'product.template'

    e_nr = fields.Char("E-Nr")


class ProductProduct(models.Model):
    _inherit = 'product.product'

    @api.model
    def name_search(self, name, args=None, operator='ilike', limit=100):
        """ Allow to search by E-Nr """
        args = args or []
        domain = []
        result = None
        result = super(ProductProduct, self).name_search(
            name, args=args, operator=operator, limit=limit)
        limit = limit - len(result)
        if limit > 1:
            domain = [('e_nr', '=ilike', name + '%')]
            if operator in expression.NEGATIVE_TERM_OPERATORS:
                domain = ['&'] + domain
            partners = self.search(domain + args, limit=limit)
            result.extend(partners.name_get())
        return result
