from support import model, assert_equal, set_trace, puts
import base64
import os

def get_encoded_image(ctx, image_path):
    tmp_path = ctx.feature.filename.split(os.path.sep)
    tmp_path = tmp_path[: tmp_path.index('features')]
    tmp_path.extend(['data', image_path])
    tmp_path = [str(x) for x in tmp_path]
    path = os.path.join(*tmp_path)
    assert os.path.exists(path), "path not found %s" % path
    with open(path, "rb") as image_file:
        return base64.b64encode(image_file.read())

@given(u'the company has the "{logo_path}" report logo')
def impl(ctx, logo_path):
    company = ctx.found_item
    assert ctx.found_item
    encoded_image = get_encoded_image(ctx, logo_path)
    company.write({'report_logo': encoded_image})
