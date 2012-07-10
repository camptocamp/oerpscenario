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
    AccountJournal.write(j_ids, {'entry_posted'=> true})
  end
end
