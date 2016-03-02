# -*- coding: utf-8 -*-
# © 2015 Swisslux AG
# © 2015 Yannick Vaucher (Camptocamp)
# License AGPL-3.0 or later (http://www.gnu.org/licenses/agpl.html).
from openerp import models, fields, api


class BuildingProject(models.Model):

    _name = 'building.project'
    _inherits = {'account.analytic.account': "analytic_account_id"}

    date_start = fields.Date(
        'Start Date'
    )
    date_end = fields.Date(
        'End Date',
        index=True,
        track_visibility='onchange'
    )
    user_id = fields.Many2one(
        'res.users',
        'Project Manager'
    )

    contact_ids = fields.Many2many(
        comodel_name='res.partner',
        string='Contacts',
        domain=['|', '|', ('architect', '=', True), ('engineer', '=', True),
                ('electrician', '=', True)],
        copy=False,
        help="Envolved partners (Architect, Ingineer, Electrician)"
    )

    build_state = fields.Selection(
        (('projet', 'Projekt'),
         ('request', 'Gesuch'),
         ('confirmed', 'Bewilligt'),
         ('submission', 'Submission'),
         ('done', 'abgeschlossen'),
         ('unknown', 'Unbekannt')),
        'Bauprojekt-Status'
    )
    build_type = fields.Selection(
        (('new', 'Neubau'),
         ('conversion', 'Umbau'),
         ('renovation', 'Renovation')),
        'Bauprojekt-Typ'
    )
    building_project_tag_ids = fields.Many2many(
        comodel_name='building.project.tag',
        string='Projekt Tags'
    )
    project_type_id = fields.Many2one(
        comodel_name='building.project.type',
        string='Projekt Art'
    )

    customer_discount_ids = fields.One2many(
        comodel_name='building.project.pricelist',
        inverse_name='building_project_id',
        string='Customer discounts',
    )

    street = fields.Char(
        'Strasse',
        copy=False,
    )
    zip = fields.Char(
        'PLZ',
        copy=False,
    )
    city = fields.Char(
        'Ort',
        copy=False,
    )

    sale_order_ids = fields.One2many(
        comodel_name='sale.order',
        string="Sales orders",
        compute='_get_sale_orders',
        copy=False,
    )
    sale_order_count = fields.Integer(
        compute='_sale_order_count',
        string="# Sales Order"
    )

    opportunity_ids = fields.One2many(
        comodel_name='crm.lead',
        string="Opportunities",
        inverse_name='building_project_id',
        domain=[('type', '=', 'opportunity')],
        copy=False,
    )
    opportunity_count = fields.Integer(
        compute='_opportunity_count',
        string="# Opportunity"
    )

    # phonecall_ids = fields.One2many(
    #     compute='_aggregate_meetings_and_phoncalls',
    #     comodel_name='crm.phonecall',
    #     string='Phonecalls'
    # )
    # meeting_ids = fields.One2many(
    #     compute='_aggregate_meetings',
    #     comodel_name='crm.meeting',
    #     string="Meetings"
    # )
    meeting_count = fields.Integer(
        compute='_meeting_count',
        string="# Meetings"
    )

    # @api.one
    # def _aggregate_meetings(self):
    #    """ List all meetings aggregated from opportunities """
    #    self.meeting_ids = self.opportunity_ids.mapped('meeting_ids')

    @api.depends('analytic_account_id')
    def _get_sale_orders(self):
        """ List all sale order linked to this project.
        We do this as reverse many2one is on analytic account
        """
        for rec in self:
            self.sale_order_ids = self.env['sale.order'].search(
                [('project_id', '=', self.analytic_account_id.id)])

    @api.depends('opportunity_ids')
    def _sale_order_count(self):
        """ Count aggregated sale orders """
        for rec in self:
            self.sale_order_count = len(self.sale_order_ids)

    @api.depends('opportunity_ids')
    def _opportunity_count(self):
        """ Count aggregated meeting from opportunities """
        for rec in self:
            rec.opportunity_count = len(rec.opportunity_ids.ids)

    @api.depends('opportunity_ids.meeting_count')
    def _meeting_count(self):
        """ Count aggregated meeting from opportunities """
        for rec in self:
            rec.meeting_count = sum(
                rec.opportunity_ids.mapped('meeting_count')
            )

    @api.multi
    def action_schedule_meeting(self):
        """
        Open meeting's calendar view to schedule meeting on current opportunity
        :return dict: dictionary value for created Meeting view
        """
        res = self.env['ir.actions.act_window'].for_xml_id(
            'calendar', 'action_calendar_event')

        res['context'] = {
            'search_default_building_project_id': self.id,
            # 'search_default_opportunity_id': self.opportunity_ids.ids,
        }
        return res

    @api.multi
    def action_sale_orders(self):
        """
        Open sale order tree view
        :return dict: dictionary value for created Meeting view
        """
        res = self.env['ir.actions.act_window'].for_xml_id(
            'sale', 'action_orders')

        res['context'] = {
            'search_default_project_id': self.analytic_account_id.id,
            'default_project_id': self.analytic_account_id.id,
            'statistics_include_hide': False,
        }
        res['domain'] = []
        return res
