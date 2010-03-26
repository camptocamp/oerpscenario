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
