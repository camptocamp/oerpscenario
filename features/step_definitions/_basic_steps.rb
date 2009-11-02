#Author Nicolas Bessi 2009 
#copyright Camptocamp SA
Before do
    @utils = ScenarioUtils.new
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

Then /^I should get account_payable and pricelist proprety$/ do
 part = ResPartner.find(@part.id, :fields => ["property_account_payable","property_account_receivable"])
 part.property_account_payable.should be_true
 part.property_account_receivable.should be_true

end

Given /^I want to create a partner named (\w+)$/ do |name|
     @part = ResPartner.new(:name => "#{name}, #{rand.to_s[0..10]}")
     @part.create.should be_true
end

Then /^I copy the partner$/ do
end

Then /^I should get a copied partner id$/ do
  pending
  # res = @part.copy() #copy function ot found
  # res.should be_true
end


Given /^I want to create a prodcut named (.*)$/ do |name|
  @prod = ProductProduct.new(:name => "#{name}, #{rand.to_s[0..10]}")
end

Then /^I get a product category$/ do
  res  = ProductCategory.find(:first)
  res.should be_true
  @prod.categ_id = res.id
end

Then /^I should get a product id$/ do
  @prod.create.should be_true
end

Then /^I should get property_expense_account and property_income_account proprety$/ do
    prod = ProductProduct.find(@prod.id, :fields => ["property_account_income","property_account_expense"])
    prod.property_account_income.should be_true
    prod.property_account_expense.should be_true
end

Given /^I want to create a prodcut to copy named automatedtestprodcutcopy$/ do
  pending
end

Then /^I copy the product$/ do
  pending
end

