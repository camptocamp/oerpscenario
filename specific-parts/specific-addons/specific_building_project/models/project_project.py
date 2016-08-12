# -*- coding: utf-8 -*-
# © 2016 Cyril Gaudin (Camptocamp)
# License AGPL-3.0 or later (http://www.gnu.org/licenses/agpl.html).

from openerp import api, fields, models


class ProjectProject(models.Model):
    _inherit = 'project.project'

    department_id = fields.Many2one(
        comodel_name='hr.department',
        default=lambda self: self.user_id.department_id
    )

    @api.onchange('user_id')
    def onchange_user_id(self):
        """ Set department_id to user_id.department_id if empty
        """
        if not self.department_id:
            self.department_id = self.user_id.department_id
