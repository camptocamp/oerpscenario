# -*- coding: utf-8 -*-
# © 2015 Swisslux
# © 2016 Yannick Vaucher (Camptocamp)
# License AGPL-3.0 or later (http://www.gnu.org/licenses/agpl.html).
from openerp import api, fields, models
from openerp.osv import expression
from openerp.osv import fields as osv_fields


class ResPartner(models.Model):
    _inherit = 'res.partner'

    @api.multi
    def _display_name_compute(self, name, args):
        res = super(ResPartner, self)._display_name_compute(name, args)
        for rec in self:
            if rec.ref:
                res[rec.id] = '{} ({})'.format(res[rec.id], rec.ref)
        return res

    # Add ref in triggers in base code
    _display_name_store_triggers = {
        'res.partner': (
            lambda self, cr, uid, ids, context=None: self.search(
                cr, uid, [('id', 'child_of', ids)],
                context=dict(active_test=False)),
            ['parent_id', 'is_company', 'name', 'ref'], 10)
    }

    def _display_name(self, *args, **kwargs):
        return self._display_name_compute(*args, **kwargs)

    _columns = {
        'display_name': osv_fields.function(
            _display_name, type='char', string='Name',
            store=_display_name_store_triggers, select=True
        ),
    }

    ref = fields.Char('Code', default='New')
    parent_category_id = fields.Many2one(
        relation='parent_id.category_id',
        string="Tags parent",
        store=False,
        readonly=True
    )
    name2 = fields.Char('Additional name')

    # EEV infos
    eev_member = fields.Boolean('EEV-Mitglied')
    eev_number = fields.Char('EEV Nr.')
    eev_alarm = fields.Boolean('Haftungsablehnung')

    # PO box
    pobox_nr = fields.Char('PO Box Nr')
    pobox_zip = fields.Char('PO Box Zip')
    pobox_city = fields.Char('PO Box City')

    companytype = fields.Selection(
        (('headquarter', 'Hauptsitz'),
         ('branch', 'Filiale')),
        'Firmen Typ'
    )
    headquarter_id = fields.Many2one(
        'res.partner',
        'Headquarter',
        ondelete='set null'
    )

    partner_shipping_id = fields.Many2one(
        'res.partner',
        'Shipping Partner',
        ondelete='set null'
    )
    partner_invoicing_id = fields.Many2one(
        'res.partner',
        'Invoicing Partner',
        ondelete='set null'
    )

    mailing = fields.Selection(
        (('0', 'keine Dokus'),
         ('1', '1 Exemplar'),
         ('5', '5 Exemplare'),
         ('10', '10 Exemplare'),
         ('25', '25 Exemplare'),
         ('50', '50 Exemplare'),
         ('100', '100 Exemplare')),
        'Dokuversand'
    )
    mailing_email = fields.Selection(
        (('0', 'abmelden'),
         ('1', 'anmelden')),
        'E-Mail Newsletter'
    )

    department = fields.Char('Department')
    partner_state = fields.Selection(
        (('ST1', 'qualifiziert'),
         ('ST2', 'potentieller Partner'),
         ('ST3', 'Kontaktpflege aktuell'),
         ('ST4', 'aktiv begleitet'),
         ('ST5', 'nicht mehr aktiv begleitet'),
         ('ST6', 'positiv'),
         ('ST7', 'komplett')),
        'State of Partner'
    )

    prospect = fields.Boolean()
    partner = fields.Boolean()

    region_id = fields.Many2one('res.partner.region', "Verkaufsgebiet")

    @api.model
    def create(self, vals):
        """Define customer code"""
        if vals.get('ref', 'New') == 'New':
            vals['ref'] = self.env['ir.sequence'].next_by_code(
                'res.partner') or 'New'

        result = super(ResPartner, self).create(vals)
        return result

    @api.model
    def name_search(self, name, args=None, operator='ilike', limit=100):
        args = args or []
        domain = []
        result = None
        if name:
            domain = [('ref', '=ilike', name + '%')]
            if operator in expression.NEGATIVE_TERM_OPERATORS:
                domain = ['&'] + domain
            partners = self.search(domain + args, limit=limit)
            result = partners.name_get()
        if not result:
            result = super(ResPartner, self).name_search(
                name, args=args, operator=operator, limit=limit)
        return result

    @api.one
    @api.onchange('zip_id')
    def onchange_zip_set_region_and_user(self):
        if self.zip_id:
            self.region_id = self.zip_id.region_id
            self.user_id = self.zip_id.user_id
