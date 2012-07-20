Given /^I open the credit invoice$/ do
 @found_item.should_not be_nil,
  "no invoice found"
 ['draft', 'open'].should include(@found_item.state),
  "Invoice is not draf or open"
 if @found_item.state == 'draft'
   @found_item.wkf_action('invoice_open')
 end
end

Then /^I launch the credit run$/ do
  @found_item.should_not be_nil,
  "no run found"
  @found_item.generate_credit_lines()
end

Given /^there is "(.*?)" credit lines$/ do |state|
  @credit_lines = CreditManagementLine.find_all_by_state(state)
  @credit_lines.should_not be_empty,
  "not #{state} lines found"
end

Given /^I mark all draft mail to state "(.*?)"$/ do | state |
  wiz = CreditManagementMarker.new
  wiz.name = state
  wiz.mark_all = true
  wiz.save
  wiz.mark_lines
end

Then /^the draft line should be in state "(.*?)"$/ do | state |
  @credit_lines.should_not be_nil,
  "no line where stored"
  @credit_lines.each do |line|
    line = CreditManagementLine.find(line.id)
    line.state.should eql(state),
    "The line #{line.id} is not in state #{state} he is is in state #{line.state} "
  end

end

Given /^I mail all ready lines$/ do
  @credit_lines.should_not be_nil,
  "no line where stored"
  wiz = CreditManagementMailer.new
  wiz.mail_all = true
  wiz.save
  wiz.mail_lines
end

Given /^I clean all the credit lines$/ do
 CreditManagementLine.find(:all).each do | line |
    line.destroy
   end
end

Then /^my credit run should be in state "(.*?)"$/ do |state|
  @found_item.should_not be nil
  @run = CreditManagementRun.find(@found_item.id)
  @run.state.should eq(state),
  "Run state is in state #{@run.state} instead of #{state}"
end


Then /^All sent lines should be linked to a mail and in mail status "(.*?)"$/ do |status|
  @credit_lines.should_not be_nil,
  "no line where stored"
  @credit_lines.each do |line|
    line =  CreditManagementLine.find(line.id)
    line.state.should eql(status),
    "The line #{line.id} is has no mail status #{status} but #{line.state}"
  end
end
