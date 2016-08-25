# -*- coding: utf-8 -*-
# © 2016 Yannick Vaucher (Camptocamp)
# License AGPL-3.0 or later (http://www.gnu.org/licenses/agpl.html).
from openerp.tests import common


class TestNewQuotation(common.TransactionCase):

    def test_new_quotation_with_building_project(self):
        self.opportunity.building_project_id = self.building_project
        res = self.opportunity.with_context(
            default_building_project_id=self.building_project.id
        ).create_new_quotation()

        project_id = res['context'].get('default_project_id')
        partner_id = res['context'].get('default_partner_id')

        self.assertEqual(
            project_id, self.building_project.analytic_account_id.id
        )
        self.assertEqual(partner_id, self.partner.id)

    def test_new_quotation_standard(self):
        res = self.opportunity.create_new_quotation()
        project_id = res['context'].get('default_project_id')
        partner_id = res['context'].get('default_partner_id')
        self.assertFalse(project_id)
        self.assertEqual(partner_id, self.partner.id)

    def setUp(self):
        super(TestNewQuotation, self).setUp()

        self.partner = self.env['res.partner'].create({
            'name': 'Unittest partner'
        })
        self.building_project = self.env['building.project'].create({
            'name': 'Building Project',
        })
        self.opportunity = self.env['crm.lead'].create({
            'name': 'Opportunity',
            'partner_id': self.partner.id,
        })
