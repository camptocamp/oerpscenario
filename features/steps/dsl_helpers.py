'''
helper function for dsl manipulation
'''
from functools import wraps
from behave.matchers import register_type
from support import *

def parse_optional(text):
    return text.strip()
# https://pypi.python.org/pypi/parse#custom-type-conversions
parse_optional.pattern = r'\s?\w*\s?'

register_type(optional=parse_optional)


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


def build_search_domain(ctx, obj, values, active=True):
    """ Build a search domain as expected by `search()`

    :param obj: name of the model as string
    :param values: search values (dict of field names with their values)
    :param active: False: only inactive records
                   None: include inactive and active records
                   True: only active records

    """
    values = values.copy()
    xml_id = values.pop('xmlid', None)
    res_id = values.pop('id', None)
    if xml_id:
        if 'active' in model(obj).fields():
            active = None  # we must find a record by xmlid, even inactive
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
    if active in (False, None):
        if 'active' not in model(obj).fields():
            puts("Searching inactive records on %s has no effect "
                 "because it has no 'active' field." % obj)
        elif active is None:
            search_domain += ['|', ('active', '=', False),
                                   ('active', '=', True)]
        elif active is False:
            search_domain += [('active', '=', False)]
    if res_id:
        search_domain = [('id', '=', res_id)] + search_domain
    if hasattr(ctx, 'company_id') and \
       'company_id' in model(obj).fields() and \
       not [term for term in search_domain if term[0] == 'company_id']:
        # we add a company_id domain restriction if there is one definied in ctx,
        # and there is a company_id column in the model
        # and there was no explicit company_id restriction in the domain
        # (we need this to search shared records, such as res.currencies)
        search_domain.append(('company_id', '=', ctx.company_id))
    return search_domain


def parse_table_values(ctx, obj, table):
    """ Parse the values of the tables in the phrases 'And having:'

    The relations support the following options:

    * by {field}: {value}
    * all by {field}: {value}
    * add all by {field}: {value}
    * inactive by {field}: {value}
    * possibly inactive by {field}: {value}
    * all inactive by {field}: {value}
    * add all inactive by {field}: {value}
    * all possibly inactive by {field}: {value}
    * add all possibly inactive by {field}: {value}

    """
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
            active = True
            if value.startswith('add all'):
                add_mode = True
                value = value[4:]  # fall back on "all by xxx" below
            else:
                add_mode = False
            if (value.startswith('inactive by ') or
                    value.startswith('all inactive by ')):
                active = False
                # fall back on "by " and "all by " below
                value = value.replace('inactive ', '', 1)
            if (value.startswith('possibly inactive by ') or
                    value.startswith('all possibly inactive by ')):
                active = None
                # fall back on "by " and "all by " below
                value = value.replace('possibly inactive ', '', 1)
            if value.startswith('by ') or value.startswith('all by '):
                value = value.split('by ', 1)[1]
                values = parse_domain(value)
                search_domain = build_search_domain(ctx, relation, values, active=active)
                if search_domain:
                    value = model(relation).browse(search_domain).id
                    assert value, "no value found for col %s domain %s" % (key, str(search_domain))
                else:
                    value = []
                if add_mode:
                    value = res.get(key, []) + value
            else:
                method = getattr(model(relation), value)
                value = method()
            if field_type == 'many2one':
                assert_true(value, msg="no item found for %s" % key)
                assert_equal(len(value), 1,
                                msg="more than item found for %s" % key)
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

def create_new_obj(ctx, model_name, values):
    values = values.copy()
    xmlid = values.pop('xmlid', None)
    oe_context = getattr(ctx, 'oe_context', None)
    record = model(model_name).create(values, context=oe_context)
    if xmlid is not None:
        ModelData = model('ir.model.data')
        module, xmlid = xmlid.split('.', 1)
        _model_data = ModelData.create({
            'name': xmlid,
            'model': model_name,
            'res_id': record.id,
            'module': module,
        }, context=oe_context)
    return record

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

def openerp_needed_in_path(f):
    """Manage openerp presence in syspath
    And log a warning if not available
    """
    @wraps(f)
    def wrapper(*args, **kwargs):
        try:
            import openerp
            return f(*args, **kwargs)
        except ImportError:
            msg = ('openerp is not in syspath required step '
                   'is not available')

            _logger.error(msg)
            raise ImportError(msg)
    return wrapper
