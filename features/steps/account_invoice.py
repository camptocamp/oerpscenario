from support import *
import datetime

def get_valid_partner(domain=None, type=None, name=None, fields=('id',)):
    if domain is None:
        domain = []
    if type is not None:
        domain.append(('type', '=', type))
    domain.append(('address', '!=', False))
    return model('res.partner').get(domain)

def create_invoice_with_currency(name, partner, amount=0., account=False, currency='EUR',
                                 **options):
    default_opts = {'type': 'out_invoice',
                    'date': False,
                    'partner_id': partner.id,
                    'name': name,
                    }
    options.update(default_opts)
    date = options.pop('date')
    if not date:
        date = str(datetime.date.today())
    options['date_invoice'] = date
    options['partner_id'] = partner.id
    options['currency_id'] = model('res.currency').get([('code', '=', currency_code)]).id
    invoice = model('account.invoice').create(options)
    if amount:
        if options['type'] in ('in_invoice', 'in_refund'):
            invoice.check_total = amount
            invoice.account_id = account.id
        if not account:
            # If no account, take on of type 'other' and a non-reconciliable account
            account = model('account.account').get([('type', '=', 'other'),
                                                    ('reconcile', '=', False)])
            # XXX why only in that branch ???
            line = model('account.invoice.line').create(
                {'account_id': account.id,
                 'quantity': 1,
                 'name': '%s line' % name,
                 'price_unit': amount,
                 'invoice_id': invoice.id})
    return invoice

@given('I have recorded on the {date} an invoice {inv_type} of {amount:f} {currency} without tax called {inv_name}')
def impl(ctx, date, inv_type, amount, currency, inv_name):
    ctx.partner = get_valid_partner(type='supplier')
    invoice = create_invoice_with_currency(inv_name,
                                           ctx.partner,
                                           currency=currency,
                                           date=date,
                                           amount=amount,
                                           type=inv_type)
    ctx.data[inv_name] = invoice


