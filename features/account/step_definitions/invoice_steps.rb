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
#           Scenario: make_and_validate_payments_with_pay_invoice_wizard
# --------------------------------------------------------

Given /^I call the Pay invoice wizard$/ do
  # TODO Find a way to call wizard
  @wizard = @invoice.old_wizard_step('account.invoice.pay') #tip: you can inspect the wizard fields, arch and datas
  @wizard.should be_true
end


When /^I partially pay (.*) (\w+)\.\- on the (.*)$/ do |amount,currency,date_p|
  date_p=Date.parse(str=date_p).to_s
  # Look for the right currency journal
  @journal = AccountJournal.find(:first, :domain=>[['currency','=',ResCurrency.find(:first, :domain=>[['code','=',currency]]).id]])
  @journal.should be_true
  step_dict=@wizard.datas
  step_dict["amount"] = amount.to_f
  step_dict["journal_id"] = @journal.id
  step_dict["name"] ='OERPScenario test'
  step_dict["date"] = date_p
  @wizard.writeoff_check(step_dict) #use the button name as the wizard method
  # take the writeoff account
  writeoff_acc_id = false
  step_dict['writeoff_acc_id'] = writeoff_acc_id
  step_dict['writeoff_journal_id'] = @journal.id
  step_dict['comment'] = 'OERPScenario test'
  # step_dict['period_id'] = AccountPeriod.find(:first, :domain => [['']])
  # @wizard.reconcile(step_dict)
  # @wizard.reconcile({"date" => date_p,"amount" => amount.to_f, "journal_id" => @journal.id, "writeoff_acc_id" => writeoff_acc_id,"writeoff_journal_id" => @journal.id, "comment" => 'OERPScenario test'})
  # wizard.reconcile({:journal_id => 6, :name =>"from_rails"}) #if you want to pay all; will give you a reloaded invoice
  # if you want a payment with a write off:
  # wizard.writeoff_check({"amount" => 12, "journal_id" => 6, "name" =>'from_rails'}) #use the button name as the wizard method
  # wizard.reconcile({required missing write off fields...}) #will give you a reloaded invoice because state is 'end'
  
  
end

Then /^I should see a residual amount of (.*) (\w+)\.\-$/ do |amount,currency|
  @invoice.residual.should == amount.to_f 
end




# --------------------------------------------------------
#           Not Use anymore
# --------------------------------------------------------

