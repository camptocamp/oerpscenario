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
require 'rubygems'
require 'cucumber'
require 'cucumber/rake/task'

##############################################################################
#  Sample
##############################################################################

# Launch the @demo tag, to install demo data on
# installed module
Cucumber::Rake::Task.new(:demo) do |task|
  task.cucumber_opts = ["-t","@demo","features"]
end

# Launch the @quality tag, run the base_module_quality
# module tests on all installed module
Cucumber::Rake::Task.new(:quality) do |task|
  task.cucumber_opts = ["-t","@quality","features"]
end

# Launch all tests among the magento instance
Cucumber::Rake::Task.new(:test_magento) do |task|
  task.cucumber_opts = ["-t","@test_magento","features"]
end


##############################################################################
#  Useful tags : with dependencies on others (same as OpenERP)
##############################################################################

# Launch the @compile tag in order to check it
Cucumber::Rake::Task.new(:compile) do |task|
  task.cucumber_opts = ["-t","@compile","features"]
end

# Launch all the tags init_base
Cucumber::Rake::Task.new(:init_base => ['compile']) do |task|
  task.cucumber_opts = ["-t","@init_base","features"]
end

# Launch all the tags init_account
Cucumber::Rake::Task.new(:init_account => ['init_base']) do |task|
  task.cucumber_opts = ["-t","@init_account","features"]
end

# Launch all the tags init_sale
Cucumber::Rake::Task.new(:init_sale => ['init_account']) do |task|
  task.cucumber_opts = ["-t","@init_sale","features"]
end

# Launch all the tags init_purchase
Cucumber::Rake::Task.new(:init_purchase => ['init_account']) do |task|
  task.cucumber_opts = ["-t","@init_purchase","features"]
end

# Launch all the tags to have a valid magento
# intance configured
Cucumber::Rake::Task.new(:init_magento => ['init_sale','init_purchase']) do |task|
  task.cucumber_opts = ["-t","@init_magento","features"]
  # task.cucumber_opts = ["-t","@init_base,@init_account,@init_sale,@init_purchase","features"]
end





