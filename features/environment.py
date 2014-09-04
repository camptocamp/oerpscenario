# -*- coding: utf-8 -*-
import erppeek
from support import tools, behave_better

__all__ = []
OPENERP_ARGS = [
    '-c', 'etc/openerp.cfg',
    '--logfile=var/log/behave-stdout.log',
    ]

# Print readable 'Fault' errors
tools.patch_traceback()
# Some monkey patches to enhance Behave
behave_better.patch_all()


def before_all(ctx):
    if erppeek.__version__ < '1.6b1':
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
    ctx.conf = {'server': server,
                'admin_passwd': server.tools.config['admin_passwd'],
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
        server = ctx.conf['server']
        database = ctx.conf['db_name']
        config = server.tools.config
        # We try to manage default login
        # even if there is a sentence to log a given user
        # Just add options.admin_login_password in your buildout to log from
        # config
        admin_login_password = config.get('admin_login_password', 'admin')
        ctx.client.login('admin', admin_login_password, database=database)


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
    if laststep.status == 'failed' and ctx.config.stop:
        # Enter the interactive debugger
        tools.set_trace()
