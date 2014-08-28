import openerp
import csv
import os
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
    pool = openerp.modules.registry.RegistryManager.get(db_name)
    cr = pool.db.cursor()
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
