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
    @part = false
end

##############################################################################
Given /^I made a search on a partner named (\w+)$/ do |name|
   @part = ResPartner.find(:first, :domain=>[['name', '=', name],['active','=',1]])
end

##############################################################################
Then /^the result  should be true$/ do
  puts @part
  @part.should be_true
end

##############################################################################
Then /^the country code should be (\w+)$/ do |country|
    res = false
    @part.address.each do |add|
        if add.country_id.code == country :
          res = true
          break
        end
    res.should be_true 
    end
end


