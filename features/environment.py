# -*- coding: utf-8 -*-
# USE: BEHAVE_DEBUG_ON_ERROR=yes     (to enable debug-on-error)
import os
from distutils.util import strtobool as _bool

import erppeek
from support import tools, behave_better

__all__ = []
OPENERP_ARGS = [
    '-c', os.environ.get('OERPSCENARIO_ODOO_CONFIG') or 'etc/openerp.cfg',
    '--logfile=var/log/behave-stdout.log',
    ]

# stolen from https://pythonhosted.org/behave/tutorial.html
BEHAVE_DEBUG_ON_ERROR = _bool(os.environ.get("BEHAVE_DEBUG_ON_ERROR", "no"))

# Print readable 'Fault' errors
tools.patch_traceback()
# Some monkey patches to enhance Behave
behave_better.patch_all()


def before_all(ctx):
    if erppeek.__version__ < '1.6':
        server = erppeek.start_openerp_services(' '.join(OPENERP_ARGS))
    else:
        server = erppeek.start_odoo_services(OPENERP_ARGS)
    database = server.tools.config['db_name']

    def _output_write(text):
        for stream in ctx.config.outputs:
            stream.open().write(text)
    ctx._output_write = _output_write
    ctx._is_context = True
    ctx.client = erppeek.Client(server, verbose=ctx.config.verbose)
    ctx.conf = {
        'server': server,
        'admin_passwd': server.tools.config['admin_passwd'],
        'admin_login_password': server.tools.config.get(
            'admin_login_password', 'admin'),
        'db_name': database,
        'openerp_config': server.tools.config,
        }


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
        # We try to manage default login
        # even if there is a sentence to log a given user
        # Just add options.admin_login_password in your buildout to log from
        # config
        database = ctx.conf['db_name']
        user_password = ctx.conf['admin_login_password']
        ctx.client.login('admin', user_password, database=database)


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
