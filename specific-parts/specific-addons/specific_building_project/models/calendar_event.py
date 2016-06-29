# -*- coding: utf-8 -*-
# © 2015 Yannick Vaucher (Camptocamp)
# License AGPL-3.0 or later (http://www.gnu.org/licenses/agpl.html).
from openerp import api, models, fields


class CalendarEvent(models.Model):
    _inherit = 'calendar.event'

    building_project_id = fields.Many2one(
        comodel_name='building.project',
    )

    event_type = fields.Selection(
        selection=[
            ('meeting', 'Meeting'),
            ('phonecall', 'Phonecall'),
        ],
        string='Type',
        default='meeting'
    )

    @api.model
    def create(self, vals):
        opportunity_id = vals.get('opportunity_id')
        if not opportunity_id:
            opportunity_id = self.env.context.get('default_opportunity_id')

        if opportunity_id:
            lead = self.env['crm.lead'].browse(opportunity_id)
            if lead and lead.building_project_id:
                vals['building_project_id'] = lead.building_project_id.id

        return super(CalendarEvent, self).create(vals)

    @api.multi
    def write(self, vals):
        try:
            opportunity_id = vals['opportunity_id']
        except KeyError:
            pass
        else:
            if opportunity_id:
                lead = self.env['crm.lead'].browse(opportunity_id)
                vals['building_project_id'] = lead.building_project_id.id
            else:
                vals['building_project_id'] = False
        return super(CalendarEvent, self).write(vals)
