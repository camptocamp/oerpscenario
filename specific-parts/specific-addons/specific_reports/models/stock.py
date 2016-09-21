# -*- coding: utf-8 -*-
# © 2016 Yannick Vaucher (Camptocamp)
# License AGPL-3.0 or later (http://www.gnu.org/licenses/agpl.html).
from openerp import api, models


class StockPicking(models.Model):
    _inherit = 'stock.picking'

    @api.multi
    def get_employee_from_user(self, user_id=None):
        so = self.env['sale.order'].search([('name', '=', self.origin)])
        if not so and not user_id:
            user_id = self.partner_id.user_id
        elif not user_id:
            user_id = so.user_id

        if user_id:
            hr_employee = so.get_employee_from_user(user_id)
        else:
            hr_employee = False

        return hr_employee
