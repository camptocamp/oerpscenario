# -*- coding: utf-8 -*-
# © 2015 Yannick Vaucher (Camptocamp)
# License AGPL-3.0 or later (http://www.gnu.org/licenses/agpl.html).
{
    "name": "Building project ",
    "summary": "New type of analytic account",
    "version": "8.0.1.0.0",
    "category": "Uncategorized",
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
        "analytic",
        "crm",
    ],
    "data": [
        "views/calendar_event.xml",
        "views/res_partner.xml",
        "views/crm_lead.xml",
        "views/building_project.xml",
        "data/building_project_tag.xml",
        "data/building_project_type.xml",
    ],
    "demo": [
    ],
}
