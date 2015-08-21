# -*- coding: utf-8 -*-
from support.tools import puts, set_trace, model, assert_true, assert_less
import pprint
if False:
    def given(str):
        return

@given(u'/I install the following languages?/')
def impl(ctx):
    ctx.data['lang'] = cfglang = set()
    for (lang,) in ctx.table:
        if model('res.lang').search([('code', '=', lang)]):
            continue
        res = model('base.language.install').create({'lang': lang})
        model('base.language.install').lang_install([res.id])
        cfglang.add(lang)

@then('these languages should be available')
def impl(ctx):
    for lang in ctx.data['lang']:
        assert_true(model('res.lang').search([('code', '=', lang)]))

@then('the language should be available')
def impl(ctx):
    pass

@when('I update the following languages')
def impl(ctx):
    tlangs = model('res.lang').browse([('translatable', '=', True)])
    codes = set([lang for (lang,) in ctx.table])
    mods = model('ir.module.module').browse(['state = installed'])
    assert_true(codes)
    assert_less(codes, set(tlangs.code))
    mods.button_update_translations()



@given('I update the module list')
def impl(ctx):
    model('ir.module.module').update_list()

@given('I install the required modules with dependencies')
def impl(ctx):
    client = ctx.client
    installed_mods = client.modules(installed=True)['installed']
    to_install = []
    to_upgrade = []
    for row in ctx.table:
        mod_name = row['name']
        if mod_name in installed_mods:
            to_upgrade.append(mod_name)
        else:
            to_install.append(mod_name)
    client.upgrade(*to_upgrade)
    client.install(*to_install)
    ctx.data.setdefault('modules', set()).update(to_upgrade + to_install)

@given('I uninstall the following modules')
def impl(ctx):
    client = ctx.client
    installed_mods = client.modules(installed=True)['installed']
    to_uninstall = []
    for row in ctx.table:
        mod_name = row['name']
        if mod_name in installed_mods:
            to_uninstall.append(mod_name)
    client.uninstall(*to_uninstall)

@then('my modules should have been installed and models reloaded')
def impl(ctx):
    pass # XXX

@then('execute the setup')
def impl(ctx):
    assert ctx.found_item
    ctx.found_item.execute()

@step('I update translations for module "{name}" in the following languages')
def impl_update_module_translations(ctx, name):
    tlangs = model('res.lang').browse([('translatable', '=', True)])
    codes = set([lang for (lang,) in ctx.table])
    mods = model('ir.module.module').browse(['state = installed',
                                             ('name', '=', name)])
    assert_true(codes)
    assert_less(codes, set(tlangs.code))
    mods.button_update_translations(context={'overwrite': True})

@step('I check the following translation terms')
def impl_check_translations(ctx):
    """ check translation terms

 basic usage:

  @setup @translation_check
  Scenario: overwrite <mod> translations
  Given I update translations for module "<mod>" in the following languages:
   | lang  |
   | fr_FR |
  Then I check the following translation terms
   | term            | lang  | module | translation           |
   | Draft Quotation | fr_FR | <mod>  | Réservation brouillon |

"""
    def check(ctx, term,  lang,  module, trans):
        tr = model('ir.translation')
        domain = [('src', '=', term), ('module', '=', module),
                  ('lang', '=', lang)]
        ids = tr.search(domain)
        current = tr.read(ids, 'value')
        assert len(current) == 1, "found matched translation"
        current = current[0]
        assert trans == current, "%s == %s" % (repr(trans),  repr(current))

    for row in ctx.table:
        check(ctx, row['term'], row['lang'], row['module'], row['translation'])
