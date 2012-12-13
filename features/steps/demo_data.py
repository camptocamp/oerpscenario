from support.tools import puts, set_trace, model

@given(u'I do not want all demo data to be loaded on install')
def impl(context):
    IrModuleModule = model('ir.module.module')
    ids = IrModuleModule.search([])
    IrModuleModule.write(ids, {'demo': False})

@given(u'I want all demo data to be loaded on install')
def impl(context):
    IrModuleModule = model('ir.module.module')
    ids = IrModuleModule.search([])
    IrModuleModule.write(ids, {'demo': True})
