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
  # require 'yaml'
  # puts @wizard.to_yaml
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