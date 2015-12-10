# -*- coding: utf-8 -*-
# © 2015 Yannick Vaucher (Camptocamp)
# License AGPL-3.0 or later (http://www.gnu.org/licenses/agpl.html).
from openerp import models, fields


class CalendarEvent(models.Model):
    _inherit = 'calendar.event'

    building_project_id = fields.Many2one(
        comodel_name='building.project',
        related='opportunity_id.building_project_id',
    )
