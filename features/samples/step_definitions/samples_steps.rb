###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Author Nicolas Bessi 2009 
#    Copyright Camptocamp SA
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
##############################################################################
Before do
    @res = false
    @part = false
    @account_id = false
    @prod = false
end

##############################################################################
Then /^I should get account_payable and pricelist proprety$/ do
 part = ResPartner.find(@part.id, :fields => ["property_account_payable","property_account_receivable"])
 part.property_account_payable.should be_true
 part.property_account_receivable.should be_true

end

##############################################################################
Given /^I want to create a partner named (\w+)$/ do |name|
     @part = ResPartner.new(:name => "#{name}, #{rand.to_s[0..10]}")
     @part.create.should be_true
end

##############################################################################
Then /^I copy the partner$/ do
end

##############################################################################
Then /^I should get a copied partner id$/ do
  pending
  res = @part.copy() #copy function ot found
   res.should be_true
end

##############################################################################
Given /^I want to create a prodcut named (.*)$/ do |name|
  @prod = ProductProduct.new(:name => "#{name}, #{rand.to_s[0..10]}")
  @prod.should be_true
end

##############################################################################
Then /^I get a product category$/ do
  res  = ProductCategory.find(:first)
  res.should be_true
  @prod.categ_id = res.id
end

##############################################################################
Then /^I should get a product id$/ do
  @prod.create.should be_true
end

##############################################################################
Then /^I should get property_expense_account and property_income_account proprety$/ do
    prod = ProductProduct.find(@prod.id, :fields => ["property_account_income","property_account_expense"])
    prod.property_account_income.should be_true
    prod.property_account_expense.should be_true
end

##############################################################################
Given /^I want to create a prodcut to copy named automatedtestprodcutcopy$/ do
  pending
end

##############################################################################
Then /^I copy the product$/ do
  pending
end

