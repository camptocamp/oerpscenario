# -*- coding: utf-8 -*-
# © 2016 Yannick Vaucher (Camptocamp)
# License AGPL-3.0 or later (http://www.gnu.org/licenses/agpl.html).
from openerp import api, fields, models
from openerp.tools import frozendict


class SaleOrder(models.Model):
    _inherit = 'sale.order'

    project_pricelist_id = fields.Many2one(
        compute='_get_project_pricelist',
        comodel_name='product.pricelist'
    )

    @api.one
    @api.depends('project_id')
    def _get_project_pricelist(self):
        if self.project_id:
            build_project = self.env['building.project'].search(
                [('analytic_account_id', '=', self.project_id.id)])
            self.project_pricelist_id = build_project.pricelist_id

    @api.multi
    def button_update_unit_prices(self):
        """ Button action to update prices in lines based on pricelists """
        for rec in self:
            for line in rec.order_line:
                line.product_uom_change()


class SaleOrderLine(models.Model):
    _inherit = 'sale.order.line'

    @api.onchange('product_uom', 'product_uom_qty')
    def product_uom_change(self):
        """ Alter context of onchange to trigger computation
        of project pricelist
        """
        base_ctx = frozendict(self.env.context)
        project_pricelist = self.order_id.project_pricelist_id
        if project_pricelist:
            # Ugly set of context due to
            # https://github.com/odoo/odoo/issues/7472
            self.env.context = frozendict(
                base_ctx,
                project_pricelist=project_pricelist.id)

        super(SaleOrderLine, self).product_uom_change()

        # Restore context
        self.env.context = base_ctx
