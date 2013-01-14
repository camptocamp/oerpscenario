from support import model, assert_equal, set_trace, puts
import base64
import os
@given(u'the company has the "{logo_path}" logo')
def impl(ctx, logo_path):
    assert ctx.found_item
    company = ctx.found_item
    tmp_path = ctx.feature.filename.split(os.path.sep)
    tmp_path = tmp_path[1: tmp_path.index('features')]
    tmp_path.extend(['data', logo_path])
    tmp_path = [str(x) for x in tmp_path]
    path = os.path.join('/', *tmp_path)
    assert os.path.exists(path)
    with open(path, "rb") as image_file:
        encoded_image = base64.b64encode(image_file.read())
    company.write({'logo': encoded_image})

@given(u'the main company currency is "{rate_code}" with a rate of "{rate_value}"')
def impl(ctx, rate_code, rate_value):
    assert ctx.found_item
    company = ctx.found_item
    currency_id = model('res.currency').search([('name', '=', rate_code)])
    assert currency_id
    rate = model('res.currency.rate').get([('currency_id', '=', currency_id)])
    assert rate
    rate.write({'rate': rate_value})

@given(u'I set the webkit path to "{webkit_path}"')
def impl(ctx, webkit_path):
    key = model('ir.config_parameter').get("key = webkit_path")
    if key:
        key.write({'value': webkit_path})
    else:
        model('ir.config_parameter').create({'key': 'webkit_path', 'value': webkit_path})
