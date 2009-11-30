#Author Nicolas Bessi 2009 
#copyright Camptocamp SA
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


# --------------------------------------------------------
#           Scenario: validate_created_invoice
# --------------------------------------------------------
Given /^I have recorded on the (.*) a supplier invoice \((\w+)\) of (.*) (\w+) without tax called (\w+)$/ do |date,inv_type,amount,currency,name|
  # Take first supplier partner with at least one address
  @partner=ResPartner.get_valid_partner({:type=>'supplier'})
  @partner.should be_true
  # Create an invoice with a line = amount
  @invoice=AccountInvoice.create_invoice_with_currency(name, @partner, {:currency_code=>'CHF', :date=>date, :amount=>amount.to_f, :type=>'in_invoice'})

end

When /^I press the valiate button$/ do
  # Call the 'invoice_open' method from account.invoice openobject
  @invoice.wkf_action('invoice_open')
end

Then /^I should see the invoice (\w+) (\w+)$/ do |name,state|
  # Take the invoice
  @invoice=AccountInvoice.find(:first,:domain=>[['name','=',name],['state','=',state]])
  @invoice.state.should == state
end

Then /^the residual amount = (.*)$/ do |amount|
  @invoice.amount_total.should == amount.to_f
end

# --------------------------------------------------------
#           Scenario: check_account_move_created_invoice
# --------------------------------------------------------
Given /^I take the created invoice (\w+)$/ do |inv_name|
  # Take the inv_name with open state
  @invoice=AccountInvoice.find(:first,:domain=>[['name','=',inv_name],['state','=','open']])
end

Then /^I should have a linked account move with (\w+) lines and a (\w+) status$/ do |number_line,status|
  @invoice.move_id.state.should == status
  @invoice.move_id.line_id.length.should == number_line.to_i
end

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







# --------------------------------------------------------
#           Not Use anymore
# --------------------------------------------------------

