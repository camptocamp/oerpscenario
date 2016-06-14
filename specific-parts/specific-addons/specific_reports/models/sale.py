# -*- coding: utf-8 -*-
# © 2016 Yannick Vaucher (Camptocamp)
# License AGPL-3.0 or later (http://www.gnu.org/licenses/agpl.html).
from openerp import api, fields, models


class SaleOrder(models.Model):
    _inherit = 'sale.order'

    client_order_contact_type = fields.Selection(
        [('email', 'Per E-Mail'),
         ('in_person', 'Persönlich'),
         ('post', 'Per Post'),
         ('tel', 'Per Telefon'),
         ('stand', 'Messestand')],
        "Client order contact type",
        help="Description of how the order was made"
    )
    client_order_date = fields.Date(
        "Client order date",
        help="When the order was made"
    )
    delivery_term = fields.Date(
        "Term of delivery",
    )

    @api.multi
    def action_invoice_create(self, grouped=False, final=False):
        invoice_ids = super(SaleOrder, self).action_invoice_create(
            grouped=grouped, final=final)
        invoices = self.env['account.invoice'].browse(invoice_ids)
        for rec in invoices:
            rec.client_order_contact_type = self.client_order_contact_type
            rec.client_order_date = self.client_order_date
        return invoice_ids

    @api.multi
    def get_employee_from_user(self, user_id):
        resource = self.env['resource.resource'].search(
            [('user_id', '=', user_id.id)])
        hr_employee = self.env['hr.employee'].search(
            [('resource_id', '=', resource.id)])

        return hr_employee


class SaleOrderLine(models.Model):
    _inherit = 'sale.order.line'

    price_unit_discount = fields.Monetary(
        compute='_compute_price_discount', string='Subtotal',
        readonly=True
    )

    project_discount = fields.Float(compute='compute_discount',
                                    string='Object Discount (%)')
    public_discount = fields.Float(compute='compute_discount',
                                   string='Discount (%)')

    @api.one
    @api.depends('price_unit', 'discount')
    def _compute_price_discount(self):
        if self.discount:
            if self.discount == 100:
                discount = 0.0
            else:
                discount = 1 - self.discount / 100.0
            self.price_unit_discount = self.price_unit * discount
        else:
            self.price_unit_discount = self.price_unit

    @api.depends('order_id.project_pricelist_id',
                 'order_id.pricelist_id',
                 'product_id')
    def compute_discount(self):
        for rec in self:
            product = rec.product_id.with_context(
                lang=rec.order_id.partner_id.lang,
                partner=rec.order_id.partner_id.id,
                quantity=rec.product_uom_qty,
                date=rec.order_id.date_order,
                pricelist=rec.order_id.pricelist_id.id,
                uom=rec.product_uom.id
            )
            base_price = rec.price_unit
            public_price = product.price
            product = product.with_context(
                project_pricelist=rec.order_id.project_pricelist_id.id)
            final_price = product.price

            if public_price:
                rec.project_discount = (1 - final_price / public_price) * 100
            if base_price:
                rec.public_discount = (1 - public_price / base_price) * 100

    @api.multi
    def _prepare_invoice_line(self, qty):
        for rec in self:
            inv_line = super(SaleOrderLine, rec)._prepare_invoice_line(qty)

            inv_line['project_discount'] = rec.project_discount
            inv_line['public_discount'] = rec.public_discount
        return inv_line
