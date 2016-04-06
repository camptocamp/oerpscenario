# -*- coding: utf-8 -*-
# © 2016, Denis Leemann (Camptocamp), Cyril Gaudin (Camptocamp)
# License AGPL-3.0 or later (http://www.gnu.org/licenses/agpl.html).

{
    'name': 'HR Timesheet Department Activities',
    'version': '1.0',
    'author': 'Camptocamp',
    'website': 'http://www.camptocamp.com',
    'license': 'AGPL-3',
    'category': 'HR',
    'depends': [
        'analytic_department',
        'hr_timesheet_sheet',
    ],
    'data': [
        'security/ir.model.access.csv',
        'views/account_activity_line.xml',
        'views/hr_department.xml',
        'views/hr_timesheet_sheet.xml',
        'views/hr_timesheet_sheet_activity.xml',
    ],
    'installable': True,
}
