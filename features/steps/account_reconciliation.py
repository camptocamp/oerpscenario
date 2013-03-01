@given(u'with following rules')
def impl(ctx):
    assert ctx.found_item
    rule_ids = []
    for(name,) in ctx.table:
       rule = model('account.statement.completion.rule').get([('name', '=', name)])
       assert rule
       rule_ids.append(rule.id)
    ctx.found_item.write({'rule_ids': [(6, 0, rule_ids)]})
