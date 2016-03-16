# -*- coding: utf-8 -*-
# © 2016 Yannick Vaucher (Camptocamp)
# License AGPL-3.0 or later (http://www.gnu.org/licenses/agpl.html).
from openerp import api, fields, models
from openerp.tools import frozendict


class SaleOrder(models.Model):
    _inherit = 'sale.order'

    # As for a single building project only one sale order will be selected
    # we want to filter sale orders of type building project
    statistics_include = fields.Boolean(
        "Include in statistics",
        default=True,
        help="Flag field to deduplicate sale order for the same building "
             "project in statistics. By default the first sale order for a "
             "building project will be flagged."
    )

    project_pricelist_id = fields.Many2one(
        string='Pricelist',
        compute='_get_project_pricelist',
        comodel_name='product.pricelist'
    )

    @api.depends('project_id', 'partner_id')
    def _get_project_pricelist(self):
        for rec in self:
            if not rec.project_id or not rec.partner_id:
                continue
            build_project = self.env['building.project'].search(
                [('analytic_account_id', '=', rec.project_id.id)])
            discounts = [pl for pl in build_project.customer_discount_ids
                         if pl.partner_id == rec.partner_id]
            pricelist = discounts[0].pricelist_id if discounts else False
            rec.project_pricelist_id = pricelist

    @api.onchange('project_id')
    def _set_statics_include(self):
        """ Try to set only one sale order per building project

        When setting a project we check if there is already a project included
        in statistics.
        """
        self.statistics_include = not self.project_id

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
