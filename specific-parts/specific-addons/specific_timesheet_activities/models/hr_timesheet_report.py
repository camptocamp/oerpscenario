# -*- coding: utf-8 -*-
# @2016 Cyril Gaudin (Camptocamp)
# License AGPL-3.0 or later (http://www.gnu.org/licenses/agpl.html).

from openerp import fields, models


class HrTimesheetReport(models.Model):
    """ Add fields account_department_id and activity_id
    in the hr_timesheet_report view.
    """
    _inherit = "hr.timesheet.report"

    account_department_id = fields.Many2one('hr.department',
                                            'Account department',
                                            readonly=True)

    activity_id = fields.Many2one('hr.timesheet.sheet.activity',
                                  string='Activity',
                                  readonly=True)

    def _select(self):
        return super(HrTimesheetReport, self)._select() + """,
            aal.account_department_id,
            aal.activity_id"""

    def _group_by(self):
        return super(HrTimesheetReport, self)._group_by() + """,
            aal.account_department_id,
            aal.activity_id"""
