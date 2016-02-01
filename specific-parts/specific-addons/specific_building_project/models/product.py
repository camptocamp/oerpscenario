# -*- coding: utf-8 -*-
# © 2016 Yannick Vaucher (Camptocamp)
# License AGPL-3.0 or later (http://www.gnu.org/licenses/agpl.html).
from openerp import models
from openerp.osv import fields
import openerp.addons.decimal_precision as dp
""" Compute product price including a building site pricelist if defined """


class ProductProduct(models.Model):
    _inherit = 'product.product'

    def _product_price(self, cr, uid, ids, name, arg, context=None):
        """ Add computation of project pricelist based on pricelist
        passed in context.

        """
        # We get first the values with base pricelist
        res = super(ProductProduct, self)._product_price(
            cr, uid, ids, name, arg, context=context)
        if context is None:
            context = {}
        project_pricelist_id = context.get('project_pricelist')
        if project_pricelist_id:
            ctx = context.copy()
            ctx = {
                'tmp_prices': res,
                'pricelist': project_pricelist_id
            }
            res = super(ProductProduct, self)._product_price(
                cr, uid, ids, name, arg, context=ctx)
        return res

    def _set_product_lst_price(self, cr, uid, id, name, value, args,
                               context=None):
        """ Nothing change here, just calling former function """
        return super(ProductProduct, self)._set_product_lst_price(
            cr, uid, id, name, value, args, context=context)

    _columns = {
        'price': fields.function(
            _product_price, fnct_inv=_set_product_lst_price, type='float',
            string='Price', digits_compute=dp.get_precision('Product Price')),
    }


class ProductTemplate(models.Model):
    _inherit = 'product.template'

    def _price_get(self, cr, uid, products, ptype='list_price', context=None):
        """ Used by pricelist to apply a pricelist on a specific price
        This will not work with pricelist already based on other pricelist

        By setting in context
        - `pricelist` as pricelist id
        - `tmp_prices` as a dict {id: val}
        it is possible to inject the intermediate value on which we want to
        apply another pricelist specified in context.

        This allow to dynamicaly chain pricelists.
        """
        if 'tmp_prices' in context:
            return context.get('tmp_prices')
        return super(ProductTemplate, self)._price_get(
            cr, uid, products, ptype=ptype, context=context)
