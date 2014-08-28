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


@step(u'we assign to {users} the groups below')
def impl(ctx, users):
    # search groups by name and full name
    group_names = [row['group_name'] for row in ctx.table]
    group_names = list(set(group_names))
    group_full_names = [name for name in group_names if '/' in name]
    group_single_names = [name for name in group_names if not '/' in name]
    ModulCategory = model('ir.module.category')
    groups = []
    group_full_names_category = []
    if group_full_names:
        full_name_cond = []
        for line in group_full_names:
            categ, name = line.split('/', 1)
            categ = categ.strip()
            name = name.strip()
            category_ids = ModulCategory.search([('name', '=', categ)])
            assert category_ids, 'no category named %s' % categ
            condition = [
                    '&',
                    ('name', '=', name),
                    ('category_id', 'in', category_ids)
                ]
            # Take the category_id to build the domain
            # [
            #   ('&',('name','=','User'), ('category_id','=',40)),
            #   ('&',('name','=','User'), ('category_id','=',47)),
            # ]
            full_name_cond += condition
        num_operators = len(group_full_names) - 1
        or_operators = ['|'] * num_operators
        search_cond = or_operators + full_name_cond
        groups.extend(model('res.groups').browse(search_cond))
    if group_single_names:
        single_name_cond = [('name', 'in', group_single_names)]
        # Search for single groups
        groups.extend(model('res.groups').browse(single_name_cond))
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
