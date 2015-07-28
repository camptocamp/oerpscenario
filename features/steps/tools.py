import csv
import os
import os.path as osp
import datetime as dt
import subprocess
from support import *
from support.tools import ref, get_cursor_from_context


@given('I execute the Python commands')
def impl_execute_python(ctx):
    assert_true(ctx.text)
    env = globals().copy()
    env['client'] = ctx.client
    exec ctx.text in env


@given('I execute the SQL commands')
def impl_execute_sql(ctx):
    assert_true(ctx.text)

    cr = get_cursor_from_context(ctx)

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


def str2bool(s):
    if s in ('True', 'true'):
        return True
    elif s in ('False', 'false'):
        return False
    else:
        raise ValueError("str2bool(%r)" % s)


@given('"{model_name}" is imported from CSV "{csvfile}" using delimiter "{sep}"')
def impl_import_csv_with_delimiter(ctx, model_name, csvfile, sep=","):
    import_csv_with_options(ctx, model_name, csvfile,
                            options={'delimiter': sep})


@given('"{model_name}" is imported from CSV "{csvfile}" with the following options')
def impl_import_csv_with_options(ctx, model_name, csvfile):
    assert ctx.table.headings == ['name', 'value']
    options = dict(ctx.table.rows)
    import_csv_with_options(ctx, model_name, csvfile, options=options)


def preprocess_data(ctx, model_name, header, data):
    if model_name == 'res.partner':
        pass
    if model_name == 'res.users':
        pass
    return header, data


def import_csv_with_options(ctx, model_name, csvfile, options=None):
    """ import csv with options

    * handle special case to load "res.users" faster
    by setting `no_reset_password=True` in odoo context

    * currently supported options:
      * bulk={true|false}   load data in bulk mode (need a patch to odoo)
      * strict={true|false} verify that all rows are loaded
      * delimiter=","       choose CSV delimiter
    """

    tmp_path = ctx.feature.filename.split(os.path.sep)
    tmp_path = tmp_path[: tmp_path.index('features')] + ['data', csvfile]
    tmp_path = [str(x) for x in tmp_path]
    path = os.path.join(*tmp_path)
    assert os.path.exists(path)
    sep = options.get('delimiter', ',')
    strict = str2bool(options.get('strict', 'false'))

    data = csv.reader(open(path, 'rb'), delimiter=str(sep))
    head = data.next()
    values = list(data)

    context = ctx.oe_context
    ctx.loaded_objets = None

    if str2bool(options.get('preprocess_data', 'false')):
        head, values = preprocess_data(ctx, model_name, head, values)

    context = dict(context or {}, no_reset_password=True)
    if options.get('bulk') in ('True', 'true'):
        context = dict(context or {}, bulk_mode=True)

    result = model(model_name).load(head, values, context)

    ids = result['ids']

    if not ids:
        messages = '\n'.join('- %s' % msg for msg in result['messages'])
        raise Exception("Failed to load file '%s' "
                        "in '%s'. Details:\n%s" %
                        (csvfile, model_name, messages))

    elif strict and len(values) != len(ids):
        raise Exception("Loaded only %d of %d rows" % (len(ids),
                                                       len(values)))
    ctx.loaded_objets = (model_name, ids)


@step(u'I tag the imported users with "{xmlid}"')
def tag_user_partners(ctx, xmlid):
    model_name, ids = ctx.loaded_objets
    obj = ref(xmlid)
    if model_name == 'res.users':
        partners = model(model_name).browse(ids).partner_id
    elif model_name == 'res.partner':
        partners = model(model_name).browse(ids)
    partners.write({'category_id': [obj.id]})


@step(u'I back up the database to "{dump_directory}"')
def impl_backup_database(ctx, dump_directory):
    db_name = ctx.conf.get('db_name')
    if not osp.isdir(dump_directory):
        puts("Invalid Directory")
        raise Exception('Invalid Directory')
    filename = osp.join(dump_directory,
                        "%s_%s.dump" %
                        (db_name,
                         dt.datetime.now().strftime('%Y%m%d_%H%M%S'))
                        )
    cmd = ['pg_dump', '--no-owner', '--compress=9',
           '--format=c', '--file', filename.encode('utf-8')]
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
    except subprocess.CalledProcessError:
        raise Exception("Subprocess return %s" % (output))
