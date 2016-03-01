# -*- coding: utf-8 -*-
# © 2015 Laurent Meuwly (Camptocamp)
# License AGPL-3.0 or later (http://www.gnu.org/licenses/agpl.html).
{
    "name": "HR extension",
    "summary": "Some HR extensions",
    "version": "1.0",
    "category": "HR",
    "website": "https://odoo-community.org/",
    "author": "Camptocamp",
    "license": "AGPL-3",
    "application": False,
    "installable": True,
    "external_dependencies": {
        "python": [],
        "bin": [],
    },
    "depends": [
        "hr",
    ],
    "data": [
        "views/hr_department.xml",
    ],
    "demo": [
    ],
}
