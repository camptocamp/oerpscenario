# -*- coding: utf-8 -*-
# © 2015 Yannick Vaucher (Camptocamp)
# License AGPL-3.0 or later (http://www.gnu.org/licenses/agpl.html).
from openerp import models, fields


class BuildingProjectStage(models.Model):
    _name = 'building.project.stage'
    _order = 'sequence'

    name = fields.Char()
    fold = fields.Boolean('Fold project in kanban?')
    sequence = fields.Integer()
