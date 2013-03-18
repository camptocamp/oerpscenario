from ast import literal_eval
import time
from support.tools import puts, set_trace, model


def parse_domain(domain):
    rv = {}
    if domain[-1:] == ':':
        domain = domain[:-1]
    for term in domain.split(' and '):
        key, value = term.split(None, 1)
        if key[-1:] == ':':
            key = key[:-1]
        try:
            value = literal_eval(value)
        except Exception:
            # Interpret the value as a string
            pass
        rv[key.lstrip()] = value
    if 'oid' in rv:
        rv['xmlid'] = rv.pop('oid')
    return rv


def build_search_domain(ctx, obj, values):
    values = values.copy()
    xml_id = values.pop('xmlid', None)
    res_id = values.pop('id', None)
    if xml_id:
        module, name = xml_id.split('.')
        search_domain = [('module', '=', module), ('name', '=', name)]
        records = model('ir.model.data').browse(search_domain)
        if not records:
            return None
        res = records[0].read('model res_id')
        assert_equal(res['model'], obj)
        if res_id:
            assert_equal(res_id, res['res_id'])
        else:
            res_id = res['res_id']
    search_domain = [(key, '=', value) for (key, value) in values.items()]
    if res_id:
        search_domain = [('id', '=', res_id)] + search_domain
    if 'company_id' in ctx.data and 'company_id' in model(obj).fields():
        search_domain.append(('company_id', '=', ctx.data['company_id']))
    return search_domain


def parse_table_values(ctx, obj, table):
    fields = model(obj).fields()
    if hasattr(table, 'headings'):
        # if we have a real table, ensure it has 2 columns
        # otherwise, we will just fail during iteration
        assert_equal(len(table.headings), 2)
    assert_true(fields)
    res = {}
    for (key, value) in table:
        add_mode = False
        field_type = fields[key]['type']
        if field_type in ('char', 'text'):
            pass
        elif value.lower() in ('false', '0', 'no', 'f', 'n', 'nil'):
            value = False
        elif field_type in ('many2one', 'one2many', 'many2many'):
            relation = fields[key]['relation']
            if value.startswith('add all by '):
                add_mode = True
                value = value[4:] # fall back on "all by xxx" below
            else:
                add_mode = False
            if value.startswith('by ') or value.startswith('all by '):
                value = value.split('by ', 1)[1]
                values = parse_domain(value)
                search_domain = build_search_domain(ctx, relation, values)
                if search_domain:
                    value = model(relation).browse(search_domain).id
                else:
                    value = []
                if add_mode:
                    value = res.get(key, []) + value
            else:
                method = getattr(model(relation), value)
                value = method()
            if value and field_type == 'many2one':
                assert_equal(len(value), 1, msg="more than item found for %s" % key)
                value = value[0]
        elif field_type == 'integer':
            value = int(value)
        elif field_type == 'float':
            value = float(value)
        elif field_type == 'boolean':
            value = True
        elif field_type in ('date', 'datetime') and '%' in value:
            value = time.strftime(value)
        res[key] = value
    return res


@step('/^having:?$/')
def impl_having(ctx):
    assert ctx.table, 'please supply a table of values'
    assert ctx.search_model_name, 'cannot use "having" step without a previous step setting a model'
    table_values = parse_table_values(ctx, ctx.search_model_name,
                                      ctx.table)
    if isinstance(ctx.found_item, dict):
        values = ctx.found_item
        values.update(table_values)
        if 'company_id' not in values and \
           'company_id' in ctx.data and \
           'company_id' in model(ctx.search_model_name).keys():
            values['company_id'] = ctx.data['company_id']
        ctx.found_item = create_new_obj(ctx, ctx.search_model_name, values)

    else:
        ctx.found_item.write(table_values)


def create_new_obj(ctx, model_name, values):
    values = values.copy()
    xmlid = values.pop('xmlid', None)
    record = model(model_name).create(values)
    if xmlid is not None:
        ModelData = model('ir.model.data')
        module, xmlid = xmlid.split('.', 1)
        _model_data = ModelData.create({'name': xmlid,
                                       'model': model_name,
                                       'res_id': record.id,
                                       'module': module,
                                       })
    return record


@step(u'I find a "{model_name}" with {domain}')
def impl(ctx, model_name, domain):
    Model = model(model_name)
    ctx.search_model_name = model_name
    values = parse_domain(domain)
    domain = build_search_domain(ctx, model_name, values)
    if domain is not None:
        ids = Model.search(domain)
    else:
        ids = []
    if len(ids) == 1:
        ctx.found_item = Model.browse(ids[0])
    else:
        ctx.found_item = None
    ctx.found_items = Model.browse(ids)


@step(u'I need a "{model_name}" with {domain}')
def impl(ctx, model_name, domain):
    Model = model(model_name)
    ctx.search_model_name = model_name
    values = parse_domain(domain)
    # if the scenario specifies xmlid + other attributes in an "I
    # need" phrase then we want to look for the entry with the xmlid
    # only, and update the other attributes if we found something
    if 'xmlid' in values:
        domain = build_search_domain(ctx, model_name, {'xmlid': values['xmlid']})
    else:
        domain = build_search_domain(ctx, model_name, values)
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


def get_company_property(ctx, pname, modelname, fieldname, company_oid=None):
    company = None
    if company_oid:
        c_domain = build_search_domain(ctx, 'res.company', {'xmlid': company_oid})
        company = model('res.company').get(c_domain)
        assert company
    field = model('ir.model.fields').get([('name', '=', fieldname), ('model', '=', modelname)])
    assert field is not None, 'no field %s in model %s' % (fieldname, modelname)
    domain = [('name', '=', pname),
              ('fields_id', '=', field.id),
              ('res_id', '=', False)]
    if company:
        domain.append(('company_id', '=', company.id))
    ir_property = model('ir.property').get(domain)
    if ir_property is None:
        ir_property = model('ir.property').create({'fields_id': field.id,
                                                   'name': pname,
                                                   'res_id': False,
                                                   'type': 'many2one'})
        if company:
            ir_property.write({'company_id': company.id})
    ctx.ir_property = ir_property

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
    if ir_property.company_id:
        domain.append(('company_id', '=', ir_property.company_id.id))
    res = model(modelname).get(domain)
    assert res, "no value for %s value %s" % (column, value)
    ir_property.write({'value_reference': '%s,%s' % (modelname, res.id)})

@given('I am configuring the company with ref "{company_oid}"')
def impl(ctx, company_oid):
    c_domain = build_search_domain(ctx, 'res.company', {'xmlid': company_oid})
    company = model('res.company').get(c_domain)
    ctx.data['company_id'] = company.id
