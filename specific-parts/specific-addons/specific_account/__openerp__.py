# -*- coding: utf-8 -*-
# © 2016 Cyril Gaudin (Camptocamp)
# License AGPL-3.0 or later (http://www.gnu.org/licenses/agpl.html).
{
    'name': 'Specific - Account',
    'version': '9.0.1.0.0',
    'author': 'Camptocamp',
    'license': 'AGPL-3',
    'category': 'Swisslux Modules',
    'website': 'http://www.swisslux.ch',
    'images': [],
    'depends': [
        'account',
        'specific_building_project',
    ],
    'data': [
        'views/account_invoice.xml',
        'security/account_invoice.xml',
        'wizards/account_invoice_refund.xml',
    ],
    'test': [],
    'installable': True,
    'auto_install': False,
}
