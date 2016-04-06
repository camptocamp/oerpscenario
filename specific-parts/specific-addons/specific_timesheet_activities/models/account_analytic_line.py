# -*- coding: utf-8 -*-
# © 2016, Denis Leemann (Camptocamp), Cyril Gaudin (Camptocamp)
# License AGPL-3.0 or later (http://www.gnu.org/licenses/agpl.html).

from openerp import api, fields, models


class AccountAnalyticLine(models.Model):
    _inherit = 'account.analytic.line'

    activity_id = fields.Many2one('hr.timesheet.sheet.activity',
                                  string='Activity',
                                  required=True)
    user_department_id = fields.Many2one('hr.department',
                                         compute='_get_user_department_id')

    @api.depends('user_id')
    def _get_user_department_id(self):
        """ Set the user_department_id value as department_id of the
        account analytic line's employee.
        """
        employee_model = self.env['hr.employee']
        for record in self:
            employee = employee_model.search(
                [('user_id', '=', record.user_id.id)],
                limit=1
            )
            if employee and employee.department_id:
                record.user_department_id = employee.department_id

    @api.onchange('activity_id')
    def change_activity_id(self):
        """ Filled the line's name with activty name.
        """
        if self.activity_id and not self.name:
            self.name = self.activity_id.name
