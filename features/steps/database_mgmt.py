import openerp
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


def _create_database(ctx, admin_passwd, db_name, demo=False,
                     user_password='admin', raise_if_exists=True):
    try:
        ctx.client.create_database(
                admin_passwd, db_name, demo=demo,
                user_password=user_password)
    except openerp.service.db.DatabaseExists:
        if raise_if_exists:
            raise
        else:
            puts("Database %s already exists" % db_name)


@given(u'I{find_or}create database "{db_name}" with admin password "{admin_pass}"')
def impl(ctx, find_or, db_name, admin_pass):
    """Create database using the given name and a custom admin password.

    The phrase::

        I create database "xxx" with admin password "abc"

    will raise an error if the database xxx already exists, while::

        I find or create database "xxx" with admin password "abc"

    will skip the creation if it already exists.
    """
    raise_if_exists = find_or.strip() != 'find or'
    _create_database(ctx, admin_pass, db_name, raise_if_exists=raise_if_exists)


@given(u'I{find_or}create database "{db_name}"')
def impl(ctx, db_name, find_or):
    """Create database using the given name.

    The admin password is read from the config file.

    The phrase::

        I create database "xxx"

    will raise an error if the database xxx already exists, while::

        I find or create database "xxx"

    will skip the creation if it already exists.
    """
    admin_passwd = ctx.conf.get('admin_passwd') # empty for unix sockets
    raise_if_exists = find_or.strip() != 'find or'
    _create_database(ctx, admin_passwd, db_name,
                     raise_if_exists=raise_if_exists)


@given(u'I{find_or}create database from config file')
def impl(ctx, find_or):
    """Create database from config file etc/openerp.cfg

    The phrase::

        I create database from config file

    will raise an error if the database already exists, while::

        I find or create database from config file

    will skip the creation if it already exists.
    """
    db_name = ctx.conf.get('db_name')
    admin_passwd = ctx.conf.get('admin_passwd') # empty for unix sockets
    admin_login_password = ctx.conf.get('admin_login_password')
    assert db_name
    demo = False
    if not ctx.conf['openerp_config'].get('without_demo'):
        demo = True
    raise_if_exists = find_or.strip() != 'find or'
    _create_database(ctx, admin_passwd, db_name, demo=demo,
                     user_password=admin_login_password,
                     raise_if_exists=raise_if_exists)
