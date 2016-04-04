# -*- coding: utf-8 -*-
# © 2015 Swisslux AG
# © 2015 Yannick Vaucher (Camptocamp)
# License AGPL-3.0 or later (http://www.gnu.org/licenses/agpl.html).
from openerp import models, fields


class BuildingProjectPricelist(models.Model):

    _name = 'building.project.pricelist'

    partner_id = fields.Many2one(
        comodel_name='res.partner',
        domain=[('is_company', '=', True)],
        string='Customer',
        required=True,
    )

    pricelist_id = fields.Many2one(
        comodel_name='product.pricelist',
        string='Pricelist',
    )

    building_project_id = fields.Many2one(
        comodel_name='building.project',
        string='Building Project',
        required=True,
    )

    _sql_constraints = [
        ('partner_building_project_uniq',
         'unique(building_project_id, partner_id)',
         'The discount must be unique per partner in building project!'),
    ]
