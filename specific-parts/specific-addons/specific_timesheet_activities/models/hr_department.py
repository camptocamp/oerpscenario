# -*- coding: utf-8 -*-
# © 2016, Denis Leemann (Camptocamp), Cyril Gaudin (Camptocamp)
# License AGPL-3.0 or later (http://www.gnu.org/licenses/agpl.html).

from openerp import fields, models


class HrDepartment(models.Model):
    _inherit = 'hr.department'

    timesheet_activity_ids = fields.Many2many(
        'hr.timesheet.sheet.activity',
        string="Timesheet activities",
    )
