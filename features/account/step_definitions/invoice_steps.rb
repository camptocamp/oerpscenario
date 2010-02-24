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

# @invoice = false
# Before do
#     # Initiate vars used to stored object used trought the tests
#     @partner = false
#     @address = false
#     @account = false
#     @prod = false
#     @currency = false
#     @company = false
#     @wizard  = false
#     @journal = false
# end


##############################################################################
#           Scenario: validate_created_invoice
##############################################################################

##############################################################################
Given /^I have recorded on the (.*) a supplier invoice \((\w+)\) of (.*) (\w+) without tax called (\w+)$/ do |date,inv_type,amount,currency,name|
  # Take first supplier partner with at least one address
  @partner=ResPartner.get_valid_partner({:type=>'supplier'})
  @partner.should be_true
  # Create an invoice with a line = amount
  # and store it in a variable named : name
  # var_name = "@#{name}"
  invoice=AccountInvoice.create_invoice_with_currency(name, @partner, {:currency_code=>currency, :date=>date, :amount=>amount.to_f, :type=>inv_type})
  $utils.set_var(name,invoice)
  $utils.get_var(name.strip).should be_true
  # instance_variable_set(var_name, invoice)
  # retrieve it with : instance_variable_get("@"+name)
  
  # For backward compatibility
  @invoice=invoice
  @invoice.should be_true
end

##############################################################################
When /^I press the validate button$/ do
  # Call the 'invoice_open' method from account.invoice openobject
  @invoice.wkf_action('invoice_open')
end

##############################################################################
Then /^I should see the invoice (\w+) (\w+)$/ do |name,state|
  # Take the invoice
  @invoice=$utils.get_var(name.strip)
  @invoice=AccountInvoice.find(@invoice.id)
  # Old schoold system :
  # @invoice=AccountInvoice.find(:first,:domain=>[['name','=',name],['state','=',state]])
  @invoice.should be_true
  @invoice.state.should == state
end

##############################################################################
Then /^the residual amount = (.*)$/ do |amount|
  @invoice=AccountInvoice.find(@invoice.id)
  @invoice.residual.should == amount.to_f
end

##############################################################################
Given /^I take the created invoice (\w+)$/ do |inv_name|
  # Take the inv_name with open state
  @invoice=$utils.get_var(inv_name.strip)
  @invoice=AccountInvoice.find(@invoice.id)
  # Old schoold system :
  # @invoice=AccountInvoice.find(:first,:domain=>[['name','=',inv_name],['state','=','open']])
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
  @invoice.move_id.should be_false
end
##############################################################################
When /^I press the set to draft button$/ do
  # Call the 'invoice_open' method from account.invoice openobject
  @invoice.call('action_cancel_draft',[@invoice.id])
  @invoice=AccountInvoice.find(@invoice.id)
end
##############################################################################
Given /^the entries on the invoice related journal can be cancelled$/ do
  journal=AccountJournal.find(@invoice.journal_id.id)
  journal.update_posted=true
  journal.save
  journal.update_posted.should be_true
  @invoice=AccountInvoice.find(@invoice.id)
end
##############################################################################
Then /^the invoice should appear as paid invoice \(checkbox tic\)$/ do
  @invoice.reconciled.should be_true
end
##############################################################################
When /^I change the currency to (\w+)$/ do |currency_code|
  cur=ResCurrency.find(:first, :domain=>[['code','=',currency_code]])
  @invoice.class.rpc_execute('write',@invoice.id,:currency_id => cur.id)
  @invoice=AccountInvoice.find(@invoice.id)
  @invoice.currency_id.code.should == currency_code
end

##############################################################################
#           Scenario: check_rounding_diff_multi_line_inv
##############################################################################

##############################################################################
Given /^I add a line called (\w+) on the last created invoice of (.*)$/ do |line_name,amount|
  # Take an account
  account_id = AccountAccount.find(:first, :domain=>[['type','=','other']]).id
  line=AccountInvoiceLine.new(
    :account_id => account_id,
    :quantity => 1,
    :price_unit => amount,
    :name => line_name,
    :invoice_id => @invoice.id
  )
  line.create
  @invoice=AccountInvoice.find(@invoice.id)
end

##############################################################################
Then /^the total credit amount must be equal to the total debit amount$/ do
  total_debit=0.0
  total_credit=0.0
  @invoice.move_id.line_id.each do |inv_line|
    if inv_line.credit.zero? :
      total_debit = total_debit + inv_line.debit
    elsif inv_line.debit.zero? :
      total_credit = total_credit + inv_line.credit      
    end
  end
  total_credit.should == total_debit
end

##############################################################################
And /^correct the total amount of the invoice according to changes$/ do
  @invoice.check_total = @invoice.amount_total
  @invoice.save

end

##############################################################################
Then /^the total amount convert into company currency must be same amount than the credit line on the payable\/receivable account$/ do
  company_currency_amount=ResCurrency.rpc_execute('compute',@invoice.company_id.currency_id.id,@invoice.currency_id.id,@invoice.amount_total,:context=>[:date=>@invoice.date_invoice])
  company_currency_amount.should be_true
  # Take the line to reconcile
  @invoice.move_id.line_id.each do |inv_line|
     if inv_line.debit = 0.0 and inv_line.account_id.reconcile:
       amount = inv_line.credit
    end   
  end
  company_currency_amount.should == amount
end

##############################################################################
#           Scenario: invoice_partial_payment_validate_cancel
##############################################################################

##############################################################################
When /^I press the cancel button it should raise a warning$/ do
  class InvoiceCancel < Exception
  end
  begin
      # Call the 'invoice_open' method from account.invoice openobject
      @invoice.wkf_action('invoice_cancel')
      raise InvoiceCancel, 'Cancelling invoice should not work when partial payment is done !'
  rescue InvoiceCancel => e
    # Here we are in the case the invoice was cancelled
    raise e
  rescue RuntimeError => e
    # Does nothing here, everything is normal if I get this error !
    # The bank statement shouldn't be validated if an invoice is already reconciled !
  rescue Exception => e
    raise e
  end
end

##############################################################################
Then /^because the invoice is partially reconciled the payments lines should be kept$/ do
  @invoice.payment_ids.size.should > 0
end
