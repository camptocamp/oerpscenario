###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Author Nicolas Bessi & Joel Grand-Guillaume 2009 
#    Copyright Camptocamp SA
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 Afero of the License, or
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

##############################################################################
#           Scenario: Validate the model ir.property into the DB
##############################################################################

##############################################################################
Given /^I check the integrity of ir\.property named (\w+)$/ do |name_property|
   @properties=IrProperty.find(:first,:domain=>[['name','=',name_property]])
end
##############################################################################
Then /^I check the value of ir.property and it should not start with a space$/ do
    value = @properties.value.to_s
    test_result = value.start_with?(' ')
    test_result.should be_false
end

##############################################################################
#           Scenario: Validate the partner creation
##############################################################################

##############################################################################
Given /^I want to create a partner named (\w+) with default receivable account$/ do |name|
    @part = ResPartner.new(:name => "#{name}, #{rand.to_s[0..10]}")
end

##############################################################################
Then /^I get a receivable account$/ do
    @account_id = AccountAccount.find(:first, :domain=>[['type', '=', 'receivable'],['active','=',1]])
    @account_id.should be_true
end

##############################################################################
Then /^I should get a partner id$/ do
    @part.property_account_receivable = @account_id.id
    @part.save.should be_true
end

##############################################################################
Given /^the company currency is set to (\w+)$/ do |currency| 
  # TODO not the first, but the one of the user..
  company = ResCompany.find(:first)
  cmpcurrency = ResCurrency.find(:first, :domain=>[['name','=',currency]], :fields =>['id', 'code'])
  company.currency_id = cmpcurrency.id
  company.save
  company = nil
end

##############################################################################
Given /^the following currency rate settings are:$/ do |currencies|
  currencies.hashes.each do |c|
    curr_id = ResCurrency.find(:first, :domain=>[['name','=',c[:code]]], :fields=>['id']).id
    rate_to_clean = ResCurrencyRate.find(:first, :domain=>[['currency_id','=',curr_id]], :fields=>['id'])
    if rate_to_clean
        rate_to_clean.destroy
    end
  end
  currencies.hashes.each do |c|
    c[:currency_id] = ResCurrency.find(:first, :domain=>[['name','=',c[:code]]], :fields=>['id']).id
    ResCurrencyRate.create(c)
  end
end

##############################################################################
Given /^the demo data are loaded$/ do
  IrModuleModule.load_demo_data_on_installed_modules(@openerp)
  m=IrModuleModule.find(:first,:domain=>[['name','=','base']], :fields=>["name","base"])
  m.should be_true
  m.demo.should be_true
  m = nil 
end



##############################################################################
#           Scenario: Create shortcuts
##############################################################################
Given /^the menu "([^\"]*)" exists$/  do |menu_name|
  @menu_found = IrUiMenu.find(:first, :domain => [['name', '=', menu_name]])
  @menu_found.should_not be_nil
end

Then /^we create a shortcut on all users$/ do
  ResUsers.all.each do |user|
    shortcut = IrUiView_sc.find(:first,
                                :domain => [
                                  ['user_id', '=', user.id],
                                  ['res_id' , '=', @menu_found.id],
                                  ['resource', '=', 'ir.ui.menu']])
    unless shortcut
       shortcut = IrUiView_sc.new(:user_id => user.id,
                                  :res_id => @menu_found.id,
                                  :resource => 'ir.ui.menu',
                                  :name => @menu_found.name)
      shortcut.save
    end
  end
end

Given /^the shortcut "([^\"]*)" is assigned to some users$/ do |shortcut_name|
  @shortcuts = IrUiView_sc.find(:all, :domain => [['name', '=', shortcut_name]])
end
Then /^delete it on all users$/ do
  if @shortcuts
    @shortcuts.each do |shortcut|
      shortcut.destroy
    end
  end
end

