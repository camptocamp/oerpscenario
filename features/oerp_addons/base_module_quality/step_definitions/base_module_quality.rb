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
@test_result = false

##############################################################################
#           Scenario: Install base_module_quality and run the tests
##############################################################################

##############################################################################
Given /^I want to run the quality tests provided by base_module_quality on installed module$/ do
  @modules=IrModuleModule.find(:all,:domain=>[['name','=','base_module_quality']], :fields => ['id, demo, update, state'])
  @modules.should be_true
end
##############################################################################
When /^I install the base_module_quality$/ do
  res = IrModuleModule.install_modules(@openerp, [@modules[0]])
  res.should be_true
end
##############################################################################
And /^run the quality check on every installed module$/ do
  @modules=IrModuleModule.find(:all,:domain=>[['state','=','installed']], :fields => ['id, demo, update, state'])
  @modules.should be_true
  @test_result=IrModuleModule.run_base_quality_test(@modules)
  @test_result.should be_true
end
##############################################################################
Then /^I should have a report on every module$/ do
  @modules.count.should == @test_result.count
end
##############################################################################
Then /^all module, except (\w+), should have a final score greater than (.*) percent$/ do |except_module,percent|
  @test_result.each do |test_case|
    if not test_case.name == except_module
      test_case.final_score.to_f.should > percent.to_f/100
    end
  end
end
##############################################################################
And /^above is a detailed summary of the results$/ do
  summary=''
  details=''
  @test_result.each do |test_case|
    output = ModuleQualityCheck.get_formatted_results(test_case)
    summary += output[:summary]
    details += output[:result]
  end
  announce("Summary of results: \n-------------------------------------------------------\n"+summary)
  announce("Details of results: \n-------------------------------------------------------\n"+details)
end

