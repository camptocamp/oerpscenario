# Given /^I open the credit invoice$/ do
#  @found_item.should_not be_nil,
#   "no invoice found"
#  ['draft', 'open'].should include(@found_item.state),
#   "Invoice is not draf or open"
#  if @found_item.state == 'draft'
#    @found_item.wkf_action('invoice_open')
#  end
# end
#

Given /^I configure the following accounts on the credit control policy with oid: "(.+)":$/ do |policy_xmlid, table|
  @policy = CreditControlPolicy.find(policy_xmlid)
  @policy.should_not be_nil, "Policy with oid #{policy_xmlid} not found"
  account_ids = table.rows.map do |code|
    AccountAccount.find_by_code(code[0], :fields => %w(id)).tap do |res|
      res.should_not be_nil, "Account with code #{code} not found"
    end
  end
  @policy.account_ids = account_ids.map(&:id)
  @policy.save
end

Then /^I launch the credit run$/ do
  @found_item.should_not be_nil,
  "no run found"
  @found_item.generate_credit_lines()
end

Given /^there is "(.*?)" credit lines$/ do |state|
  @credit_lines = CreditControlLine.find_all_by_state(state)
  @credit_lines.should_not be_empty,
  "not #{state} lines found"
end

Given /^I mark all draft email to state "(.*?)"$/ do | state |
  wiz = CreditControlMarker.new
  wiz.name = state
  lines = CreditControlLine.find(:all, :domain => [['state', '=', 'draft']], :fields => %w(id))
  wiz.line_ids = lines.map(&:id)
  wiz.save
  wiz.mark_lines
end

Then /^the draft line should be in state "(.*?)"$/ do | state |
  @credit_lines.should_not be_nil,
  "no line were stored"
  @credit_lines.each do |line|
    line = CreditControlLine.find(line.id)
    line.state.should eql(state),
    "The line #{line.id} is not in state #{state} he is is in state #{line.state} "
  end

end

Given /^I email all ready lines$/ do
  @credit_lines.should_not be_nil,
  "no line were stored"
  wiz = CreditControlEmailer.new
  lines = CreditControlLine.find(:all,
                                  :domain => [['state', '=', 'to_be_sent'],
                                              ['channel', '=', 'email']],
                                  :fields => %w(id))
  wiz.line_ids = lines.map(&:id)
  wiz.save
  wiz.email_lines
end

Given /^I clean all the credit lines$/ do
 CreditControlLine.find(:all).each do | line |
    line.destroy
   end
end

Then /^my credit run should be in state "(.*?)"$/ do |state|
  @found_item.should_not be nil
  @run = CreditControlRun.find(@found_item.id)
  @run.state.should eq(state),
  "Run state is in state #{@run.state} instead of #{state}"
end


Then /^All sent lines should be linked to a email and in email status "(.*?)"$/ do |status|
  @credit_lines.should_not be_nil,
  "no line where stored"
  @credit_lines.each do |line|
    line =  CreditControlLine.find(line.id)
    line.state.should eql(status),
    "The line #{line.id} is has no email status #{status} but #{line.state}"
  end
end

Then /^I should have "(.*?)" credit lines of level "(.*?)"$/ do |number, level|
  CreditControlLine.find_all_by_level(level).length.should eq (number.to_i)
end

Then /^the generated credit lines should have the following values:$/ do |table|
  h_list = table.hashes
  h_list.each do | h |
    h.delete_if {|k, v| v.empty?}
  end

  errors = []
  h_list.each do | row |
    account = AccountAccount.find_by_name(row['account'], :fields=>['id'])
    account.should_not be_nil, "no account named #{row['account']} found"

    policy = CreditControlPolicy.find_by_name(row['policy'], :fields=>['id'])
    policy.should_not be_nil, "No account #{row['account']} found"

    partner = ResPartner.find_by_name(row['partner'], :fields=>['id'])
    partner.should_not be_nil, "No partner #{row['partner']} found"

    move_line = AccountMoveLine.find_by_name(row['move line'], :fields=>['id'])
    move_line.should_not be_nil, "No move line #{row['move line']} found"

    level = CreditControlPolicyLevel.find_by_name_and_policy_id(row['policy level'], policy.id, :fields=>['id'])
    level.should_not be_nil, "No policy level #{row['policy level']} found"

    domain = [['account_id', '=', account.id], ['policy_id', '=', policy.id],
              ['partner_id', '=', partner.id],
              ['policy_level_id', '=', level.id], ['amount_due', '=', row.fetch('amount due', 0.0)],
              ['state', '=', row.fetch('state')], ['level', '=', row.fetch('level', 0.0)],
              ['channel', '=', row.fetch('channel')], ['balance_due', '=', row.fetch('balance', 0.0)],
              ['date_due', '=',  row.fetch('date due')], ['date', '=', row.fetch('date')]]
    if row['currency']
        curreny = ResCurrency.find_by_name(row['currency'], :fields=>['id'])
        domain.push ['currency_id', '=', curreny.id]
    end
    line = CreditControlLine.find(:all, :domain=>domain)
    line.first.should_not be_nil, "Can not find line #{row.inspect}"
    line.should have(1).things, "More than one found for #{row.inspect}"
  end

  date_lines = CreditControlLine.find(:all, :domain => [['date', '=', @found_item.date.to_s]], :fields => %w(id))
  date_lines.should have(h_list.count).items, "Too many lines generated: #{date_lines.inspect}"
end

