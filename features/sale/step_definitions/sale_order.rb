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
  @partner=ResPartner.get_valid_partner({:type=>'supplier',:fields => ['id']})
  @partner.should be_true
  currency_id = ResCurrency.find(:first, :domain=>[['name','=',curerncy_name]],:fields => ['id']).id
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
  $utils.set_var(name.strip,so)
  $utils.get_var(name.strip).should be_true
  @saleorder=so

end

##############################################################################
When /^I press the confirm button$/ do
  # Call the 'invoice_open' method from account.invoice openobject
  @saleorder.wkf_action('order_confirm')
end

##############################################################################
Then /^I should see the sale order (\w+) open$/ do |name|
  @saleorder=$utils.get_var(name.strip)
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
  @saleorder=$utils.get_var(name.strip)
  @saleorder.state.should == 'manual'
end

##############################################################################
When /^I press the create invoice button from SO$/ do
  @saleorder.wkf_action('manual_invoice')
  @delivery_order=@saleorder.picking_ids[0]
  @delivery_order.should be_true
end

##############################################################################
Then /^I should see the sale order (\w+) in progress$/ do |name|
  @saleorder=$utils.get_var(name.strip)
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
  $utils.set_var(@invoice.name,@invoice)
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
