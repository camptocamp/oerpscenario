# -*- coding: utf-8 -*-
# © 2015 Swisslux AG
# © 2015-2016 Yannick Vaucher (Camptocamp)
# License AGPL-3.0 or later (http://www.gnu.org/licenses/agpl.html).
from openerp import api, fields, models, _


class BuildingProject(models.Model):

    _name = 'building.project'
    _inherits = {'project.project': "project_id"}
    _inherit = ['mail.thread']
    _rec_name = 'display_name'

    display_name = fields.Char(
        compute='_compute_display_name',
        store=True,
    )

    @api.depends('name', 'business_area')     # this definition is recursive
    def _compute_display_name(self):
        for record in self:
            if record.business_area:
                business_area = record.business_area.upper()
                record.display_name = ' - '.join([business_area, record.name])
            else:
                record.display_name = record.name

    project_id = fields.Many2one(
        'project.project',
        required=True,
        ondelete='cascade',
    )
    date_start = fields.Date(
        'erwarteter Lieferstart'
    )
    date_end = fields.Date(
        'erwartetes Lieferende',
        index=True,
        track_visibility='onchange'
    )

    expected_amount = fields.Float(
        "erwarteter Umsatz",
    )

    probability = fields.Selection(
        [(25, '25%'),
         (50, '50%'),
         (75, '75%'),
         (100, '100%')],
        string="Wahrscheinlichkeit",
    )

    contact_ids = fields.One2many(
        comodel_name='res.partner.role',
        inverse_name='building_project_id',
        string='Contacts',
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
        [('active', 'activ begleitet'),
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

    meeting_ids = fields.One2many(
        comodel_name='calendar.event',
        inverse_name='building_project_id'
    )

    meeting_count = fields.Integer(
        compute='_compute_meeting_count',
    )

    doc_count = fields.Integer(
        compute='_get_attached_docs', string="Number of documents attached",
    )

    color = fields.Integer('Color Index')

    @api.model
    def create(self, vals):
        """ When creating a building project, we have to copy the tasks of
        the project.project which is marked as building_template.
        """
        building_project = super(BuildingProject, self).create(vals)
        if not building_project.task_ids:
            template = self.env['project.project'].search([
                ('building_template', '=', True)
            ], limit=1)
            if template and template.task_ids:
                for task in template.task_ids:
                    copy = task.copy()
                    copy.write({
                        # Remove the (copy) part of the name
                        'name': task.name,
                        'project_id': building_project.project_id.id
                    })
                building_project.refresh()

        return building_project

    @api.depends('analytic_account_id')
    def _get_sale_orders(self):
        """ List all sale order linked to this project.
        We do this as reverse many2one is on analytic account
        """
        for rec in self:
            rec.sale_order_ids = self.env['sale.order'].search(
                [('project_id', '=', rec.analytic_account_id.id)])

    @api.depends('sale_order_ids')
    def _sale_order_count(self):
        """ Count aggregated sale orders """
        for rec in self:
            rec.sale_order_count = len(rec.sale_order_ids)

    @api.depends('opportunity_ids')
    def _opportunity_count(self):
        """ Count aggregated meeting from opportunities """
        for rec in self:
            rec.opportunity_count = len(rec.opportunity_ids)

    @api.depends('meeting_ids')
    def _compute_meeting_count(self):
        """ Count aggregated meeting from opportunities """
        for record in self:
            record.meeting_count = len(record.meeting_ids)

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
            rec.doc_count = attachment_model.search_count(
                rec.get_attachment_domain()
            )

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
    def add_role(self, partner):
        self.ensure_one()
        domain = [
            ('partner_id', '=', partner.id),
            ('building_project_id', '=', self.id),
        ]
        role = self.env['res.partner.role'].search(domain)
        if role:
            return
        self.env['res.partner.role'].create({
            'partner_id': partner.id,
            'building_project_id': self.id,
        })

    @api.multi
    def action_schedule_meeting(self):
        """ Open meeting's tree view to schedule meeting on current
        building project

        :return: dictionary value for created Meeting view
        :rtype: dict
        """
        res = self.env['ir.actions.act_window'].for_xml_id(
            'calendar', 'action_calendar_event'
        )

        res['display_name'] = _('Activities')

        res['context'] = {
            'search_default_building_project_id': self.id,
            'default_building_project_id': self.id,
        }
        cal_view = self.env.ref(
            'specific_building_project.view_calendar_event_calendar'
        )
        res['views'] = [
            (False, 'tree'), (cal_view.id, 'calendar'), (False, 'form')
        ]
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
        """ Open opportunities view filtered on this project opportunities.
        :rtype: dict
        """
        res = self.env['ir.actions.act_window'].for_xml_id(
            'crm', 'crm_lead_opportunities'
        )

        res['context'] = {
            'search_default_building_project_id': self.id,
            'default_building_project_id': self.id,
            'default_type': 'opportunity',
        }
        res['domain'] = [('type', '=', 'opportunity')]
        return res

    @api.multi
    def get_attachment_domain(self):
        """ Return the domain for searching all attachments for this project
        includings opportunities attachments.
        """
        self.ensure_one()
        if self.opportunity_ids:
            search_domain = [
                '|',
                '&',
                ('res_model', '=', 'building.project'),
                ('res_id', '=', self.id),
                '&',
                ('res_model', '=', 'crm.lead'),
                ('res_id', 'in', [op.id for op in self.opportunity_ids]),
            ]
        else:
            search_domain = [
                ('res_model', '=', 'building.project'),
                ('res_id', '=', self.id),
            ]
        return search_domain

    @api.multi
    def attachment_tree_view(self):
        self.ensure_one()

        return {
            'name': _('Attachments'),
            'domain': self.get_attachment_domain(),
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
