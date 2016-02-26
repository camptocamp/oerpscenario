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
    date = fields.Date(
        'Expiration Date',
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

    opportunity_ids = fields.One2many(
        comodel_name='crm.lead',
        string="Opportunities",
        inverse_name='building_project_id',
        domain=[('type', '=', 'opportunity')],
        copy=False,
    )
    opportunity_count = fields.Integer(
        compute='_opportunity_count',
        comodel_name='crm.lead',
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
        comodel_name='crm.meeting',
        string="# Meetings"
    )

    # @api.one
    # def _aggregate_meetings(self):
    #    """ List all meetings aggregated from opportunities """
    #    self.meeting_ids = self.opportunity_ids.mapped('meeting_ids')

    @api.one
    @api.depends('opportunity_ids')
    def _opportunity_count(self):
        """ Count aggregated meeting from opportunities """
        self.opportunity_count = len(self.opportunity_ids.ids)

    @api.one
    @api.depends('opportunity_ids.meeting_count')
    def _meeting_count(self):
        """ Count aggregated meeting from opportunities """
        self.meeting_count = sum(self.opportunity_ids.mapped('meeting_count'))

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
