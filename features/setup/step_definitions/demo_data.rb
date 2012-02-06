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

@modules = false
Before do
  # Initiate vars used to stored object used trought the tests
  # @irvalues = false
end


##############################################################################
#           Scenario: Install demo datas on installed modules
##############################################################################
Given /^I want to load the demo data on all installed modules$/ do
  @modules=IrModuleModule.find(:all,:domain=>[['state','=','installed']], :fields=>['id', "demo"])
  # @modules=IrModuleModule.find(:all,:state=>'installed')
  @modules.should be_true
end
##############################################################################
When /^I tic the demo data field on all found modules$/ do
  @modules.each do |m|
    m.demo=true
    m.save
    m.demo.should be_true
  end
end
##############################################################################
When /^ask to upgrade the (\w+) module$/ do |module_name|
  m=IrModuleModule.find(:first,:domain=>[['name','=',module_name]], :fields=>['id', "state"])
  m.should be_true
  m.state='to upgrade'
  m.save
  m.state.should == 'to upgrade'
  m = nil
end
##############################################################################
When /^run the update$/ do
  res = IrModuleModule.update_needed_modules()
  res.should be_true
end
##############################################################################
Then /^I should see some demo data loaded$/ do
  partner=ResPartner.find(:first,:name=>'ASUStek',:fields=>['id'])
  partner.should be_true
  cat=ResPartnerCategory.find(:first,:name=>'OpenERP Partners', :fields=>['id'])
  cat.should be_true
  partner = nil
  cat = nil 
end


