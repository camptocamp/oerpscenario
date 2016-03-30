# -*- coding: utf-8 -*-
# © 2015 Swisslux AG
# © 2015-2016 Yannick Vaucher (Camptocamp)
# License AGPL-3.0 or later (http://www.gnu.org/licenses/agpl.html).
from openerp import api, fields, models, _


class BuildingProject(models.Model):

    _name = 'building.project'
    _inherits = {'account.analytic.account': "analytic_account_id"}
    _rec_name = 'display_name'

    display_name = fields.Char(
        compute='_compute_display_name'
    )

    @api.multi
    @api.depends('name', 'business_area')     # this definition is recursive
    def _compute_display_name(self):
        if self.business_area:
            business_area = self.business_area.upper()
            self.display_name = ' - '.join([business_area, self.name])
        else:
            self.display_name = self.name

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
        help="Envolved partners (Architect, Engineer, Electrician)"
    )

    @api.multi
    def _get_default_stage_id(self):
        """ Gives default stage_id """
        return self.env['building.project.stage'].search([], limit=1)

    stage_id = fields.Many2one(
        comodel_name='building.project.stage',
        string="Stage",
        required=True,
        default=_get_default_stage_id
    )

    build_type = fields.Selection(
        (('new', 'Neubau'),
         ('conversion', 'Umbau'),
         ('renovation', 'Renovation')),
        'Bauprojekt-Typ'
    )
    build_progress = fields.Selection(
        [('strategic_planning', 'Strategische Plannung'),
         ('preliminary', 'Vorprojekt'),
         ('configuration', 'Projektierung'),
         ('announcement', 'Ausschreibung'),
         ('realisation', 'Realisierung'),
         ('management', 'Bewirtschaftung')],
        "Fortschritt nach sia"
    )
    business_area = fields.Selection(
        [('pir', "PIR"),
         ('il', "IL")],
        string=u"Geschäftsfeld",
    )

    build_activity = fields.Selection(
        [('active', 'activ'),
         ('passive', 'nicht aktiv begleitet'),
         ('inactive', 'nicht mehr aktiv begleitet')],
        "Aktivität",
        default='active'
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
    state_id = fields.Many2one(
        'res.country.state',
        'State',
        ondelete='restrict'
    )
    country_id = fields.Many2one(
        'res.country',
        'Country',
        ondelete='restrict'
    )
    region_id = fields.Many2one('res.partner.region', "Verkaufsgebiet")
    zip_id = fields.Many2one('res.better.zip', 'City/Location')

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

    phonecall_ids = fields.One2many(
        compute='_aggregate_phonecall_meetings',
        comodel_name='crm.phonecall',
        string='Phonecalls'
    )
    meeting_count = fields.Integer(
        compute='_meeting_count',
        string="# Meetings"
    )

    phonecall_count = fields.Integer(
        compute='_phonecall_count',
        string="# Phonecalls",
    )

    doc_count = fields.Integer(
        compute='_get_attached_docs', string="Number of documents attached",
    )

    color = fields.Integer('Color Index')

    @api.depends('analytic_account_id')
    def _get_sale_orders(self):
        """ List all sale order linked to this project.
        We do this as reverse many2one is on analytic account
        """
        for rec in self:
            rec.sale_order_ids = self.env['sale.order'].search(
                [('project_id', '=', rec.analytic_account_id.id)])

    @api.depends('opportunity_ids')
    def _sale_order_count(self):
        """ Count aggregated sale orders """
        for rec in self:
            rec.sale_order_count = len(rec.sale_order_ids)

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

    @api.depends('opportunity_ids.phonecall_count')
    def _phonecall_count(self):
        """ Count aggregated phonecall from opportunities """
        for rec in self:
            rec.phonecall_count = sum(
                rec.opportunity_ids.mapped('phonecall_count')
            )

    @api.onchange('zip_id')
    def onchange_zip_id(self):
        for rec in self:
            if rec.zip_id:
                rec.zip = rec.zip_id.name
                rec.city = rec.zip_id.city
                rec.state_id = rec.zip_id.state_id
                rec.country_id = rec.zip_id.country_id
                rec.region_id = rec.zip_id.region_id

    @api.multi
    def _get_attached_docs(self):
        attachment_model = self.env['ir.attachment']
        for rec in self:
            project_attachments = attachment_model.search_count(
                [('res_model', '=', 'building.project'),
                 ('res_id', '=', rec.id)])
            rec.doc_count = project_attachments

    @api.multi
    def _read_group_stage_ids(self, domain, read_group_order=None,
                              access_rights_uid=None):
        """ Read group customization in order to display all the states in the
            kanban view, even if they are empty
        """
        stage_obj = self.env['building.project.stage']
        order = stage_obj._order
        access_rights_uid = access_rights_uid or self.env.uid
        if read_group_order == 'stage_id desc':
            order = '%s desc' % order
        stage_ids = stage_obj._search(
            [], order=order, access_rights_uid=access_rights_uid
        )
        stages = stage_obj.browse(stage_ids)
        result = [stage.name_get()[0] for stage in stages]

        fold = {}
        for stage in stages:
            fold[stage.id] = stage.fold or False
        return result, fold

    _group_by_full = {'stage_id': _read_group_stage_ids}

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
        }
        cal_view = self.env.ref(
            'specific_building_project.view_calendar_event_calendar')
        res['view_id'] = cal_view.id
        res['views'] = [(cal_view.id, 'calendar')]
        return res

    @api.multi
    def action_schedule_phonecall(self):
        """
        Open meeting's calendar view to schedule meeting on current opportunity
        filter on event of type phonecall
        :return dict: dictionary value for created Meeting view
        """
        res = self.env['ir.actions.act_window'].for_xml_id(
            'calendar', 'action_calendar_event')

        res['context'] = {
            'search_default_building_project_id': self.id,
            'search_default_phonecall': True,
        }
        cal_view = self.env.ref(
            'specific_building_project.view_calendar_event_calendar')
        res['view_id'] = cal_view.id
        res['views'] = [(cal_view.id, 'calendar')]
        return res

    @api.multi
    def action_sale_orders(self):
        """
        Open sale order tree view
        :return dict: dictionary value for created sale order view
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

    @api.multi
    def action_opportunities(self):
        """
        Open opportunities view
        :return dict: dictionary value for created opportunity view
        """
        res = self.env['ir.actions.act_window'].for_xml_id(
            'crm', 'crm_lead_opportunities')

        res['context'] = {
            'search_default_building_project_id': self.id,
            'default_project_id': self.id,
        }
        res['domain'] = []
        return res

    @api.multi
    def attachment_tree_view(self):
        self.ensure_one()
        domain = [('res_model', '=', 'building.project'),
                  ('res_id', 'in', self.ids)]
        return {
            'name': _('Attachments'),
            'domain': domain,
            'res_model': 'ir.attachment',
            'type': 'ir.actions.act_window',
            'view_id': False,
            'view_mode': 'kanban,tree,form',
            'view_type': 'form',
            'help': _(
                '''<p class="oe_view_nocontent_create">
                   Documents are attached to the tasks and issues of your
                   project.</p><p>Send messages or log internal notes with
                   attachments to link documents to your project.</p>'''),
            'limit': 80,
            'context': "{'default_res_model': '%s','default_res_id': %d}" % (
                self._name, self.id)
        }
