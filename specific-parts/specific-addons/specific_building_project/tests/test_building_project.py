# -*- coding: utf-8 -*-
# © 2016 Camptocamp SA
# License AGPL-3.0 or later (http://www.gnu.org/licenses/agpl.html).

from openerp.tests.common import TransactionCase


class TestBuildingProject(TransactionCase):

    def test_name_search(self):

        building_model = self.env['building.project']

        bp1 = building_model.create({'name': 'Test 1'})
        bp2 = building_model.create({'name': 'Test 2', 'business_area': 'pir'})
        bp3 = building_model.create({'name': 'Project 3'})

        result = building_model.name_search('project')
        self.assertEqual([bp3.id], [r[0] for r in result])

        result = building_model.name_search('pir')
        self.assertEqual([bp2.id], [r[0] for r in result])

        self.assertEqual('Test 1', bp1.display_name)
        self.assertEqual('PIR - Test 2', bp2.display_name)
        self.assertEqual('Project 3', bp3.display_name)
