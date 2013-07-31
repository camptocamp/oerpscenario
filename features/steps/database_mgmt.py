from support import *

@given('the server is up and running OpenERP {version}')
def impl(ctx, version):
    db = ctx.client.db
    assert_in('server', ctx.conf.keys())
    assert_equal(db.server_version(), version)

@step('the database "{db_name}" exists')
def impl(ctx, db_name):
    assert_in(db_name, ctx.client.db.list())
    ctx.conf['db_name'] = db_name
    # puts('Hey, db exists!')

@step('user "{user}" log in with password "{password}"')
def impl(ctx, user, password):
    client = ctx.client
    db_name = ctx.conf['db_name']
    uid = client.login(user, password, database=db_name)
    assert_equal(client.user, user)
    if user == 'admin':
        assert_equal(uid, 1)
    else:
        assert_greater(uid, 1)
    # set_trace()
    # assert_true(0)

@given(u'I create database "{db_name}" with admin password "{admin_pass}"')
def impl(ctx, db_name, admin_pass):
    ctx.client.create_database(admin_pass, db_name)

@given(u'I create database "{db_name}"')
def impl(ctx, db_name):
    admin_passwd = ctx.conf.get('admin_passwd')
    assert admin_passwd
    ctx.client.create_database(admin_passwd, db_name)

@given(u'I create database from config file')
def impl(ctx):
    "Create database from config file etc/openerp.cfg"
    db_name = ctx.conf.get('db_name')
    admin_passwd = ctx.conf.get('admin_passwd')
    assert admin_passwd
    assert db_name
    demo = False
    if not ctx.conf.get('without_demo'):
        demo=True
    ctx.client.create_database(admin_passwd, db_name, demo=demo)
