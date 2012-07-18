Given /^I correct the period default set up \(all special by default\) :$/ do
  p_ids =  AccountPeriod.search([['fiscalyear_id', '=', 1]])
  if p_ids
    AccountPeriod.write(p_ids, {'special'=> false})
  end
end

Given /^I set the following currency rates :$/ do |table|
   table.hashes.each do |row|
    date =  Time.new().strftime(row['date'])
    currency = ResCurrency.find_by_name(row['currency'], :fields=>['id'])
    currency.should_not be_nil,
    "Could not find curreny #{row['currency']}"
    curr_rate = ResCurrencyRate.find_by_name_and_currency_id(date, currency.id)
    unless curr_rate
      puts " creating new rate"
      curr_rate = ResCurrencyRate.new
      curr_rate.name = date
      curr_rate.currency_id = currency.id
    end
    curr_rate.rate = row['rate']
    curr_rate.save
   end

end

Given /^I allow cancelling entries on all journals$/ do
  j_ids =  AccountJournal.search([])
  if j_ids
    AccountJournal.write(j_ids, {'update_posted'=> true})
  end
end

Given /^I open the credit invoice$/ do
 @found_item.should_not be_nil,
  "no invoice found"
 ['draft', 'open'].should include(@found_item.state),
  "Invoice is not draf or open"
 if @found_item.state == 'draft'
   @found_item.wkf_action('invoice_open')
 end
end

Given /^I import invoice "(.*?)" using import invoice button$/ do |inv_name|
  invoice_to_import = AccountInvoice.find_by_name(inv_name)
  invoice_to_import.should_not be_nil,
  "Can't find invoice #{inv_name}"
  @found_item.should_not be_nil, "No statement find"
  @found_item.is_a?(AccountBankStatement).should be_true, "found item is not a bank statement"
  @found_item.line_ids.each do |line|
    line.destroy
  end
  wiz = AccountStatementFromInvoiceLines.new()
  acc_id = invoice_to_import.account_id.id
  invoice_to_import.move_id.should_not be_nil
  move_id = invoice_to_import.move_id.id
  lines = AccountMoveLine.search([['move_id', '=', move_id], ['account_id', '=', acc_id]])
  lines.should_not be_empty, "Could not find line to import"
  wiz.line_ids = lines
  wiz.save
  wiz.populate_statement({'statement_id'=>@found_item.id})
end


Given /^I set bank statement end-balance$/ do
  @found_item.should_not be_nil, "No statement find"
  @found_item.is_a?(AccountBankStatement).should be_true, "found item is not a bank statement"
  @found_item.balance_end_real = @found_item.balance_end
  @found_item.save
  @found_item = AccountBankStatement.find(@found_item.id)
  @found_item.balance_end.should eq @found_item.balance_end_real
end

When /^I confirm bank statement$/ do
   @found_item.should_not be_nil, "No statement find"
   @found_item.is_a?(AccountBankStatement).should be_true, "found item is not a bank statement"
   @found_item.button_confirm_bank
end

Then /^I should have following journal entries in voucher:$/ do |table|
  h_list = table.hashes
  h_list.each do | h |
    h.delete_if {|k, v| v.empty?}
  end
  @found_item.should_not be_nil, "No statement find"
  @found_item.is_a?(AccountBankStatement).should be_true, "found item is not a bank statement"
  @found_item.move_line_ids.length.should eq h_list.length
   # "We should have #{h_list.length} lines  but we have #{@found_item.move_line_ids.length}"
  errors = []
  # we can use inverse approach
  h_list.each do | row |
    account = AccountAccount.find_by_name(row['account'], :fields=>['id'])
    account.should_not be_nil, "no account named #{row['account']} found"
    if row['curr.']
      currency = ResCurrency.find_by_name(row['curr.'], :fields=>['id'])
      currency.should_not be_nil, "Could not find currency #{row['curr.']}"
      currency_id = currency.id
    else
      currency_id = false
    end
    pname = Time.new().strftime(row['period'])
    period = AccountPeriod.find_by_name(pname, :fields=['id'])
    period.should_not be_nil, "no period #{pname} found"
    domain = [['account_id', '=', account.id], ['period_id', '=', period.id],
              ['date', '=', Time.new().strftime(row['date'])], ['credit', '=', row.fetch('credit', 0.0)],
              ['debit', '=', row.fetch('debit', 0.0)],['amount_currency', '=', row.fetch('curr.amt', 0.0)],
              ['currency_id', '=', currency_id],
              ['id', 'in', @found_item.move_line_ids.collect {|x| x.id}]]
    if row['reconcile']
        domain.push ['reconcile_id', '!=', false]
    else
        domain.push ['reconcile_id', '=', false]
    end
    if row['partial']
        domain.push ['reconcile_partial_id', '!=', false]
    else
        domain.push ['reconcile_partial_id', '=', false]
    end
    pp domain
    line = AccountMoveLine.find(:first, :domain=>domain)
    line.should_not be_nil, "Can not find line #{row.inspect}"
  end
end

Given /^My invoice "(.*?)" is in state "(.*?)" reconciled with a residual amount of "(.*?)"$/ do |inv_name, state, residual|
  invoice = AccountInvoice.find_by_name(inv_name)
  invoice.should_not be_nil, "Can't find invoice #{inv_name}"
  invoice.residual.should be_within(0.0001).of(residual.to_f) , "residual is #{invoice.residual} instead of #{residual}"
  invoice.state.should eq state
end

Given /^the bank statement is linked to period "(.*?)"$/ do |p_name|
  @found_item.should_not be_nil, "No statement find"
  @found_item.is_a?(AccountBankStatement).should be_true, "found item is not a bank statement"
  pname = Time.new().strftime(p_name)
  period = AccountPeriod.find_by_name(pname, :fields=['id'])
  period.should_not be_nil, "no period #{pname} found"
  @found_item.period_id = period.id
  @found_item.save
end

Given /^the line amount should be (.*)$/ do |amount|
  @found_item.amount.should eq amount.to_f
end
Given /^I modify the line amount to (.*)$/ do |amount|
  @found_item.amount = amount.to_f
  @found_item.save
end

Then /^I modify the bank statement line amount to (.*)$/ do |amount|
  @found_item.on_change('onchange_amount',:amount,[],amount.to_f)
  @found_item.amount = amount.to_f
  @found_item.save
end


########################################################################################
#Added by guewen lastly for scenario 401 using pay invoice button


Given /^I pay the customer invoice with name "([^"]+)"$/ do |invoice_name|
  invoice = AccountInvoice.find_by_name invoice_name
  invoice.should_not be_nil, "Invoice with #{invoice_name} not found"

  payment_context = invoice.invoice_pay_customer['context']
  @voucher = AccountVoucher.new({}, false, payment_context)
end

Then /^I set the voucher paid amount to "(\d+)"$/ do |amount_paid|
  @voucher.on_change('onchange_amount', :amount, [],
                     amount_paid.to_f,
                     @voucher.payment_rate,
                     @voucher.partner_id.id,
                     @voucher.journal_id ? @voucher.journal_id.id : false,
                     @voucher.currency_id ? @voucher.currency_id.id : false,
                     @voucher.type,
                     @voucher.date,
                     @voucher.payment_rate,
                     @voucher.company_id ? @voucher.company_id.id : false)
  @voucher.amount = amount_paid.to_f
end

Then /^I set the voucher payment method to "([^"]+)"$/ do |journal_name|
  journal = AccountJournal.find_by_name(journal_name, :fields => ['id'])
  journal.should_not be_nil, "Journal #{journal_name} not found"

  @voucher.on_change('onchange_journal', :journal_id, [],
                     journal.id,
                     @voucher.line_ids.map(&:id),
                     @voucher.tax_id ? @voucher.tax_id.id : false,
                     @voucher.partner_id.id,
                     @voucher.date,
                     @voucher.amount,
                     @voucher.type,
                     @voucher.company_id ? @voucher.company_id.id : false)
  @voucher.journal_id = journal.id
end

Then /^I set the payment options to choose the write-off account code:"([^"]+)"$/ do |account_code|
  account = AccountAccount.find_by_code(account_code, :fields => ['id'])
  account.should_not be_nil

  @voucher.payment_option = 'with_writeoff'
  @voucher.writeoff_acc_id = account.id
end

Then /^I set the voucher's first line to be "([^"]+)" with a "(\w+)" allocation$/ do |reconcile, allocation|
  reconciled = reconcile == 'full reconcile'

  @voucher = AccountVoucher.find(@voucher.id)

  line = @voucher.line_cr_ids[0]
  line.reconcile = reconciled
  line.amount = allocation.to_f
  line.save

  @voucher = AccountVoucher.find(@voucher.id)
  @voucher.on_change('onchange_line_ids', :line_cr_ids, [@voucher.id],
                     @voucher.line_dr_ids.empty? ? [] : @voucher.line_dr_ids.map(&:id),
                     @voucher.line_cr_ids.empty? ? [] : @voucher.line_cr_ids.map(&:id),
                     @voucher.amount,
                     @voucher.currency_id ? @voucher.currency_id.id : false)
  @voucher.save
end

Then /^I save the voucher$/ do
  @voucher.save
end

Then /^I validate the voucher$/ do
  @voucher.proforma_voucher
end


