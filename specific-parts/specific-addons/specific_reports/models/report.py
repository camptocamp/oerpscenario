# -*- coding: utf-8 -*-
# © 2016 Camptocamp SA
# License AGPL-3.0 or later (http://www.gnu.org/licenses/agpl.html).

from openerp import api, models


class Report(models.Model):
    _inherit = 'report'

    @api.v7
    def _check_attachment_use(self, cr, uid, ids, report, context=None):
        """ Don't save attachment if the report is generated for email.
        """
        if 'default_template_id' in context:
            return {}
        else:
            return super(Report, self)._check_attachment_use(
                cr, uid, ids, report, context=context
            )
