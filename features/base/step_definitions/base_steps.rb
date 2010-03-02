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
#           Scenario: validate_properties
##############################################################################

##############################################################################
Given /^I check the integrity of ir\.property named (\w+)$/ do |name_property|
   @properties=IrProperty.find(:first,:domain=>[['name','=',name_property]])
end
##############################################################################
Then /^I check the value of ir.property and it should not start with a space$/ do
    test_result = @properties.value.start_with?(' ')
    test_result.should be_false
end

##############################################################################
#           Scenario: check_base_contact
##############################################################################

##############################################################################
Given /^I made a search on object res\.partner\.contact$/ do    
    @res = ResPartnerContact.find(:all) # we find by id 1
end

##############################################################################
When /^I press search$/ do
end

##############################################################################
Then /^the result  should be > 0/ do
    @res.should be_true
end

##############################################################################
#           Scenario: create_partner
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
When /^I press create$/ do
end

##############################################################################
Then /^I should get a partner id$/ do
    @part.property_account_receivable = @account_id.id
    @part.save.should be_true
end
