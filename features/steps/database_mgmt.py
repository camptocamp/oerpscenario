from support import *
@given('the server is on')
def impl(ctx):
    db = ctx.client.db
    assert_in('server', ctx.conf.keys())
    assert_equal(db.server_version(), '7.0')

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
