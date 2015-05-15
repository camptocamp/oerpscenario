import csv
import os
import base64
import yaml

import openerp

from support import model

#---------
#from openerp.tools import yaml_import

class Image(openerp.tools.yaml_tag.YamlTag):
    def __init__(self, path):
        self.path = path
        super(Image, self).__init__()
    def __str__(self):
        return '!image %r' % self.path

class YamlInterpreter(openerp.tools.YamlInterpreter):
    def __init__(self, ctx, *args, **kwargs):
        self.ctx=ctx
        return super(YamlInterpreter,self).__init__(*args,**kwargs)
    def process(self, yaml_string):
        def image_constructor(loader, node):
            expression = loader.construct_scalar(node)
            return Image(expression)
        yaml.add_constructor(u"!image", image_constructor)
        return super(YamlInterpreter,self).process(yaml_string)
    def process_image(self, node):
        return base64.encodestring(_fileopen(self.ctx, node.path).read())
    def _eval_field(self, cmodel, field_name, expression, view_info=False, parent=None, default=True):
        # Allow to ref m2o with search criteria
        # TODO : push as MP on server
        if parent is None:
            parent={}
        if field_name in cmodel._columns:
            column = cmodel._columns[field_name]
        elif field_name in cmodel._inherit_fields:
            column = cmodel._inherit_fields[field_name][2]
        else:
            raise KeyError("Object '%s' does not contain field '%s'" % (cmodel, field_name))
        if column._type == "many2one":
            if isinstance(expression,dict):
                domain=[(k,'=',v) for k,v in expression.iteritems()]
                return model(column._obj).search(domain)
        elif isinstance(expression,Image):
            return self.process_image(expression)
        return super(YamlInterpreter,self)._eval_field(cmodel, field_name, expression, view_info=view_info, parent=parent, default=default)

def yaml_import(ctx, cr, module_name, fp, kind, mode='init'):
    idref = {}
    yaml_interpreter = YamlInterpreter(ctx, cr, module_name, idref, mode='update', filename=fp.name)
    yaml_interpreter.process(fp.read())

#---------

def _fileopen(ctx, filename, mode='r'):
    tmp_path = ctx.feature.filename.split(os.path.sep)
    tmp_path = tmp_path[: tmp_path.index('features')] + ['data', filename]
    tmp_path = [str(x) for x in tmp_path]
    path = os.path.join(*tmp_path)
    assert os.path.exists(path)
    return open(path, mode)


@given('I load the data file "{filename}.csv" into the model "{model_name}"')
def impl(ctx, model_name, filename, sep=","):
    data = csv.reader(_fileopen(ctx, '%s.csv'%filename, 'rb'), delimiter=str(sep))
    head = []
    skip = [] #skip columns that are not mapped
    for index,field in enumerate(data.next()):
        if field:
            head.append(field)
        else:
            skip.append(index)
    values=[]
    for line in data:
        values.append([field for index,field in enumerate(line) if index not in skip])
    rewrite=[i for i,e in enumerate(head) if e=='id' or e.endswith('/id')]
    if rewrite:
        for line in iter(values):
            for pos in rewrite:
                if '.' not in line[pos]:
                    line[pos]='scenario.'+line[pos]
    model(model_name).load(head, values)

@given('I load the data file "{filename}.yml"')
def impl(ctx, filename):
    openerp = ctx.conf['server']
    db_name = ctx.conf['db_name']
    pool = openerp.modules.registry.RegistryManager.get(db_name)
    cr = pool.db.cursor()
    module_name='scenario'
    fp=_fileopen(ctx, '%s.yml'%filename)
    try:
        cr.autocommit(True)
        yaml_import(ctx, cr, module_name, fp, 'data', mode='update')
    finally:
        cr.close()

@given('"{model_name}" is imported from CSV "{csvfile}" in language "{lang}"')
def impl(ctx, model_name, csvfile, lang, sep=","):
    tmp_path = ctx.feature.filename.split(os.path.sep)
    tmp_path = tmp_path[: tmp_path.index('features')] + ['data', csvfile]
    tmp_path = [str(x) for x in tmp_path]
    path = os.path.join(*tmp_path)
    assert os.path.exists(path)
    data = csv.reader(open(path, 'rb'), delimiter=str(sep))
    head = data.next()
    # generator does not work
    values = [x for x in data]
    result = model(model_name).load(head, values, {'lang': lang})
    if not result['ids']:
        messages = '\n'.join('- %s' % msg for msg in result['messages'])
        raise Exception("Failed to load file '%s' "
                        "in '%s'. Details:\n%s" % (csvfile, model_name, messages))


@given('"{model_name}" is imported asynchronously from CSV "{csvfile}" using delimiter "{sep}"')
def impl(ctx, model_name, csvfile, sep=","):
    importer = model('base_import.import').create({
        'res_model': model_name,
        'file': _fileopen(ctx, csvfile, 'rb').read(),
        'file_name': csvfile,
        'file_type': 'csv',

    })
    data = csv.reader(_fileopen(ctx, csvfile, 'rb'),
                      delimiter=str(sep))
    fields = data.next()
    options = {
        'headers': True,
        'quoting': '"',
        'separator': ',',
        'encoding': 'utf-8',
        'use_connector': True}
    model('base_import.import').do(importer.id, fields, options)
