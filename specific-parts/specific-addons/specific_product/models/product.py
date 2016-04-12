# -*- coding: utf-8 -*-
# © 2016 Yannick Vaucher (Camptocamp)
# License AGPL-3.0 or later (http://www.gnu.org/licenses/agpl.html).
from openerp import api, fields, models
from openerp.addons import decimal_precision as dp
from openerp.osv import expression


class ProductTemplate(models.Model):
    _inherit = 'product.template'

    e_nr = fields.Char("E-Nr")

    transit_qty = fields.Float(
        compute='_get_transit_qty',
        digits_compute=dp.get_precision('Product Unit of Measure'),
        string='Transit'
    )

    @api.depends('virtual_available')
    def _get_transit_qty(self):
        """Compute the quantity of product that is in transit.
        """
        for tmpl in self:
            tmpl.transit_qty = sum(
                product.transit_qty for product in tmpl.product_variant_ids
            )

    @api.multi
    def action_transit_move(self):
        """ Return stock.move list view for this product filtered by
        Transit from China location.
        """
        self.ensure_one()

        transit_loc = self.env.ref('scenario.location_transit_cn')

        context = self.env.context.copy()
        context['search_default_product_id'] = self.product_variant_ids[0].id
        # In stock_view.xml, location search name is "name"....
        context['search_default_name'] = transit_loc.complete_name

        return {
            'name': 'Transit moves',
            'type': 'ir.actions.act_window',
            'view_type': 'list',
            'view_mode': 'list',
            'res_model': 'stock.move',
            'target': 'current',
            'view_id': self.env.ref('stock.view_move_tree').id,
            'context': context,
        }


class ProductProduct(models.Model):
    _inherit = 'product.product'

    transit_qty = fields.Float(
        compute='_get_transit_qty',
        digits_compute=dp.get_precision('Product Unit of Measure'),
        string='Transit'
    )

    @api.depends('virtual_available')
    def _get_transit_qty(self):
        """Compute the quantity of product that is in transit.
        """
        move_model = self.env['stock.move']

        transit_loc = self.env.ref('scenario.location_transit_cn')

        domain = None
        if transit_loc:
            domain = [
                ('state', 'not in', ('done', 'cancel', 'draft')),
                ('location_id', '=', transit_loc.id)
            ]

        for product in self:
            if not domain or not product.virtual_available:
                product.transit_qty = 0
            else:
                transit_moves = move_model.search(
                    domain + [('product_id', '=', product.id)]
                )
                product.transit_qty = sum(
                    move.product_qty for move in transit_moves
                )

    @api.model
    def name_search(self, name, args=None, operator='ilike', limit=100):
        """ Allow to search by E-Nr """
        args = args or []

        result = super(ProductProduct, self).name_search(
            name, args=args, operator=operator, limit=limit)

        if limit is not None:
            limit -= len(result)

        if limit is None or limit > 1:
            domain = [('e_nr', '=ilike', name + '%')]
            if operator in expression.NEGATIVE_TERM_OPERATORS:
                domain = ['&'] + domain
            products = self.search(domain + args, limit=limit)
            result.extend(products.name_get())
        return result

    @api.multi
    def action_transit_move(self):
        """ Return stock.move list view for this product filtered by
        Transit from China location.
        """
        return self.product_tmpl_id.action_transit_move()
