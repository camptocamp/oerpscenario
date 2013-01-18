from support import model, assert_equal, set_trace, puts

@given(u'there is a journal with {field} "{value}" from company "{company_name}"')
def impl(ctx, field, value, company_name):
    company = model('res.company').get([('name', '=', company_name)])
    assert company
    journal = model('account.journal').get([(field, '=', value), ('company_id', '=', company.id)])
    assert journal
    ctx.found_item = journal
