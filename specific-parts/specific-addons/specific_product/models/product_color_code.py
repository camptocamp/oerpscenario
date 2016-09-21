# -*- coding: utf-8 -*-
# © 2016 Cyril Gaudin (Camptocamp)
# License AGPL-3.0 or later (http://www.gnu.org/licenses/agpl.html).

from openerp import api, fields, models


class ProductColorCode(models.Model):
    _name = 'product.color.code'

    name = fields.Char(string="Color Name", required=True)
    code = fields.Char("NCS/RAL Code", required=True)
    feller_name = fields.Char("Color Name Feller")

    @api.multi
    def name_get(self):
        return [
            (record.id, "[%s] %s" % (record.code, record.name))
            for record in self
        ]

    @api.model
    def name_search(self, name, args=None, operator='ilike', limit=100):
        args = args or []
        domain = []
        if name:
            domain = [
                '|', ('name', operator, name), ('code', operator, name)
            ]
        colors = self.search(domain + args, limit=limit)
        return colors.name_get()
