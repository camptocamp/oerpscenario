# -*- coding: utf-8 -*-
# © 2016, Denis Leemann (Camptocamp), Cyril Gaudin (Camptocamp)
# License AGPL-3.0 or later (http://www.gnu.org/licenses/agpl.html).

from openerp import models, fields


class HrTimesheetSheetActivity(models.Model):
    _name = 'hr.timesheet.sheet.activity'
    _order = 'name'

    name = fields.Char(required=True)
    department_ids = fields.Many2many('hr.department', string='Departments')
    active = fields.Boolean(default=True)
