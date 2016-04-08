# -*- coding: utf-8 -*-
# © 2016 Yannick Vaucher (Camptocamp)
# License AGPL-3.0 or later (http://www.gnu.org/licenses/agpl.html).
from openerp import api, fields, models


class ResPartner(models.Model):
    _inherit = 'res.partner'

    building_project_ids = fields.One2many(
        comodel_name='building.project',
        compute='_get_building_projects',
        string='Bauprojekt',
    )

    @api.multi
    def _get_building_projects(self):
        for rec in self:
            if rec.is_company:
                domain = [('partner_id', '=', rec.id)]
                recs = self.env['building.project.pricelist'].search(domain)
                rec.building_project_ids = recs.mapped('building_project_id')
