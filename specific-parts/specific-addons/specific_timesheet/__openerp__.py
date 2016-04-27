# -*- coding: utf-8 -*-
# © 2016 Cyril Gaudin (Camptocamp)
# License AGPL-3.0 or later (http://www.gnu.org/licenses/agpl.html).
{
    'name': 'Specific - Timesheet',
    'version': '9.0.1.0.0',
    'author': 'Camptocamp',
    'license': 'AGPL-3',
    'category': 'Swisslux Modules',
    'website': 'http://www.swisslux.ch',
    'images': [],
    'depends': [
        'project_timesheet',
        'hr_timesheet_sheet',
    ],
    'data': [
        'views/account_analytic_line.xml',
        'views/hr_timesheet_sheet.xml',
        'views/project_project.xml',
    ],
    'test': [],
    'installable': True,
    'auto_install': False,
}
