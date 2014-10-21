import openerp
import csv
import os
import os.path as osp
import datetime as dt
import subprocess
from support import *

@given('I execute the Python commands')
def impl(ctx):
    assert_true(ctx.text)
    env = globals().copy()
    env['client'] = ctx.client
    exec ctx.text in env


@given('I execute the SQL commands')
def impl(ctx):
    assert_true(ctx.text)
    openerp = ctx.conf['server']
    db_name = ctx.conf['db_name']
    if openerp.release.version_info < (8,):
        pool = openerp.modules.registry.RegistryManager.get(db_name)
        cr = pool.db.cursor()
    else:
        registry = openerp.modules.registry.RegistryManager.new(db_name)
        cr = registry.cursor()
    try:
        cr.autocommit(True)
        for command in ctx.text.split(';'):
            sql = command.strip()
            if sql:
                cr.execute(sql)
                puts(cr.statusmessage)
        try:
            ctx.data['return'] = cr.fetchall()
        except Exception:
            # ProgrammingError: no results to fetch
            ctx.data['return'] = []
    finally:
        cr.close()


# TODO REFACTOR and add CSV options support
@given('"{model_name}" is imported from CSV "{csvfile}" using delimiter "{sep}"')
def impl(ctx, model_name, csvfile, sep=","):
    tmp_path = ctx.feature.filename.split(os.path.sep)
    tmp_path = tmp_path[: tmp_path.index('features')] + ['data', csvfile]
    tmp_path = [str(x) for x in tmp_path]
    path = os.path.join(*tmp_path)
    assert os.path.exists(path)
    data = csv.reader(open(path, 'rb'), delimiter=str(sep))
    head = data.next()
    # generator does not work
    values = [x for x in data]
    model(model_name).load(head, values)

@step(u'I back up the database to "{dump_directory}"')
def impl(ctx, dump_directory):
    db_name = ctx.conf.get('db_name')
    if not osp.isdir(dump_directory):
        puts("Invalid Directory")
        raise Exception ('Invalid Directory')
    filename = osp.join(dump_directory,
                        "%s_%s.dump" % (db_name,
                                        dt.datetime.now().strftime('%Y%m%d_%H%M%S'))
                            )
    cmd = ['pg_dump', '--no-owner','--compress=9','--format=c',
           '--file', filename.encode('utf-8')]
    if ctx.conf.get('db_user'):
        cmd += ['--username', ctx.conf.get('db_user')]
    if ctx.conf.get('db_host'):
        cmd += ['--host', ctx.conf.get('db_host')]
    if ctx.conf.get('db_port'):
        cmd += ['--port', str(ctx.conf.get('db_port'))]
    cmd.append(db_name)
    env = os.environ.copy()
    if ctx.conf.get('db_password'):
        env['PGPASSWORD'] = ctx.conf.get('db_password')
    try:
        output = subprocess.check_call(cmd, env=env)
    except subprocess.CalledProcessError, exc:
        raise Exception ("Subprocess return %s" % (output))
