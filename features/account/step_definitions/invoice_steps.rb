###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Author Nicolas Bessi & Joel Grand-Guillaume 2009 
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

@invoice = false
Before do
    # Initiate vars used to stored object used trought the tests
    @partner = false
    @address = false
    @account = false
    @prod = false
    @currency = false
    @company = false
    @wizard  = false
    @journal = false
end


##############################################################################
#           Scenario: validate_created_invoice
##############################################################################

##############################################################################
Given /^I have recorded on the (.*) a supplier invoice \((\w+)\) of (.*) (\w+) without tax called (\w+)$/ do |date,inv_type,amount,currency,name|
  # Take first supplier partner with at least one address
  @partner=ResPartner.get_valid_partner({:type=>'supplier'})
  @partner.should be_true
  # Create an invoice with a line = amount
  @invoice=AccountInvoice.create_invoice_with_currency(name, @partner, {:currency_code=>currency, :date=>date, :amount=>amount.to_f, :type=>inv_type})
  
end

##############################################################################
When /^I press the valiate button$/ do
  # Call the 'invoice_open' method from account.invoice openobject
  @invoice.wkf_action('invoice_open')
end

##############################################################################
Then /^I should see the invoice (\w+) (\w+)$/ do |name,state|
  # Take the invoice
  # @invoice=AccountInvoice.find(:first,:domain=>[['name','=',name],['state','=',state]])
  @invoice.should be_true
  @invoice.state.should == state
end

##############################################################################
Then /^the residual amount = (.*)$/ do |amount|
  @invoice.amount_total.should == amount.to_f
end

##############################################################################
#           Scenario: check_account_move_created_invoice
##############################################################################

##############################################################################
Given /^I take the created invoice (\w+)$/ do |inv_name|
  # Take the inv_name with open state
  @invoice=AccountInvoice.find(:first,:domain=>[['name','=',inv_name],['state','=','open']])
  @invoice.should be_true
end

##############################################################################
Then /^I should have a linked account move with (\w+) lines and a (\w+) status$/ do |number_line,status|
  @invoice.move_id.state.should == status
  @invoice.move_id.line_id.length.should == number_line.to_i
end

##############################################################################
Then /^the associated debit account move line should use the account choosen in the invoice line and have the following values:$/ do |table|
  # table is a Cucumber::Ast::Table
  table.hashes.each do |line|
    @invoice.move_id.line_id.each do |inv_line|
      unless inv_line.debit.zero? :
        inv_line.debit.should == line[:debit].to_f
        inv_line.credit.should == 0.0
        inv_line.amount_currency.should == line[:amount_currency].to_f
        inv_line.currency_id.code.should == line[:currency]
        inv_line.account_id.id.should == @invoice.invoice_line[0].account_id.id
        inv_line.state.should == line[:status]
      end
    end
  end
end

##############################################################################
Then /^the associated credit account move line should use the account of the partner account payable property and have the following values:$/ do |table|
  # table is a Cucumber::Ast::Table
  table.hashes.each do |line|
    @invoice.move_id.line_id.each do |inv_line|
      unless inv_line.credit.zero? :
        inv_line.credit.should == line[:credit].to_f
        inv_line.debit.should == 0.0
        inv_line.amount_currency.should == line[:amount_currency].to_f
        inv_line.currency_id.code.should == line[:currency]
        # TODO : Implement check on partner property AND add on_change partner instead of using any account
        # inv_line.account_id.id.should == @invoice.invoice_line[0].account_id.id
        inv_line.state.should == line[:status]
      end
    end
  end
end


##############################################################################
#           Scenario: cancel_recreate_created_invoice
##############################################################################

##############################################################################
When /^I press the cancel button$/ do
  # Call the 'invoice_open' method from account.invoice openobject
  @invoice.wkf_action('invoice_cancel')
end
##############################################################################
Then /^no more link on an account move$/ do
  @invoice.attributes['move_id'].should be_false
end
##############################################################################
When /^I press the set to draft button$/ do
  # Call the 'invoice_open' method from account.invoice openobject
  @invoice.call('action_cancel_draft',[@invoice.id])
  @invoice=AccountInvoice.find(@invoice.id)
end
##############################################################################
Given /^the entries on the invoice related journal can be cancelled$/ do
  @invoice.journal_id.update_posted=true
  @invoice.save
end
##############################################################################

Then /^the invoice should appear as paid invoice \(checkbox tic\)$/ do
  @invoice.reconciled.should be_true
end
