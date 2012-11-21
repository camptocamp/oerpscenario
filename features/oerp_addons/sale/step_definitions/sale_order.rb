###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Author Joel Grand-Guillaume 2009 
#    Copyright Camptocamp SA
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 Afero of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
##############################################################################


##############################################################################
#           Scenario: Validate a confirmed sale order
##############################################################################

##############################################################################
Given /^I have recorded on the (.*) a sale order of (.*) (.*) without tax called (\w+)$/ do |date,amount,currency_name,name|
  # Take first stockable product
  @product=ProductProduct.find(:first,:domain=>[['type','=','product']], :fields => ['id'])
  @product.should be_true
  # Take first supplier partner with at least one address
  @partner=ResPartner.get_valid_partner(@openerp, {:type=>'supplier',:fields => ['id']})
  @partner.should be_true
  currency_id = ResCurrency.find(:first, :domain=>[['name','=',currency_name]],:fields => ['id']).id
  currency_id.should be_true
  # Create an so with found product and given amount
  so = SaleOrder.new
  so.name = name
  so.date_order = Date.parse(str=date).to_s
  #auto-complete the address and other data based on the partner
  so.on_change('onchange_partner_id', :partner_id,@partner.id, @partner.id)
  so.pricelist_id=ProductPricelist.find(:first,:domain=>[['currency_id','=',currency_id]],:fields => ['id']).id
  so.order_line = [SaleOrderLine.new(:name => 'OERPScenario line', :product_id => @product.id, :price_unit => amount.to_f, :product_uom => 1)]
  so.create
  # Set it in the memorizer
  @openerp.set_var(name.strip,so)
  @openerp.get_var(name.strip).should be_true
  @saleorder=so

end

##############################################################################
When /^I press the confirm button$/ do
  pp @saleorder
  pp "TUTUTUTUTUTUTUT"
  @saleorder.wkf_action('action_invoice_create()')
end

##############################################################################
Then /^I should see the sale order (\w+) open$/ do |name|
  @saleorder=@openerp.get_var(name.strip)
  @saleorder.state.should == 'manual' || @saleorder.state.should == 'progress'
end

##############################################################################
Then /^I should see this sale order (\w+)$/ do |state|
  if state == 'draft'
  @saleorder.state.should == 'draft'
  elsif state == 'open'
  @saleorder.state.should == 'manual'
  elsif state == 'progress'
  @saleorder.state.should == 'progress'
  elsif state == 'done'
  @saleorder.state.should == 'done'
  end
end

##############################################################################
Then /^the total amount = (.*)$/ do |amount|
  @saleorder.amount_total.should == amount.to_f
end


##############################################################################
#  Scenario: Validate exception when cancelling a related invoice
##############################################################################
Given /^change the shipping policy to 'Shipping & Manual Invoice'$/ do
  @saleorder.order_policy = 'manual'
  @saleorder.save
  @saleorder.order_policy.should == 'manual'
end

##############################################################################
Then /^I should see the sale order (\w+) manual in progress$/ do |name|
  @saleorder=@openerp.get_var(name.strip)
  @saleorder.state.should == 'manual'
end

##############################################################################
When /^I press the create invoice button from SO$/ do
  return_val=@saleorder.action_invoice_create(false,['confirmed', 'done', 'exception'],date_inv=@saleorder.picking_ids[0].date)
  pp return_val
  @delivery_order=@saleorder.picking_ids[0]
  @delivery_order.should be_true
end

##############################################################################
Then /^I should see the sale order (\w+) in progress$/ do |name|
  @saleorder=SaleOrder.find(@saleorder.name)
  @saleorder.state.should == 'progress'
end

##############################################################################
Then /^I should have a related draft invoice created$/ do
  @saleorder.invoice_ids.count.should == 1
end

##############################################################################
Given /^I take the related invoice$/ do
  # @saleorder=SaleOrderLine.find(@saleorder.id)
  @invoice=@saleorder.invoice_ids[0]
  @invoice.should be_true
  # Set var to propagate the scope into invoice_step
end

##############################################################################
Given /^change the description for (\w+) and the date to (.*)$/ do |name,date|
  # require 'ruby-debug'
  # debugger
  date=Date.parse(str=date).to_s
  @invoice.name = name
  @invoice.date_invoice = date
  @invoice.save
  @invoice.name.should == name
  @openerp.set_var(@invoice.name,@invoice)
  # @invoice.date.should == date
end

##############################################################################
When /^I press the cancel button on this invoice$/ do
  @invoice.wkf_action('invoice_cancel')
  @invoice.state.should == 'cancel'
end
##############################################################################
When /^then I press the set to draft button$/ do
  AccountInvoice.action_cancel_draft([@invoice.id])
  # @invoice.action_cancel_draft([@invoice.id])
  @invoice=AccountInvoice.find(@invoice.id)
  @invoice.save
end

##############################################################################
Then /^the SO should be in invoice exception$/ do
  @saleorder=SaleOrder.find(@saleorder.id)
  @saleorder.state.should == 'invoice_except'
end

##############################################################################
When /^then I press the invoice corrected button in the SO$/ do
  @saleorder.wkf_action('invoice_corrected')
end

##############################################################################
Then /^I should see the sale order MySimpleSO progress$/ do
  @saleorder.state.should == 'progress'
end

##############################################################################
Then /^the delay of the line (\d+) should be (.*) days$/ do |line, order_delay|
  @sale_order_line = @saleorder.order_line
  @sale_order_line[(line.to_i - 1)].delay.should == order_delay.to_f
end

##############################################################################
Then /^the expected date is (.*)$/ do |expected_date|
  @saleorder.picking_ids[0].max_date.to_s.should == expected_date
end

##############################################################################
Then /^the total amount of the sale order (.*) should be (.*)$/ do |sale_order, total_amount|
    @saleorder = SaleOrder.find(:first, :domain => [['name', '=', sale_order]])
    @saleorder.amount_total.should == total_amount.to_f
end
##############################################################################
Then /^the sale orders should have been created$/ do
    @saleorders = SaleOrder.find(:all)
    @saleorders.should_not be_nil
end


##################################################################################################
############# purchase order copie TEST ###########################

And /^containing the following sale order lines:$/ do | table|
  sale_order = @found_item
  sale_order.should_not be_nil
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
    pol = SaleOrderLine.new(:order_id => sale_order.id,
                                :product_id => product.id,
                                :product_qty => qty,
                                :product_uom => product_uom.id,
                                :price_unit => price,
                                :date_planned => date,
                                :name => "#{sale_order.name} #{product.partner_ref}")
    pol.create
  end
end

When /^I confirm the SO$/ do
  sale_order = @found_item
  sale_order.should_not be_nil
  if sale_order.state == 'draft'
    sale_order.wkf_action('order_confirm')
  end
  sale_order.state.should == 'manual'
  @saleorder = sale_order
end

Then /^(\d)+ pickings? should be created for the SO$/ do |nb_pick|
  sale_order = @found_item
  sale_order.should_not be_nil
  nb_pick = nb_pick.to_i
  sale_order.picking_ids.length.should == nb_pick
  @pickings = sale_order.picking_ids
end

Given /^I process the following product shipment$/ do |table|
  sale_order = @found_item
  sale_order.should_not be_nil
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
        :product_currency => sale_order.pricelist_id.currency_id.id
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

Given /^I process all shipments on (.*)$/ do |date|
  sale_order = @found_item
  sale_order.should_not be_nil
  @pickings.should_not be_nil
  @pickings.length.should == 1
  picking = @pickings[0]
  move_ids = []
  partial_datas = {}
  if date.include? "%"
    date = Time.new().strftime(date)
  end
  pp date
  StockMove.find(:all, :domain=>[['picking_id', '=', picking.id]]).each do |move|
    product = move.product_id
    picked_qty = move.product_qty
    partial_datas["move#{move.id}"] = {
        :product_qty => picked_qty, 
        :product_price => move.price_unit,
        :product_uom => move.product_uom.id,
        :product_currency => sale_order.pricelist_id.currency_id.id
      }
      move_ids << move.id
  end
  complete_move_ids = StockMove.do_partial(move_ids, partial_datas)
  for move in StockMove.find(complete_move_ids)
    StockMove.write([move.id], {:date => date})
  end
end

Given /^(\d)+ ([^ ]+) invoices? should be created for the SO$/ do |nb_invoice, state|
  sale_order = @found_item
  sale_order.should_not be_nil
  sale_order.invoice_ids.length.should == nb_invoice.to_i
  sale_order.invoice_ids.each do |invoice|
    invoice.state.should == state
  end
  if nb_invoice.to_i == 1
    @found_item = sale_order.invoice_ids[0]
  else
    @found_items = sale_order.invoice_ids
  end
end
