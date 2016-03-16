# -*- coding: utf-8 -*-
# © 2016 Yannick Vaucher (Camptocamp SA)
# License AGPL-3.0 or later (http://www.gnu.org/licenses/agpl.html).
from openerp import api, fields, models


class CreateOpportunityQuotation(models.TransientModel):
    _name = 'create.opportunity.quotation'

    wholesaler_id = fields.Many2one(
        comodel_name='res.partner',
        string="Wholesaler",
        domain="[('id', 'in', building_project_customer_ids[0][2])]",
        help="Wholesaler for the building project"
    )

    @api.model
    def _default_customers(self):
        ctx = self.env.context
        if not ctx.get('active_model') == 'crm.lead':
            return
        lead = self.env['crm.lead'].browse(ctx.get('active_id'))
        partners = lead.mapped(
            'building_project_id.customer_discount_ids.partner_id')
        # Provide all know partner ids to avoid an error with the domain on
        # wholesale_id
        if not partners:
            partners = partners.search([])
        return partners.ids

    building_project_customer_ids = fields.Many2many(
        comodel_name='res.partner',
        string="Technical filter for wholesaler_id",
        default=_default_customers,
        help="List of allowed customers"
    )

    @api.multi
    def create_new_quotation(self):
        act_dict = self.env['ir.actions.act_window'].for_xml_id(
            'sale_crm', 'sale_action_quotations_new'
        )
        act_dict['context'] = self.env.context.copy()
        lead_partner_id = self.env.context.get('default_partner_id')
        act_dict['context'].update({
            'default_business_provider_id': lead_partner_id,
            'default_partner_id': self.wholesaler_id.id,
        })

        return act_dict
