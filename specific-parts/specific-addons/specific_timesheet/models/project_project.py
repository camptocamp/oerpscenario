# -*- coding: utf-8 -*-
# © 2016 Cyril Gaudin (Camptocamp)
# License AGPL-3.0 or later (http://www.gnu.org/licenses/agpl.html).

from openerp import models


class Project(models.Model):
    """ Re-active use_timesheets field on project.
    """
    _inherit = 'project.project'

    _defaults = {
        'use_timesheets': True
    }
