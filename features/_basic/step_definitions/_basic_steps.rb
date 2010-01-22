###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Author Nicolas Bessi 2009 
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
unless $utils
    $utils = ScenarioUtils.new
end
Before do
    if not $utils :
        $utils = ScenarioUtils.new
        puts 'reset connection'
    end
    @res = false
    @part = false
    @account_id = false
    @prod = false
    
end

##############################################################################
Given /^I am loged as (\w+) user with password (\w+) used$/ do |user, pass|
    begin
        unless $utils.ready? :
            $utils.setConnexionfromConf(user=user, password=pass)
        end
    rescue Exception => e
        puts e.to_s
        puts 'Force reconnect'
        $utils.setConnexionfromConf(user=user, password=pass)
    end
end

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


