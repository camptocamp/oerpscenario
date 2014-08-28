from support import *
import datetime


@step('I press the purchase button')
def impl(ctx):
    ctx.purchase_order = model('purchase.order').get([('sale_id', '=', ctx.saleorder.id)])
    ctx.purchase_order._send('purchase_confirm')


@step('the purchase expected date is {date}')
def impl(ctx, date):
    assert_equal(ctx.purchase_order.picking_ids[0].max_date, date)


@step('containing the following purchase order lines')
def impl(ctx):
    purchase_order = ctx.found_item
    for row in ctx.table:
        row = dict(row.items())
        row['product_uom'] = row['uom']
        del row['uom']
        values = parse_table_values(ctx, 'purchase.order.line', row.items())
        product = model('product.product').get(values['product_id'])
        values['name'] = '%s %s' % (purchase_order.name, product.partner_ref)
        values['order_id'] = purchase_order.id
        model('purchase.order.line').create(values)


@step('I confirm the PO')
def impl(ctx):
    purchase_order = ctx.found_item
    if purchase_order.state == 'draft':
        purchase_order._send('purchase_confirm')


@step('{nb_pick:d} picking should be created for the PO')
@step('{nb_pick:d} pickings should be created for the PO')
def impl(ctx, nb_pick):
    purchase_order = ctx.found_item
    assert_equal(len(purchase_order.picking_ids), nb_pick)
    ctx.pickings = purchase_order.picking_ids


@step('I process the following product move')
@step('I process the following product moves')
def impl(ctx):
    purchase_order = ctx.found_item
    pickings = ctx.pickings
    assert_equal(len(pickings), 1)
    picking = pickings[0]
    moves_by_product = {}
    move_ids = []
    for move in model('stock.move').browse([('picking_id', '=', picking.id)]):
        product_id = move.product_id.id
        moves_by_product.setdefault(product_id, []).append(move)
    partial_datas = {}
    reception_dates = {}
    for row in ctx.table:
        row = dict(row.items())
        res = parse_table_values(ctx, 'stock.move',
                                     [('product_id', row['product'])])
        product_id = res['product_id']
        qty = float(row['qty'])
        date = row['date']
        if '%' in date:
            date = datetime.datetime.now().strftime(date)
        reception_dates[product_id] = date
        for move in moves_by_product[product_id]:
            picked_qty = min(move.product_qty, qty)
            partial_datas['move%s' % move.id] = {
                'product_qty': picked_qty,
                'product_price': move.price_unit,
                'product_uom': move.product_uom.id,
                'product_currency': purchase_order.pricelist_id.currency_id.id
                }
            qty -= picked_qty
            move_ids.append(move.id)
            if qty < 0:
                break
    complete_move_ids = model('stock.move').do_partial(move_ids, partial_datas)
    for move in model('stock.move').browse(complete_move_ids):
        move.date = reception_dates[move.product_id.id]


@step('I process all moves on {date}')
def impl(ctx, date):
    purchase_order = ctx.found_item
    pickings = ctx.pickings
    assert_equal(len(pickings), 1)
    picking = pickings[0]
    move_ids = []
    if '%' in date:
        date = datetime.datetime.now().strftime(date)
    for move in model('stock.move').browse([('picking_id', '=', picking.id)]):
        product_id = move.product_id.id
        picked_qty = move.product_qty
        partial_datas['move%s' % move.id] = {
            'product_qty': picked_qty,
            'product_price': move.price_unit,
            'product_uom': move.product_uom.id,
            'product_currency': purchase_order.pricelist_id.currency_id.id
            }
        move_ids.append(move.id)
    complete_move_ids = model('stock.move').do_partial(move_ids, partial_datas)
    for move in model('stock.move').browse(complete_move_ids):
        move.date = reception_dates[move.product_id.id]


@step('the picking should be in state {state}')
def impl(ctx, state):
    pickings = ctx.pickings
    for pick in pickings:
        pick = model('stock.picking').get(pick.id)
        pick.refresh()
        assert_equal(pick.state, state)


@step('I create a {inv_type} invoice for the picking on {date}')
def impl(ctx, inv_type, date):
    pickings = ctx.pickings
    assert_true(inv_type in ('supplier', 'customer'))
    if '%' in date:
        date = datetime.datetime.now().strftime(date)
    types = {'supplier': 'in_invoice',
             'customer': 'out_invoice'}
    for pick in pickings:
        model('stock.picking').action_invoice_create([pick.id], False, False,
                                                     types[inv_type],
                                                     {'date_inv': date})


@step('{nb_inv:d} {state} invoice should be created for the PO')
@step('{nb_inv:d} {state} invoices should be created for the PO')
def impl(ctx, nb_inv, state):
    purchase_order = ctx.found_item
    assert_equal(len(purchase_order.invoice_ids), nb_inv)
    for invoice in purchase_order.invoice_ids:
        assert_equal(invoice.state, state)
    if nb_inv == 1:
        ctx.found_item = purchase_order.invoice_ids[0]
    else:
        ctx.found_items = purchase_order.invoice_ids



