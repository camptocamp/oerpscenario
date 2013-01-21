from support import model, assert_equal, set_trace, puts
import datetime

@given('I create monthly periods on the fiscal year with reference "{fy_ref}"')
def impl(ctx, fy_ref):
    assert '.' in fy_ref, "please use the full reference (e.g. scenario.%s)" % fy_ref
    module, xmlid = fy_ref.split('.', 1)
    _model, id = model('ir.model.data').get_object_reference(module, xmlid)
    assert _model == 'account.fiscalyear'
    fy = model('account.fiscalyear').get(id)
    fy.read('period_ids')
    if not fy.period_ids:
        model('account.fiscalyear').create_period([fy.id], {}, 1)


@given('I set the following currency rates')
def impl(ctx):
    for row in ctx.table:
        date = datetime.date.today().strftime(row['date'])
        currency = model('res.currency').get([('name', '=', row['currency'])])
        type = model('res.currency.rate.type').get([('name', '=', row['type'])])
        curr_rate = model('res.currency.rate').browse([('name', '=', date), ('currency_id', '=', currency.id)])
        if not curr_rate:
            puts('creating new rate')
            values = {'name': date, 'currency_id': currency.id, 'rate': row['rate'],'currency_rate_type_id': type.id}
            model('res.currency.rate').create(values)
        else:
            curr_rate[0].rate = row["rate"]



@given('I allow cancelling entries on all journals')
def impl(ctx):
    for jrn in model('account.journal').browse([]):
        jrn.write({'update_posted': True})

@given(u'I have the module account installed')
def impl(ctx):
    assert model('ir.module.module').get(['name = account', 'state = installed'])
@given(u'no account set for company "{company_name}"')
def impl(ctx, company_name):
    company = model('res.company').get([('name', '=', company_name)])
    assert company
    assert len(model('account.account').search([("company_id", "=", company.id)])) == 0

@given(u'I want to generate account chart from chart template named "{name}" with "{digits}" digits for company "{company_name}"')
def impl(ctx, name, digits, company_name):
    template = model('account.chart.template').get([("name", "=", name)])
    assert template
    root_account = template.account_root_id
    assert root_account
    company = model('res.company').get([('name', '=', company_name)])
    assert company
    configuration_wizard = model('wizard.multi.charts.accounts').create({'code_digits': digits,
                                                                         'chart_template_id': template.id,
                                                                         'company_id': company.id})

    vals = configuration_wizard.onchange_chart_template_id(template.id)
    configuration_wizard.write(vals['value'])
    vals = configuration_wizard.onchange_company_id(company.id)
    configuration_wizard.write(vals['value'])
    configuration_wizard.execute()

@when(u'I generate the chart')
def impl(ctx):
   pass

@then(u'accounts should be available for company "{company_name}"')
def impl(context, company_name):
    company = model('res.company').get([('name', '=', company_name)])
    assert company
    assert len(model('account.account').search([("company_id", "=", company.id)])) > 0
