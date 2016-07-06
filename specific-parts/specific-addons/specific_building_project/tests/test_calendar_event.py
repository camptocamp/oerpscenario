# -*- coding: utf-8 -*-
# © 2016 Camptocamp SA
# License AGPL-3.0 or later (http://www.gnu.org/licenses/agpl.html).

from openerp import fields
from openerp.tests.common import TransactionCase


class TestCalendarEvent(TransactionCase):

    def test_building_project_id(self):
        project = self.env['building.project'].create({
            'name': 'Unittest project'
        })
        lead = self.env['crm.lead'].create({
            'name': 'Unittest opportunity',
            'type': 'opportunity',
            'building_project_id': project.id
        })
        event = self.env['calendar.event'].create({
            'name': 'Unittest event',
            'opportunity_id': lead.id,
            'start': fields.Datetime.now(),
            'stop': fields.Datetime.now(),
        })

        self.assertEqual(project, event.building_project_id)

        # Change the lead building projecr
        project2 = self.env['building.project'].create({
            'name': 'Unittest other project'
        })

        lead.building_project_id = project2
        self.assertEqual(project2, event.building_project_id)

        # Remove opportunity on event
        event.opportunity_id = False
        self.assertFalse(event.building_project_id)
