# -*- coding: utf-8 -*-
# © 2015 Yannick Vaucher (Camptocamp)
# License AGPL-3.0 or later (http://www.gnu.org/licenses/agpl.html).
from openerp import models, fields, api


class CRMLead(models.Model):
    _inherit = 'crm.lead'

    building_project_id = fields.Many2one(
        comodel_name='building.project',
        string="Building Project",
    )

    # XXX on create and write, if building_project_id is defined, add the
    # partner of the opportunity to the building_project
    @api.model
    def create(self, vals):
        rec = super(CRMLead, self).create(vals)
        if rec.building_project_id and rec.partner_id:
            rec.building_project_id.contact_ids |= rec.partner_id
        return rec

    @api.multi
    def write(self, vals):
        res = super(CRMLead, self).write(vals)
        if self.building_project_id and self.partner_id:
            self.building_project_id.contact_ids |= self.partner_id
        return res
