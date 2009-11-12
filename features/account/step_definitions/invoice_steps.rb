#Author Nicolas Bessi 2009 
#copyright Camptocamp SA
Before do
    @partner = false
    @address = false
    @account = false
    @prod = false
    @currency = false
    @company = false
    @invoice = false
end


# --------------------------------------------------------
#           Background
# --------------------------------------------------------

# And the company currency is set to EUR 
Given /^the company currency is set to (\w+)$/ do |currency| 
  # TODO not the first, but the one of the user..
  @company = ResCompany.find(:first)
  @cmpcurrency = ResCurrency.find(:first, :domain=>[['code','=',currency]])
  @company.currency_id = @cmpcurrency.id
  @company.save
end


Given /^the following currency rate settings are:$/ do |currencies|
  # TODO : Optimize that, I make it not that good :(
  # clean rate on currency before set them
  currencies.hashes.each do |c|
    rate_to_clean = ResCurrencyRate.find(:first, :domain=>[['currency_id','=',ResCurrency.find(:first, :domain=>[['code','=',c[:code]]]).id]])
    rate_to_clean.destroy
  end
  currencies.hashes.each do |c|
    c[:currency_id] = ResCurrency.find(:first, :domain=>[['code','=',c[:code]]]).id
    ResCurrencyRate.create(c)
  end
end

# --------------------------------------------------------
#           Scenario: validate_created_invoice
# --------------------------------------------------------
Given /^I have recorded on the (.*) a supplier invoice \((\w+)\) of (.*) (\w+) without tax called (\w+)$/ do |date,inv_type,amount,currency,name|
  # Take first supplier partner with at least one address
  res=ResPartner.find(:all,:domain=>[ ['supplier','=',true] ])
  res.should be_true
  res.each do |part|
      if (part.address.length >0) :
          @partner = part
          break
       end
  end
  @partner.should be_true

  date=Date.parse(str=date).to_s
  @invoice=AccountInvoice.new({
    :type => inv_type, 
    :name => name,
    :currency_id => ResCurrency.find(:first, :domain=>[['code','=',currency]]).id,
    :partner_id => @partner.id,
    :address_invoice_id => @partner.address[0].id,
    :date_invoice => date,
    :account_id => @partner.property_account_payable.id,
    :check_total => amount.to_f,
  })  
  # Create a line = amount
  @invoice.create
  line=AccountInvoiceLine.new(
    :account_id => AccountAccount.find(:first, :domain=>[['type','=','other']]).id,
    :quantity => 1,
    :price_unit => amount.to_f,
    :name => name+' line',
    :invoice_id => @invoice.id
  )
  line.create
end

When /^I press the valiate button$/ do
  AccountInvoice.rpc_exec_workflow('invoice_open',@invoice.id)
end

Then /^I should see the invoice (\w+) (\w+)$/ do |name,state|
  @invoice=AccountInvoice.find(:first,:domain=>[['name','=',name]])
  @invoice.state.should == state
end

Then /^the residual amount = (.*)$/ do |amount|
  @invoice.amount_total.should == amount.to_f
end

# --------------------------------------------------------
#           Scenario: check_account_move_created_invoice
# --------------------------------------------------------
Given /^I take the created invoice (\w+)$/ do |inv_name|
  # Take the inv_name
  @invoice=AccountInvoice.find(:first,:domain=>[['name','=',inv_name]])
end

Then /^I should have an linked account move with 2 lines with a posted status$/ do
  
end

Then /^the associated account move debit amount should be = 608\.27 on the account choosen in the invoice line$/ do
  
end

Then /^the amount currency should be 1000\.0 CHF with a valid status$/ do
  
end

Then /^the associated account move credit amount should be = 608\.27 on the account of the partner account payable property$/ do
  
end

Then /^the amount currency should be \-1000\.0 CHF with a valid status$/ do
  
end

# --------------------------------------------------------
#           Scenario: make_and_validate_payments_with_bank_statement
# --------------------------------------------------------

Given /^I make a new bank statement$/ do
  
end

# --------------------------------------------------------
#           Scenario: make_and_validate_payments_with_pay_invoice_wizard
# --------------------------------------------------------

Given /^I call the Pay invoice wizard$/ do
  AccountInvoice.rpc_create_with_all('account.invoice.pay',@invoice.id)
end

# --------------------------------------------------------
#           Not Use anymore
# --------------------------------------------------------

