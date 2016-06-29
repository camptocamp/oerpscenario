# -*- coding: utf-8 -*-
# © 2015 Yannick Vaucher (Camptocamp)
# License AGPL-3.0 or later (http://www.gnu.org/licenses/agpl.html).
from openerp import models, fields, api, _


class CRMLead(models.Model):
    _inherit = 'crm.lead'

    building_project_id = fields.Many2one(
        comodel_name='building.project',
        string="Building Project",
    )

    # field to set default project_id on new quotations
    project_id = fields.Many2one(
        comodel_name='account.analytic.account',
        related='building_project_id.analytic_account_id',
        string="Building Project's analytic account",
    )

    meeting_ids = fields.One2many(
        comodel_name='calendar.event',
        inverse_name='opportunity_id'
    )

    # XXX on create and write, if building_project_id is defined, add the
    # partner of the opportunity to the building_project
    @api.model
    def create(self, vals):
        rec = super(CRMLead, self).create(vals)
        if rec.building_project_id and rec.partner_id:
            rec.building_project_id.add_role(rec.partner_id)
        return rec

    @api.multi
    def write(self, vals):
        bp_id = vals.get('building_project_id')
        for record in self:
            if bp_id is not None and bp_id != record.building_project_id.id:
                record.meeting_ids.write({'building_project_id': bp_id})

        res = super(CRMLead, self).write(vals)

        for record in self:
            if record.building_project_id and record.partner_id:
                record.building_project_id.add_role(record.partner_id)
        return res

    @api.multi
    def quotation_new_wholesaler(self):
        wiz_ctx = self.env.context.copy()
        wiz_ctx.update({
            'active_model': self._name,
            'active_ids': self.ids,
            'active_id': self.id,
        })

        wiz_model = self.env['create.opportunity.quotation']
        wiz = wiz_model.with_context(wiz_ctx).create({})
        return {
            'name': _('New Quotation'),
            'type': 'ir.actions.act_window',
            'view_type': 'form',
            'view_mode': 'form',
            'res_model': 'create.opportunity.quotation',
            'target': 'new',
            'res_id': wiz.id,
            'context': self.env.context
        }

    @api.multi
    def action_schedule_meeting(self):
        result = super(CRMLead, self).action_schedule_meeting()

        result['display_name'] = _('Activities')

        # Put tree by default
        views = result['views']
        result['views'] = \
            filter(lambda v: v[1] == 'tree', views) \
            + filter(lambda v: v[1] != 'tree', views)

        return result
