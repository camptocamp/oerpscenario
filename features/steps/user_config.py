from support import model, assert_equal, puts, set_trace

@given('we select all users')
def impl(ctx):
    ctx.users = model('res.users').browse([('login', '!=', 'admin')])

@given('we select admin user')
def impl(ctx):
    ctx.found_item = model('res.users').browse([('login', '=', 'admin')])

@step('we select users below')
def impl(ctx):
    logins = [row['login'] for row in ctx.table]
    ctx.found_items = model('res.users').browse([('login', 'in', logins)])
    assert_equal(len(ctx.found_items), len(logins))

def assign_groups(user, groups):
    group_ids = [g.id for g in groups]
    curr_groups= [g.id for g in user.groups_id]
    user.groups_id = list(set(group_ids + curr_groups))

@step('we assign all groups to the users')
def impl(ctx):
    groups = model('res.groups').browse([])
    for user in ctx.found_items:
        assign_groups(user, groups)


def search_groups(names):
    """ Search groups by name and full name """
    names = list(set(names))
    group_full_names = [name for name in names if '/' in name]
    group_single_names = [name for name in names if not '/' in name]
    ModuleCategory = model('ir.module.category')
    groups = []
    if group_full_names:
        full_name_cond = []
        for line in group_full_names:
            categ, name = line.split('/', 1)
            categ = categ.strip()
            name = name.strip()
            category_ids = ModuleCategory.search([('name', '=', categ)])
            assert category_ids, 'no category named %s' % categ
            condition = [
                    '&',
                    ('name', '=', name),
                    ('category_id', 'in', category_ids)
                ]
            full_name_cond += condition
        num_operators = len(group_full_names) - 1
        or_operators = ['|'] * num_operators
        search_cond = or_operators + full_name_cond
        groups.extend(model('res.groups').browse(search_cond))
    if group_single_names:
        single_name_cond = [('name', 'in', group_single_names)]
        # Search for single groups
        groups.extend(model('res.groups').browse(single_name_cond))
    return groups


@step(u'we set on the group "{group_name}" the inherited groups below')
def impl(ctx, group_name):
    """ Followed by a table with a column 'group_name' """
    # search groups by name and full name
    group = search_groups([group_name])
    assert len(group) == 1,\
        'Searched one group named %s, found: %s' % (group_name, group)
    group = group[0]
    groups = search_groups([row['group_name'] for row in ctx.table])
    current_groups = [g.id for g in group.implied_ids]
    group_ids = [g.id for g in groups]
    group.implied_ids = list(set(group_ids + current_groups))


@step(u'we assign to {users} the groups below')
def impl(ctx, users):
    """ Followed by a table with a column 'group_name' """
    # search groups by name and full name
    groups = search_groups([row['group_name'] for row in ctx.table])
    #assert_equal(len(groups), len(group_names))
    assert users in ('user', 'users')
    if users == "users":
        for user in ctx.found_items:
            assign_groups(user, groups)
    if users == "user":
        assign_groups(ctx.found_item, groups)

@step('we activate the extended view on the users')
def impl(ctx):
    for user in ctx.found_items:
        user.view = 'extended'
