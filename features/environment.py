# -*- coding: utf-8 -*-
# USE: BEHAVE_DEBUG_ON_ERROR=yes     (to enable debug-on-error)
import os
import sys
from distutils.util import strtobool as _bool
import ConfigParser
import erppeek
from support import tools, behave_better

try:
    import openerp
    OPENERP_IN_PATH = True
except ImportError:
    OPENERP_IN_PATH = False


__all__ = []
OPENERP_ARGS = [
    '-c', 'etc/openerp.cfg',
    '--logfile=var/log/behave-stdout.log',
    ]

# stolen from https://pythonhosted.org/behave/tutorial.html
BEHAVE_DEBUG_ON_ERROR = _bool(os.environ.get("BEHAVE_DEBUG_ON_ERROR", "no"))

# Print readable 'Fault' errors
tools.patch_traceback()
# Some monkey patches to enhance Behave
behave_better.patch_all()


def parse_openerp_config(config_path):
    """Parse odoo configuration file given in entry
    :param config_path: config path string
    :type path: str

    :return: a configuration dict
    :rtype: dict
    """
    server_config = ConfigParser.ConfigParser()
    server_config.read(config_path)
    if not server_config.has_section('options'):
        raise ValueError(
            'Configuration file is missing the options section'
        )
    options = server_config._sections['options']
    server = options.get('server_url', 'http://localhost')
    port = options.get('xmlrpc_port', '8069')
    conf = {
        'server': "%s:%s" % (server, port),
    }
    conf.update(options)

    return conf


def before_all(ctx):
    conf = None
    server = None
    openerp_args = OPENERP_ARGS
    if hasattr(ctx.config, 'server_config') and ctx.config.server_config:
        conf = parse_openerp_config(ctx.config.server_config)
        server = conf['server']
    elif OPENERP_IN_PATH:
        if hasattr(ctx.config, 'server_args') and ctx.config.server_args:
            openerp_args = ctx.config.server_args.split('|')
        if erppeek.__version__ < '1.6':
            server = erppeek.start_openerp_services(' '.join(openerp_args))
        else:
            server = erppeek.start_odoo_services(openerp_args)
        database = server.tools.config['db_name']
        conf = {'server': server,
                'admin_passwd': server.tools.config['admin_passwd'] or 'admin',
                }
        conf.update(server.tools.config.options)
    else:
        raise ValueError(
            'No Odoo/OpenERP configuration file passed '
            'while odoo or openerp is not available in sys path. '
            'Please provide a value for the --server-config option'
        )

    def _output_write(text):
        for stream in ctx.config.outputs:
            stream.open().write(text)

    assert (conf and server)
    ctx._output_write = _output_write
    ctx._is_context = True
    ctx.client = erppeek.Client(server, verbose=ctx.config.verbose)
    ctx.conf = conf


def before_feature(ctx, feature):
    ctx.data = {}


# Work around https://github.com/behave/behave/issues/145
def before_scenario(ctx, scenario):
    ctx.oe_context = {}
    if not hasattr(ctx, 'data'):
        ctx.data = {}
    # do not login if tag `no_login` is present
    # this allow to do database creation and sql requests
    # before trying to login in Odoo
    if not ctx.client.user and 'no_login' not in scenario.tags:
        database = ctx.conf['db_name']
        config = ctx.conf
        # We try to manage default login
        # even if there is a sentence to log a given user
        # Just add options.admin_login_password in your buildout to log from
        # config
        admin_login_password = config.get('admin_login_password', 'admin')
        admin_login = config.get('admin_login', 'admin')
        ctx.client.login(admin_login, admin_login_password, database=database)


def before_step(ctx, step):
    ctx._messages = []
    # Extra cleanup (should be fixed upstream?)
    ctx.table = None
    ctx.text = None


def after_step(ctx, laststep):
    if ctx._messages:
        # Flush the messages collected with puts(...)
        for item in ctx._messages:
            for line in str(item).splitlines():
                ctx._output_write(u'      %s\n' % (line,))
        for stream in ctx.config.outputs:
            stream.open().flush()

    # stolen from https://pythonhosted.org/behave/tutorial.html
    if BEHAVE_DEBUG_ON_ERROR and laststep.status == 'failed':
        # Enter the interactive debugger
        tools.set_trace()
