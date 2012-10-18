# Given /^I open the credit invoice$/ do
#  @found_item.should_not be_nil,
#   "no invoice found"
#  ['draft', 'open'].should include(@found_item.state),
#   "Invoice is not draf or open"
#  if @found_item.state == 'draft'
#    @found_item.wkf_action('invoice_open')
#  end
# end

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

Then /^I should have "(.*?)" credit lines of level "(.*?)"$/ do |number, level|
  CreditManagementLine.find_all_by_level(level).length.should eq (number.to_i)
end

Then /^credit lines should have following values:$/ do |table|
  h_list = table.hashes
  h_list.each do | h |
    h.delete_if {|k, v| v.empty?}
  end
  errors = []
  h_list.each do | row |
    account = AccountAccount.find_by_name(row['account'], :fields=>['id'])
    account.should_not be_nil, "no account named #{row['account']} found"

    profile = CreditManagementProfile.find_by_name(row['profile'], :fields=>['id'])
    profile.should_not be_nil, "No account #{row['account']} found"

    partner = ResPartner.find_by_name(row['partner'], :fields=>['id'])
    partner.should_not be_nil, "No partner #{row['partner']} found"

    move_line = AccountMoveLine.find_by_name(row['move line'], :fields=>['id'])
    move_line.should_not be_nil, "No move line #{row['move line']} found"

    rule = CreditManagementProfileRule.find_by_name(row['profile rule'], :fields=>['id'])
    rule.should_not be_nil, "No profile rune #{row['profile rule']} found"

    domain = [['account_id', '=', account.id], ['profile_id', '=', profile.id],
              ['partner_id', '=', partner.id], ['move_line_id', '=', move_line.id],
              ['profile_rule_id', '=', rule.id], ['amount_due', '=', row.fetch('amount due', 0.0)],
              ['state', '=', row.fetch('state')], ['level', '=', row.fetch('level', 0.0)],
              ['canal', '=', row.fetch('canal')], ['balance_due', '=', row.fetch('balance', 0.0)],
              ['date_due', '=',  row.fetch('date due')], ['date', '=', row.fetch('date')]]
    if row['currency']
        curreny = ResCurrency.find_by_name(row['currency'], :fields=>['id'])
        domain.push ['currency_id', '=', curreny.id]
    end
    pp domain
    line = CreditManagementLine.find(:first, :domain=>domain)
    line.should_not be_nil, "Can not find line #{row.inspect}"
  end
end
