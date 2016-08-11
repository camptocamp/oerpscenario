# -*- coding: utf-8 -*-
# © 2016 Camptocamp SA
# License AGPL-3.0 or later (http://www.gnu.org/licenses/agpl.html).

from openerp import fields, models


class SaleReport(models.Model):
    _inherit = "sale.report"

    statistics_include = fields.Boolean(
        'Include in statistics', readonly=True
    )

    def _select(self):
        return super(SaleReport, self)._select() \
            + ", s.statistics_include"

    def _group_by(self):
        return super(SaleReport, self)._group_by() + ", s.statistics_include"
