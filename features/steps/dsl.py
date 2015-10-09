from ast import literal_eval
import time
import erppeek
from support.tools import puts, set_trace, model, assert_true, assert_equal
from dsl_helpers import (parse_domain,
                         build_search_domain,
                         parse_table_values,
                         parse_optional,
                         create_new_obj,
                         get_company_property
                         )




@step('/^having:?$/')
def impl_having(ctx):
    assert ctx.table, 'please supply a table of values'
    assert ctx.search_model_name, 'cannot use "having" step without a previous step setting a model'
    assert ctx.found_item, 'No record found'
    table_values = parse_table_values(ctx, ctx.search_model_name,
                                      ctx.table)
    if isinstance(ctx.found_item, dict):
        values = ctx.found_item
        values.update(table_values)
        if 'company_id' not in values and \
           hasattr(ctx, 'company_id') and \
           'company_id' in model(ctx.search_model_name).keys():
            values['company_id'] = ctx.company_id
        ctx.found_item = create_new_obj(ctx, ctx.search_model_name, values)

    else:
        ctx.found_item.write(table_values)


@step(u'I set the context to "{oe_context_string}"')
def impl(ctx, oe_context_string):
    ctx.oe_context = literal_eval(oe_context_string)




@step(u'I find a{n:optional}{active_text:optional} "{model_name}" with {domain}')
def impl(ctx, n, active_text, model_name, domain):
    # n is there for the english grammar, but not used
    assert active_text in ('', 'inactive', 'active', 'possibly inactive')
    Model = model(model_name)
    ctx.search_model_name = model_name
    oe_context = getattr(ctx, 'oe_context', None)
    values = parse_domain(domain)
    active = True
    if active_text == 'inactive':
        active = False
    elif active_text == 'possibly inactive':
        active = None
    domain = build_search_domain(ctx, model_name, values, active=active)

    if domain is None:
        ctx.found_item = None
        ctx.found_items = erppeek.RecordList(Model, [])
    else:
        ctx.found_items = Model.browse(domain, context=oe_context)
        if len(ctx.found_items) == 1:
            ctx.found_item = ctx.found_items[0]
        else:
            ctx.found_item = None


@step(u'I need a{n:optional}{active_text:optional} "{model_name}" with {domain}')
def impl(ctx, n, active_text, model_name, domain):
    # n is there for the english grammar, but not used
    assert active_text in ('', 'inactive', 'active', 'possibly inactive')
    Model = model(model_name)
    ctx.search_model_name = model_name
    values = parse_domain(domain)
    active = True
    if active_text == 'inactive':
        active = False
    elif active_text == 'possibly inactive':
        active = None
    # if the scenario specifies xmlid + other attributes in an "I
    # need" phrase then we want to look for the entry with the xmlid
    # only, and update the other attributes if we found something
    if 'xmlid' in values:
        domain = build_search_domain(ctx, model_name,
                                     {'xmlid': values['xmlid']},
                                     active=active)
    else:
        domain = build_search_domain(ctx, model_name, values, active=active)
    if domain is not None:
        ids = Model.search(domain)
    else:
        ids = []
    if not ids: # nothing found
        ctx.found_item = values
        ctx.found_items = [values]
    else:
        if len(ids) == 1:
            ctx.found_item = Model.browse(ids[0])
        else:
            ctx.found_item = None
        ctx.found_items = Model.browse(ids)
        if 'xmlid' in values and len(values) > 1:
            new_attrs = values.copy()
            del new_attrs['xmlid']
            puts('writing %s to %s' % (new_attrs, ids))
            Model.write(ids, new_attrs)



@given('I set global property named "{pname}" for model "{modelname}" and field "{fieldname}" for company with ref "{company_oid}"')
def impl(ctx, pname, modelname, fieldname, company_oid):
    get_company_property(ctx, pname, modelname, fieldname, company_oid=company_oid)

@given('I set global property named "{pname}" for model "{modelname}" and field "{fieldname}"')
def impl(ctx, pname, modelname, fieldname):
    get_company_property(ctx, pname, modelname, fieldname)

@step('the property is related to model "{modelname}" using column "{column}" and value "{value}"')
def impl(ctx, modelname, column, value):
    assert hasattr(ctx, 'ir_property')
    ir_property = ctx.ir_property
    domain = [(column, '=', value)]
    if ir_property.company_id and 'company_id' in model(modelname).fields():
        domain.append(('company_id', '=', ir_property.company_id.id))
        res = model(modelname).get(domain)
        if not res: # try again without company
            del domain[-1]
        res = model(modelname).get(domain)
    else:
        res = model(modelname).get(domain)
    assert res, "no value for %s value %s" % (column, value)
    ir_property.write({'value_reference': '%s,%s' % (modelname, res.id)})

@given('I am configuring the company with ref "{company_oid}"')
def impl(ctx, company_oid):
    c_domain = build_search_domain(ctx, 'res.company', {'xmlid': company_oid})
    company = model('res.company').get(c_domain)
    ctx.company_id = company.id

@step(u'I set "{option}" to "{value}" in "{menu}" settings menu')
def set_in_settings(ctx, option, value, menu):
    """ Define value of an option in settings by name """
    Menu = model('ir.ui.menu')
    Field = model('ir.model.fields')
    search_domain = [('module', '=', 'base'), ('name', '=', 'menu_config')]
    base_menu_config_id = model('ir.model.data').get(search_domain).res_id
    settings_menu = Menu.get(
        [('name', '=', menu),
         ('parent_id', '=', base_menu_config_id)])
    if not settings_menu and menu in ('Invoicing', 'Accounting'):
        # Try with alias name (depending on module installed)
        if menu == 'Invoicing':
            alias = 'Accounting'
        elif menu == 'Accounting':
            alias = 'Invoicing'
        settings_menu = Menu.get(
            [('name', '=', alias),
             ('parent_id', '=', base_menu_config_id)])
    assert settings_menu, "menu %s was not found" % menu
    wiz_model = settings_menu.action.res_model

    field = Field.get([('model', '=', wiz_model),
                       ('field_description', '=', option)])
    assert field
    Wiz = model(wiz_model)
    values = {}
    if wiz_model == 'account.config.settings':
        # Special call to onchange in case of account config
        company = model('res.users').browse(1).company_id
        values.update(Wiz.onchange_company_id(None, company.id)['value'])

    values[field.name] = value
    config = Wiz.create(values)

    config.execute()


@step(u'I {action} "{option}" in "{menu}" settings menu')
def enable_in_settings(ctx, action, option, menu):
    """ Enable or disable a boolean option in settings by name """
    assert action in ('enable', 'disable')
    set_in_settings(ctx, option, action == 'enable', menu)

@step('I delete it')
def impl(ctx):
    if ctx.found_item:
        ctx.found_item.unlink()

@step('I set the default value for "{modelname}"."{column}" to {value}')
def impl(ctx, modelname, column, value):
    """
    Example:
    Scenario: set default values for products, the list price is only set for company2
      Given I set the default value for "product.product"."type" to 'product'
      And I set the default value for "product.product"."cost_method" to 'average'
      Given I am configuring the company with ref "scen.company2"
      And I set the default value for "product.product"."list_price" to 12.4
    """
    if hasattr(ctx, 'company_id'):
        company_id = ctx.company_id
    else:
        company_id = False
    ir_value_obj = model('ir.values')
    value = eval(value)
    ir_value_obj.set_default(modelname, column, value, company_id=company_id)

@step('I have {num_items:d} items')
def impl(ctx, num_items):
    assert_equal(len(ctx.found_items), num_items)
