# -*- coding: utf-8 -*-
# © 2016 Camptocamp SA
# License AGPL-3.0 or later (http://www.gnu.org/licenses/agpl.html).
from psycopg2._psycopg import IntegrityError

from openerp.tests.common import TransactionCase


class TestBuildingProject(TransactionCase):

    def setUp(self):
        super(TestBuildingProject, self).setUp()
        self.building_model = self.env['building.project']
        self.project_model = self.env['project.project']
        self.task_model = self.env['project.task']

        # Remove template tag on a possible existing project for transaction.
        template = self.project_model.search([
            ('building_template', '=', True)
        ])
        template.write({'building_template': False})

    def test_name_search(self):
        bp1 = self.building_model.create({'name': 'Test 1'})
        bp2 = self.building_model.create({'name': 'Test 2',
                                          'business_area': 'pir'})
        bp3 = self.building_model.create({'name': 'Project 3'})

        result = self.building_model.name_search('project')
        self.assertEqual([bp3.id], [r[0] for r in result])

        result = self.building_model.name_search('pir')
        self.assertEqual([bp2.id], [r[0] for r in result])

        self.assertEqual('Test 1', bp1.display_name)
        self.assertEqual('PIR - Test 2', bp2.display_name)
        self.assertEqual('Project 3', bp3.display_name)

    def test_create_with_project_template(self):
        template = self.project_model.create({
            'name': 'Unittest building project template',
            'building_template': True
        })

        self.task_model.create({
            'name': 'Task 1',
            'project_id': template.id
        })

        self.task_model.create({
            'name': 'Task 2',
            'project_id': template.id
        })

        building = self.building_model.create({
            'name': 'Unittest building project'
        })
        self.assertEqual(2, building.task_count)

        self.assertItemsEqual(
            ['Task 1', 'Task 2'],
            building.task_ids.mapped('name')
        )

    def test_building_template_constraint(self):
        self.project_model.create({
            'name': 'Unittest building project',
            'building_template': True
        })
        with self.assertRaises(IntegrityError):
            self.project_model.create({
                'name': 'Unittest building project 2',
                'building_template': True
            })
