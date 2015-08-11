# -*- coding: utf-8 -*-
from support import model
import socket


def _create_or_update_param(key, value):
    Params = model('ir.config_parameter')
    ids = Params.search([('key', '=', key)])
    if ids:
        Params.write(ids, {'key': key, 'value': value})
    else:
        Params.create({'key': key, 'value': value})


@step('I freeze web.base.url')
def impl(ctx):
    _create_or_update_param('web.base.url.freeze', 'True')

@step('I update web.base.url with server settings')
def impl(ctx):
    config = ctx.conf['openerp_config']
    port = config['xmlrpc_port']
    server_ip = socket.gethostbyname(socket.gethostname())
    config_param = 'http://%s:%s' % (server_ip, port)
    _create_or_update_param('web.base.url', config_param)

@step('I update web.base.url with url "{url}" and port "{port}"')
def impl(ctx, url, port):
    config_param = 'http://%s:%s' % (url, port)
    _create_or_update_param('web.base.url', config_param)

@step('I update web.base.url with full url "{url}"')
def impl(ctx, url, port):
    _create_or_update_param('web.base.url', url)
