from support import *
import datetime

@step('I import invoice {inv_name}" using import invoice button')
def impl(ctx, inv_name):
    invoice = model('account.invoice').get([('name', '=', inv_name)])
    bank_statement = ctx.found_item
    for line in bank_statement.line_ids:
        line.unlink()
    lines = model('account.move.line').browse(
        [('move_id', '=', invoice.move_id.id),
         ('account_id', '=', invoice.account_id.id)])
    wizard = model('account.statement.from.invoices.lines').create({'line_ids': lines})
    wizard.populate_statement({'statement_id': bank_statement.id})



@step('My invoice "{inv_name}" is in state "{state}" reconciled with a residual amount of "{amount:f}"')
def impl(ctx, inv_name, state, amount):
    invoice = model('account.invoice').get([('name', '=', inv_name)])
    assert_almost_equal(invoice.residual, amount)
    assert_equal(invoice.state, state)


@step('I should have following journal entries in voucher')
@step('I should have the following journal entries in voucher')
def impl(ctx):
    rows = []
    for row in ctx.table:
        cells = {}
        for key, value in row.items():
            if value:
               cells[key] = value
        rows.append(cells)
    bank_statement = ctx.found_item
    assert_equal(len(bank_statement.move_line_ids), len(rows))
    errors = []
    for row in rows:
        account = model('account.account').get([('name', '=', row['account'])])
        if 'curr.' in row:
            currency_id = mode('res.currency').get([('name', '=', row['curr.'])]).id
        else:
            currency_id = False
    pname = datetime.datetime.now().strftime(row['period'])
    period = model('account.period').get([('name', '=', pname)])
    domain = [('account_id', '=', account.id),
              ('period_id', '=', period.id),
              ('date', '=', datetime.datetime.now().strftime(row['date'])),
              ('credit', '=', row.get('credit', 0.)),
              ('debit', '=', row.get('debit', 0.)),
              ('amount_currency', '=', row.get('curr.amt', 0.)),
              ('currency_id', '=', currency_id),
              ('id', 'in', [line.id for line in bank_statment.move_line_ids]),
              ]
    if row.get('reconcile'):
        domain.append(('reconcile_id', '!=', False))
    else: 
        domain.append(('reconcile_id', '=', False))
    if row.get('partial'):
        domain.append(('reconcile_partial_id', '!=', False))
    else: 
        domain.append(('reconcile_partial_id', '=', False))
    line = model('account.move.line').get(domain)
        
@step('I modify the bank statement line amount to {amount:f}')
def impl(ctx, amount):
    line = ctx.found_item.voucher_id.line_cr_ids[0]
    #ctx.voucher = model('account.voucher').get(ctx.found_item.voucher_id.id)
    ctx.found_item.on_change('onchange_amount', 'amount', (), amount)

