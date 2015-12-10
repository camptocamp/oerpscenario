# -*- coding: utf-8 -*-
# © 2015 Yannick Vaucher (Camptocamp)
# License AGPL-3.0 or later (http://www.gnu.org/licenses/agpl.html).
from openerp import models, fields


class BuildingProjectType(models.Model):
    _name = 'building.project.type'

    name = fields.Char('Building Project Type')
