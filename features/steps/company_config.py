from support import model, assert_equal, set_trace, puts
import base64
import os

def get_encoded_image(ctx, image_path):
    tmp_path = ctx.feature.filename.split(os.path.sep)
    tmp_path = tmp_path[1: tmp_path.index('features')]
    tmp_path.extend(['data', image_path])
    tmp_path = [str(x) for x in tmp_path]
    path = os.path.join('/', *tmp_path)
    assert os.path.exists(path), "path not found %s" % path
    with open(path, "rb") as image_file:
        return base64.b64encode(image_file.read())

@given(u'the company has the "{logo_path}" logo')
def impl(ctx, logo_path):
    company = ctx.found_item
    assert ctx.found_item
    encoded_image = get_encoded_image(ctx, logo_path)
    company.write({'logo': encoded_image})

@given(u'I have a header image "{logo_name}" from file "{logo_path}"')
def impl(ctx, logo_name, logo_path):
    cp_id = ctx.data.get('company_id')

    filename, extension = os.path.splitext(logo_path)
    assert extension.lower() in ['.png', '.gif', '.jpeg', '.jpg'], "Image extension must be (.png, .gif or .jpeg)"

    encoded_image = get_encoded_image(ctx, logo_path)

    values = {
            'img' : encoded_image,
            'name' : logo_name,
            'type': extension[1:],
            'company_id': cp_id,
            }

    header_img = model('ir.header_img').browse(
            [('name', '=', logo_name),
             ('company_id', '=', cp_id)])
    if header_img:
        header_img.write(values)
    else:
        model('ir.header_img').create(values)

@given(u'the company currency is "{rate_code}" with a rate of "{rate_value}"')
def impl(ctx, rate_code, rate_value):
    assert ctx.found_item
    company = ctx.found_item
    currency = model('res.currency').get([('name', '=', rate_code)])
    assert currency
    rate = model('res.currency.rate').get([('currency_id', '=', currency.id)])
    assert rate
    rate.write({'rate': rate_value})
    company.write({'currency_id': currency.id})

@given(u'I set the webkit path to "{webkit_path}"')
def impl(ctx, webkit_path):
    key = model('ir.config_parameter').get("key = webkit_path")
    if key:
        key.write({'value': webkit_path})
    else:
        model('ir.config_parameter').create({'key': 'webkit_path', 'value': webkit_path})
