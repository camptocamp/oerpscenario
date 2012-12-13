from support import model, assert_equal

@given('we select all users')
def impl(ctx):
    ctx.users = model('res.users').browse([('login', '!=', 'admin')])

@given('we select admin user')
def impl(ctx):
    ctx.users = model('res.users').browse([('login', '=', 'admin')])

@step('we select users below')
def impl(ctx):
    logins = [row['login'] for row in ctx.table]
    ctx.users = model('res.users').browse([('login', 'in', logins)])
    assert_equal(len(ctx.users), len(logins))


def assign_groups(user, groups):
    group_ids = [g.id for g in groups]
    curr_groups= [g.id for g in user.groups_id]
    user.groups_id = list(set(group_ids + curr_groups))
    
@step('we assign all groups to the users')
def impl(ctx):
    groups = model('res.groups').browse([])
    for user in ctx.users:
        assign_groups(user, groups)

@step('we assign to the users the groups below')
def impl(ctx):
    group_names = [row['group_name'] for row in ctx.table]
    groups = model('res.groups').browse([('name', 'in', group_names)])
    assert_equal(len(groups), len(group_names))
    for user in ctx.users:
        assign_groups(user, groups)


@step('we activate the extended view on the users')
def impl(ctx):
    for user in ctx.users:
        user.view = 'extended'
