
# --------------------------------------------------------
#           Background
# --------------------------------------------------------

# And the company currency is set to EUR 
Given /^the company currency is set to (\w+)$/ do |currency| 
  # TODO not the first, but the one of the user..
  company = ResCompany.find(:first)
  cmpcurrency = ResCurrency.find(:first, :domain=>[['code','=',currency]])
  company.currency_id = cmpcurrency.id
  company.save
end

# Reset all named currencies to given rates
Given /^the following currency rate settings are:$/ do |currencies|
  # TODO : Optimize that, I make it not that good :(
  # clean rate on currency before set them
  currencies.hashes.each do |c|
    rate_to_clean = ResCurrencyRate.find(:first, :domain=>[['currency_id','=',ResCurrency.find(:first, :domain=>[['code','=',c[:code]]]).id]])
    if rate_to_clean :
        rate_to_clean.destroy
    end
  end
  currencies.hashes.each do |c|
    c[:currency_id] = ResCurrency.find(:first, :domain=>[['code','=',c[:code]]]).id
    ResCurrencyRate.create(c)
  end
end

# Look for a journal in the asked currency, if doen't exist then create it
Given /^a (\w+) journal in (\w+) exists$/ do |type,currency|
  # Take the currency
  currency_id = ResCurrency.find(:first, :domain=>[['code','=',currency]]).id
  # Look for the asked journal
  journal = AccountJournal.find(:first, :domain=>[['type','=',type],['currency','=',currency_id]])
  if not journal:
    journal = AccountJournal.new({
      :type => type,
      :name => type + ' ' + currency + ' Journal',
      # Take the first found view
      :view_id => AccountJournalView.find(:first).id,
      # Take the first sequence with 'Account Journal' code
      :sequence_id => IrSequence.find(:first, :domain =>[['code','=','Account Journal']]).id,
      # Take the first cash account for both debit and credit
      :default_debit_account_id => AccountAccount.find(:first, :domain => [['type','=',type]]).id,
      :default_credit_account_id => AccountAccount.find(:first, :domain => [['type','=',type]]).id,
      :currency => currency_id,
    })
    journal.create
  end
end