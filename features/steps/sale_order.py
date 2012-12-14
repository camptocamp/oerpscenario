from support import *
import datetime

@step('I confirm the SO')
def impl(ctx):
    sale_order = ctx.found_item
    if sale_order.state == 'draft':
        sale_order._send('order_confirm')
    assert_equal(sale_order.state, 'manual')
    ctx.sale_order = sale_order

@step('containing the following sale order lines')
def impl(ctx):
    sale_order = ctx.found_item
    for row in ctx.table:
        row = dict(row.items())
        row['product_uom'] = row['uom']
        del row['uom']
        values = parse_table_values(ctx, 'sale.order.line', row.items())
        product = model('product.product').get(values['product_id'])
        values['name'] = '%s %s' % (sale_order.name, product.partner_ref)
        values['order_id'] = sale_order.id
        model('purchase.order.line').create(values)
        
