#Author Nicolas Bessi 2009 
#copyright Camptocamp SA
Before do
    @connector = OERPRPCConnector.new
    @current_model = ''
    @account_id = ''
    @partner_id = ''
    @partname = ''
    @product_name = ''
    @product_categ = ''
    @product_id = ''
end




Given /^I am loged as admin user with password (\w+) used$/ do |pass|
  @connector.setConnexionfromConf('admin', pass)
  res = @connector.login().should be_true
end

Given /^I made a search on object res\.partner\.contact$/ do    
    @current_model = 'res.partner.contact'
end

When /^I press search$/ do
end

Then /^the result  should be > 0/ do
    res = @connector.search(@current_model)
    puts "found #{res.length} addresses"
    res.should be_true
end

Given /^I want to create a partner name (\w+) with default receivable account$/ do |name|
    @partname = name
end

Then /^I get a receivable account$/ do
    @account_id = @connector.search('account.account',[['type','=','receivable']])
    puts "find #{@account_id.length} accounts"
    @account_id.should be_true
end

When /^I press create$/ do
end

Then /^I should get a partner id$/ do
  res = @connector.create('res.partner', {'name'=>"#{@partname}, #{rand.to_s[0..10]}",'property_account_receivable'=> @account_id})
  @partner_id = res
  res.should be_true
end
Then /^I should get account_payable and pricelist proprety$/ do
  res = @connector.read('res.partner', [@partner_id],  ['name','property_product_pricelist','property_account_payable'])
  res[0]['property_account_payable'].should be_true
end

Given /^I want to create a partner named (\w+)$/ do |name|
    res = @connector.create('res.partner', {'name'=>"#{name}, #{rand.to_s[0..10]}"})
    @partner_id = res
    res.should be_true
end

Then /^I copy the partner$/ do
end

Then /^I should get a copied partner id$/ do
  res = @connector.copy(@partner_id, inputmodel='res.partner')
  res.should be_true
end


Given /^I want to create a prodcut named (.*)$/ do |name|
  @product_name = name
end

Then /^I get a product category$/ do
  res = @connector.search('product.category', [])
  res.should be_true
  @product_categ = res[0]
end

Then /^I should get a product id$/ do
  res = @connector.create('product.product', {'name'=>"#{@product_name}, #{rand.to_s[0..10]}", 'categ_id'=>@product_categ})
  res.should be_true
  @product_id = res
end

Then /^I should get property_expense_account and property_income_account proprety$/ do
    res = @connector.read('product.product', [@product_id],  ['name','property_account_income','property_account_expense'])
    res[0]['property_account_income'].should be_true
    res[0]['property_account_expense'].should be_true
end

Given /^I want to create a prodcut to copy named automatedtestprodcutcopy$/ do
  pending
end

Then /^I copy the product$/ do
  pending
end

