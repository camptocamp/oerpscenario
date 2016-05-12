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
        string='Object Discount',
        comodel_name='product.pricelist'
    )

    business_provider_id = fields.Many2one(
        string="Business provider",
        comodel_name='res.partner',
        domain=[('is_company', '=', True)],
    )

    @api.onchange('project_id')
    def _set_statics_include(self):
        """ Try to set only one sale order per building project

        When setting a project we check if there is already a project included
        in statistics.
        """
        self.statistics_include = not self.project_id

    @api.onchange('project_id', 'partner_id')
    def _set_project_pricelist(self):
        if self.project_id or not self.partner_id:
            build_project = self.env['building.project'].search(
                [('analytic_account_id', '=', self.project_id.id)])
            discounts = [pl for pl in build_project.customer_discount_ids
                         if pl.partner_id == self.partner_id]
            pricelist = discounts[0].pricelist_id if discounts else False
            self.project_pricelist_id = pricelist

    @api.model
    def _update_build_project_discounts(self, project_id, partner_id,
                                        project_pricelist_id):
        """ If a pricelist is set we check if a pricelist for the customer for
        this project is defined. If it doesn't exist, create one.
        Otherwise do nothing.
        """
        if project_id and project_pricelist_id:
            build_project = self.env['building.project'].search(
                [('analytic_account_id', '=', project_id)])
            project_pl = self.env['building.project.pricelist'].search(
                [('building_project_id', '=', build_project.id),
                 ('partner_id', '=', partner_id)])
            if not project_pl:
                self.env['building.project.pricelist'].create({
                    'building_project_id': build_project.id,
                    'partner_id': partner_id,
                    'pricelist_id': project_pricelist_id})

    @api.model
    def create(self, vals):
        self._update_build_project_discounts(
            vals.get('project_id'), vals.get('partner_id'),
            vals.get('project_pricelist_id'))
        return super(SaleOrder, self).create(vals)

    @api.multi
    def write(self, vals):
        project_id = vals.get('project_id') or self.project_id.id
        partner_id = vals.get('partner_id') or self.partner_id.id
        self._update_build_project_discounts(
            project_id, partner_id,
            vals.get('project_pricelist_id'))

        return super(SaleOrder, self).write(vals)

    @api.multi
    def button_update_unit_prices(self):
        """ Button action to update prices in lines based on pricelists """
        for rec in self:
            for line in rec.order_line:
                line.product_uom_change()


class SaleOrderLine(models.Model):
    _inherit = 'sale.order.line'

    price_unit_readonly = fields.Float(
        string='Unit Price',
        related='price_unit',
        readonly=True)

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
