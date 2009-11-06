#Author Nicolas Bessi 2009 
#copyright Camptocamp SA
@utils = ScenarioUtils.new
Before do
    @res = false
    @part = false
    @account_id = false
    @prod = false
end




Given /^I am loged as (\w+) user with password (\w+) used$/ do |user, pass|
   
  @utils.setConnexionfromConf(user=user, password=pass)
end

Given /^I made a search on object res\.partner\.contact$/ do    
    @res = ResPartnerContact.find(:all) # we find by id 1
end

When /^I press search$/ do
end

Then /^the result  should be > 0/ do
    @res.should be_true
end

Given /^I want to create a partner named (\w+) with default receivable account$/ do |name|
    @part = ResPartner.new(:name => "#{name}, #{rand.to_s[0..10]}")
end

Then /^I get a receivable account$/ do
    @account_id = AccountAccount.find(:first, :domain=>[['type', '=', 'receivable'],['active','=',1]])
    puts "find #{@account_id.code} accounts"
    @account_id.should be_true
end

When /^I press create$/ do
end

Then /^I should get a partner id$/ do
  @part.property_account_receivable = @account_id.id
  @part.save.should be_true
end

