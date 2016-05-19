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

    phonecall_count = fields.Integer(
        compute='_phonecall_count',
        string="# Phonecalls"
    )

    def _phonecall_count(self):
        type_phonecall = self.env.ref(
            'specific_building_project.event_type_phonecall'
        )
        for rec in self:
            rec.phonecall_count = self.env['calendar.event'].search_count(
                [('opportunity_id', '=', rec.id),
                 ('categ_ids', 'in', [type_phonecall.id])]
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
        res = super(CRMLead, self).write(vals)
        if self.building_project_id and self.partner_id:
            self.building_project_id.add_role(self.partner_id)
        return res

    @api.multi
    def action_schedule_phonecall(self):
        """
        Open meeting's calendar view to schedule meeting on current opportunity
        filter on event of type phonecall
        :return dict: dictionary value for created Meeting view
        """
        res = self.env['ir.actions.act_window'].for_xml_id(
            'calendar', 'action_calendar_event')

        res['context'] = {
            'search_default_opportunity_id': self.id,
            'search_default_phonecall': True,
        }
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
