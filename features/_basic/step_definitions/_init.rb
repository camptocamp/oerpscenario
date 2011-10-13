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
    if not $utils
        $utils = ScenarioUtils.new
        puts 'reset connection'
    end
    @res = false
    @part = false
    @account_id = false
    @prod = false
    
end

##############################################################################
Given /^I am logged as (\w+) user with password (\w+) used$/ do |user, pass|
    begin
        if $utils.ready?
            $utils.login(:user =>user,:pwd => pass)
        else
            puts 'Attempt to connect'
            $utils.setConnexionfromConf(:user=>user, :pwd=>pass)            
        end
    rescue Exception => e
        puts e.to_s
        puts 'Force reconnect'
        $utils.setConnexionfromConf(:user=>user, :pwd => pass)
    end
end

##############################################################################
Given /^I am logged as (\w+) user with the password set in config used$/ do |user, pass|
    begin
        if $utils.ready?
            $utils.login(user, pass)
        else
            puts 'Attempt to connect'
            $utils.setConnexionfromConf()            
        end
    rescue Exception => e
        puts e.to_s
        puts 'Force reconnect'
        $utils.setConnexionfromConf()
    end
end
