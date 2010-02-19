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

@properties = false
Before do
    # Initiate vars used to stored object used trought the tests
    @irvalues = false
end


##############################################################################
#           Scenario: validate_created_invoice
##############################################################################
Given /^I check the integrity of ir\.property named (\w+)$/ do |name_property|
   @properties=IrProperty.find(:first,:domain=>[['name','=',name_property]])
end
##############################################################################
Then /^I check the value of ir.property and it should not start with a space$/ do
    test_result = @properties.value.start_with?(' ')
    test_result.should be_false
end

