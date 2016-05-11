# -*- coding: utf-8 -*-
# © 2016 Yannick Vaucher (Camptocamp)
# License AGPL-3.0 or later (http://www.gnu.org/licenses/agpl.html).
from openerp import fields, models


class ResPartnerRole(models.Model):
    """ This object is for the table of relation between
    building project and res partners.
    As one partner can have different roles depending on the project
    """
    _name = 'res.partner.role'

    building_project_id = fields.Many2one(
        comodel_name='building.project',
        string="Bauprojekt",
        required=True,
    )
    partner_id = fields.Many2one(
        comodel_name='res.partner',
        string="Contact",
        required=True,
    )
    role = fields.Selection(
        [('builder', "Bauherr"),
         ('eletrician', "Elektroinstallateur"),
         ('engineer', "Planer"),
         ('wholesaler', "Vertriedspartner")],
        string="Role"
    )
    # related fields for contact kanban view
    color = fields.Integer(related='partner_id.color')
    name = fields.Char(related='partner_id.name')
    title = fields.Many2one('res.partner.title', related='partner_id.title')
    type = fields.Selection(
        [('contact', 'Contact'),
         ('invoice', 'Invoice address'),
         ('delivery', 'Shipping address'),
         ('other', 'Other address')],
        string='Address Type',
        related='partner_id.type')
    email = fields.Char(related='partner_id.email')
    is_company = fields.Boolean(related='partner_id.is_company')
    function = fields.Char(related='partner_id.function')
    phone = fields.Char(related='partner_id.phone')
    zip = fields.Char(related='partner_id.zip')
    city = fields.Char(related='partner_id.city')
    country_id = fields.Many2one(
        'res.country', related='partner_id.country_id')
    mobile = fields.Char(related='partner_id.mobile')
    fax = fields.Char(related='partner_id.fax')
    state_id = fields.Many2one(
        'res.country.state', related='partner_id.state_id')
    image = fields.Binary(related='partner_id.image')
