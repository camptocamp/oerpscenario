# -*- coding: utf8 -*-
from openerp.tests import TransactionCase


class TestAccountAnalyticLine(TransactionCase):

    def setUp(self):
        super(TestAccountAnalyticLine, self).setUp()

        self.activity = self.env['hr.timesheet.sheet.activity'].create({
            'name': 'Test activity',
        })

        self.account = self.env["account.analytic.account"].create({
            'name': 'Test account',
            'company_id': self.env.user.company_id.id
        })

        self.account_line = self.env["account.analytic.line"].create({
            'account_id': self.account.id,
            'user_id': self.env.user.id,
            'activity_id': self.activity.id,
            'name': '',
        })

    def test_user_department_id(self):
        self.assertEqual(False, self.account_line.user_department_id.id)

        department = self.env['hr.department'].create({
            'name': 'Test department',
        })

        self.env['hr.employee'].create({
            'name': 'Test employee',
            'user_id': self.env.user.id,
            'department_id': department.id
        })

        self.account_line.refresh()
        self.assertEqual(department.id,
                         self.account_line.user_department_id.id)

    def test_name(self):
        self.assertEqual("", self.account_line.name)
        self.account_line.change_activity_id()
        self.assertEqual("Test activity", self.account_line.name)

        # Name is not override
        other_activity = self.env['hr.timesheet.sheet.activity'].create({
            'name': 'Other activity',
        })

        self.account_line.activity_id = other_activity
        self.account_line.change_activity_id()
        self.assertEqual("Test activity", self.account_line.name)
