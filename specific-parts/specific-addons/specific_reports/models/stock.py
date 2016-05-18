# -*- coding: utf-8 -*-
# © 2016 Yannick Vaucher (Camptocamp)
# License AGPL-3.0 or later (http://www.gnu.org/licenses/agpl.html).
from openerp import api, fields, models


class StockPicking(models.Model):
    _inherit = 'stock.picking'

    @api.multi
    def get_employee_from_user(self, user_id=None):
        import pdb; pdb.set_trace()
        so = self.env['sale.order'].search([('name','=', self.origin)])
        if not user_id:
            hr_employee = so.get_employee_from_user(self.env.user)
        else:
            hr_employee = so.get_employee_from_user(so.user_id)
        return hr_employee
