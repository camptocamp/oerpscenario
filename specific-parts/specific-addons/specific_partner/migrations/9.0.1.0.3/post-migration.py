# -*- coding: utf-8 -*-
# © 2016 Cyril Gaudin (Camptocamp)
# License AGPL-3.0 or later (http://www.gnu.org/licenses/agpl.html).
from openerp import SUPERUSER_ID
from openerp.api import Environment


def migrate(cr, version):

    # Rempli toutes les ref manquantes.
    with Environment.manage():
        env = Environment(cr, SUPERUSER_ID, {})

        partners = env['res.partner'].search([('ref', '=', False)])

        sequence_model = env['ir.sequence']
        for partner in partners:
            partner.ref = sequence_model.next_by_code('res.partner')
