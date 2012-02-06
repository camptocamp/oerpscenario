###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Author Joel Grand-Guillaume 2009 
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

Given /Build is OK/ do
end

Given /^I have file "([^"]*)"$/ do |f_name|
  File.exists?(f_name).should be_true
end

Given /^module "([^"]*)" is installed$/ do |mod_name|  
  mod = IrModuleModule.find(:first, :domain=>[['name', '=', mod_name], ['state', '=', 'installed']])
  unless mod
    mod_up = IrModuleModule.find(:first )
    mod_up.should_not be_nil
    mod_up.call('update_list')
    mod = IrModuleModule.find(:first, :domain=>[['name', '=', mod_name]])
    mod.should_not be_nil
    IrModuleModule.install_modules([mod])
  end
  mod = IrModuleModule.find(:first, :domain=>[['name', '=', mod_name], ['state', '=', 'installed']])
  mod.should_not be_nil
end