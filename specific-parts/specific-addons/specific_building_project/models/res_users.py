# -*- coding: utf-8 -*-
# © 2016 Yannick Vaucher (Camptocamp)
# License AGPL-3.0 or later (http://www.gnu.org/licenses/agpl.html).
from openerp import api, fields, models


class ResUser(models.Model):
    """ Add department_id on users for record rules
    We consider a user has only one linked employee thus one department
    """
    _inherit = 'res.users'

    department_id = fields.Many2one(
        comodel_name='hr.department',
        compute='_get_department',
        store=True
    )

    @api.depends('employee_ids.department_id')
    def _get_department(self):
        for rec in self:
            emps = rec.employee_ids
            if emps:
                rec.department_id = emps[0].department_id
