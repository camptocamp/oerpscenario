# -*- encoding: utf-8 -*-
#################################################################################
#                                                                               #
#    OERPScenario, OpenERP Functional Tests                                     #
#    Copyright (C) 2011 Akretion Benoît Guillot <benoit.guillot@akretion.com>   #
#                                                                               #
#    This program is free software: you can redistribute it and/or modify       #
#    it under the terms of the GNU General Public License as published by       #
#    the Free Software Foundation, either version 3 Afero of the License, or    #
#    (at your option) any later version.                                        #
#                                                                               #
#    This program is distributed in the hope that it will be useful,            #
#    but WITHOUT ANY WARRANTY; without even the implied warranty of             #
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the              #
#    GNU General Public License for more details.                               #
#                                                                               #
#    You should have received a copy of the GNU General Public License          #
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.      #
#                                                                               #
#########################################################################################################################################
When /^I press the purchase button$/ do
  @purchaseorder = PurchaseOrder.find(:first, :sale_id => @saleorder.id)
  @purchaseorder.wkf_action('purchase_confirm')
end

Then /^the purchase expected date is (.*)$/ do |expected_date|
  @purchaseorder.picking_ids[0].max_date.to_s.should == expected_date
end

############# purchase order helpers (A.Fayolle) ###########################

And /^containing the following purchase order lines:$/ do | table|
  purchase_order = @found_item
  purchase_order.should_not be_nil
  table.hashes.each do |row|
    product = _manage_col_search({'relation'=>'product.product'},
                                 row[:product_id])
    qty = row[:product_qty].to_f
    product_uom = _manage_col_search({'relation'=>'product.uom'},
                                     row[:uom])
    price = row[:price_unit].to_f
    date = row[:date_planned]
    if date.include? "%"
      date = Time.new().strftime(date)
    end
    pol = PurchaseOrderLine.new(:order_id => purchase_order.id,
                                :product_id => product.id,
                                :product_qty => qty,
                                :product_uom => product_uom.id,
                                :price_unit => price,
                                :date_planned => date,
                                :name => "#{purchase_order.name} #{product.partner_ref}")
    pol.create
  end
end

And /^I confirm the PO$/ do
  purchase_order = @found_item
  purchase_order.should_not be_nil
  if purchase_order.state == 'draft'
    purchase_order.wkf_action('purchase_confirm')
  end
  purchase_order.state.should == 'approved'
end

Then /^(\d)+ pickings? should be created for the PO$/ do |nb_pick|
  purchase_order = @found_item
  purchase_order.should_not be_nil
  nb_pick = nb_pick.to_i
  purchase_order.picking_ids.length.should == nb_pick
  @pickings = purchase_order.picking_ids
end

Given /^I process the following product moves?:$/ do |table|
  purchase_order = @found_item
  purchase_order.should_not be_nil
  @pickings.should_not be_nil
  @pickings.length.should == 1
  picking = @pickings[0]
  moves_by_product = {}
  move_ids = []
  StockMove.find(:all, :domain=>[['picking_id', '=', picking.id]]).each do |move|
    product_id = move.product_id.id
    if moves_by_product.include?(product_id)
        moves_by_product[product_id] << move
    else
        moves_by_product[product_id] = [move]
    end
  end
  partial_datas = {}
  reception_dates = {}
  table.hashes.each do |row|
    product = _manage_col_search({'relation'=>'product.product'},
                                 row[:product])
    qty = row[:qty].to_f
    date = row[:date]
    if date.include? "%"
      date = Time.new().strftime(date)
    end
    reception_dates[product.id] = date
    for move in moves_by_product[product.id]
      picked_qty = [move.product_qty, qty].min
      partial_datas["move#{move.id}"] = {
        :product_qty => picked_qty, 
        :product_price => move.price_unit,
        :product_uom => move.product_uom.id,
        :product_currency => purchase_order.pricelist_id.currency_id.id
      }
      qty -= picked_qty
      move_ids << move.id
      if qty < 0
        break
      end
    end
  end
  complete_move_ids = StockMove.do_partial(move_ids, partial_datas)
  for move in StockMove.find(complete_move_ids)
    StockMove.write([move.id], {:date => reception_dates[move.product_id.id]})
  end
end

Given /^I process all moves on (.*)$/ do |date|
  purchase_order = @found_item
  purchase_order.should_not be_nil
  @pickings.should_not be_nil
  @pickings.length.should == 1
  picking = @pickings[0]
  move_ids = []
  partial_datas = {}
  if date.include? "%"
    date = Time.new().strftime(date)
  end
  StockMove.find(:all, :domain=>[['picking_id', '=', picking.id]]).each do |move|
    product = move.product_id
    picked_qty = move.product_qty
    partial_datas["move#{move.id}"] = {
        :product_qty => picked_qty, 
        :product_price => move.price_unit,
        :product_uom => move.product_uom.id,
        :product_currency => purchase_order.pricelist_id.currency_id.id
      }
      move_ids << move.id
  end
  complete_move_ids = StockMove.do_partial(move_ids, partial_datas)
  for move in StockMove.find(complete_move_ids)
    StockMove.write([move.id], {:date => date})
  end
end

Then /^the picking should be in state (.*)$/ do |state|
  @pickings.should_not be_nil
  @pickings.each do |pick|
    pick = StockPicking.find(pick.id)
    pick.state.should == state
  end
end

And /^I create a (supplier|customer) invoice for the picking   on (.*)$/ do |invoice_type, date|
  @pickings.should_not be_nil
  if date.include? "%"
    date = Time.new().strftime(date)
  end
  type = {'supplier' => 'in_invoice',
    'customer' => 'out_invoice',
  }
  @pickings.each do |pick|
    begin
      StockPicking.action_invoice_create([pick.id], false, false,
                                         type[invoice_type],
                                         {'date_inv'=>date})
    rescue RuntimeError => exc
      # work around an OpenERP bug in action_invoice_create (see https://bugs.launchpad.net/openobject-server/+bug/1030795)
      raise exc if not (exc.message.include?('HTTP-Error: 500 INTERNAL SERVER ERROR') or exc.message.include?('dictionary key must be string'))
    end
  end
end
Given /^(\d)+ ([^ ]+) invoices? should be created for the PO$/ do |nb_invoice, state|
  purchase_order = @found_item
  purchase_order.should_not be_nil
  purchase_order.invoice_ids.length.should == nb_invoice.to_i
  purchase_order.invoice_ids.each do |invoice|
    invoice.state.should == state
  end
  if nb_invoice.to_i == 1
    @found_item = purchase_order.invoice_ids[0]
  else
    @found_items = purchase_order.invoice_ids
  end
end