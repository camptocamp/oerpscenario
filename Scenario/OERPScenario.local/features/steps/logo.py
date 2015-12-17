# -*- coding: utf-8 -*-
import os
import base64

# that should probably somewhere in the environment, not in the steps
def get_encoded_image(ctx, image_path):
    tmp_path = ctx.feature.filename.split(os.path.sep)
    tmp_path = tmp_path[: tmp_path.index('features')]
    tmp_path.extend(['data', image_path])
    tmp_path = [str(x) for x in tmp_path]
    path = os.path.join(*tmp_path)
    assert os.path.exists(path), "path not found %s" % path
    with open(path, "rb") as image_file:
        return base64.b64encode(image_file.read())


@given(u'the company has the "{logo_path}" logo2')
def impl(ctx, logo_path):
    company = ctx.found_item
    assert ctx.found_item
    encoded_image = get_encoded_image(ctx, logo_path)
    company.write({'logo2': encoded_image})
    
@given(u'the company has the "{logo_path}" logo3')
def impl(ctx, logo_path):
    company = ctx.found_item
    assert ctx.found_item
    encoded_image = get_encoded_image(ctx, logo_path)
    company.write({'logo3': encoded_image})

@given(u'the user has the "{image_path}" image')
def impl(ctx, image_path):
    user = ctx.found_item
    assert ctx.found_item
    encoded_image = get_encoded_image(ctx, image_path)
    user.write({'image': encoded_image})
    
@given(u'the partner has the "{image_path}" image')
def impl(ctx, image_path):
    partner = ctx.found_item
    assert ctx.found_item
    encoded_image = get_encoded_image(ctx, image_path)
    partner.write({'image': encoded_image})    
