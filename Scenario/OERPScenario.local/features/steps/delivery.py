# -*- coding: utf-8 -*-
import logging
from support.tools import model

logger = logging.getLogger('openerp.behave')


@given(u'I update postlogistics services')
def update_postlogistics_services(ctx):
    """
    Update postlogistics services to create or update
    delivery carrier options by calling the settings transient model
    """
    cp_id = getattr(ctx, 'company_id')
    company = model('res.company').get(cp_id)
    assert company

    conf_wizard = model('postlogistics.config.settings').create(
        {'company_id': company.id})

    # company onchange raises TypeError with number of arguments
    # Thus we copy config by hand

    label_layout = company.postlogistics_default_label_layout
    output_format = company.postlogistics_default_output_format
    resolution = company.postlogistics_default_resolution

    vals = {
        'username': company.postlogistics_username,
        'password': company.postlogistics_password,
        'logo': company.postlogistics_logo,
        'office': company.postlogistics_office,
        'default_label_layout': label_layout,
        'default_output_format': output_format,
        'default_resolution': resolution,
    }
    conf_wizard.write(vals)
    conf_wizard.update_postlogistics_options()
