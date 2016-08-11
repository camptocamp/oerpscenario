# -*- coding: utf-8 -*-
# © 2016 Camptocamp SA
# License AGPL-3.0 or later (http://www.gnu.org/licenses/agpl.html).

from openerp.tests.common import TransactionCase


class TestProject(TransactionCase):

    def setUp(self):
        super(TestProject, self).setUp()

        self.department = self.env['hr.department'].create({
            'name': 'Test department',
        })

        self.env['hr.employee'].create({
            'name': 'Test employee',
            'user_id': self.env.user.id,
            'department_id': self.department.id
        })

    def test_department_id(self):
        project = self.env['project.project'].create({
            'name': 'Unittest project',
        })

        self.assertEqual(self.env.user, project.user_id)

        project.onchange_user_id()
        self.assertEqual(self.department, project.department_id)
        self.assertEqual(
            self.department, project.analytic_account_id.department_id
        )
