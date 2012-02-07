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

Cucumber::Rake::Task.new(:demo,"Launch the installation of demo data on installed modules") do |task|
  task.cucumber_opts = ["-t","@demo","features"]
end

Cucumber::Rake::Task.new(:test_magento,"Launch Magento synchronisazation tests : attributes sets, attributes, product,.. (run rake init_magento first)") do |task|
  task.cucumber_opts = ["-t","@test_magento","features"]
end


##############################################################################
#  Useful tags : with dependencies on others (same as OpenERP)
##############################################################################
Cucumber::Rake::Task.new(:compile, "Launch the test with tag @compile, just to verify all libs are well installed") do |task|
  task.cucumber_opts = ["-t","@compile","features"]
end

Cucumber::Rake::Task.new({:init_base => ['compile']},"Install the base module, languages ans configure the company infos (header, logo,..)") do |task|
  task.cucumber_opts = ["-t","@init_base","features"]
end

Cucumber::Rake::Task.new({:init_account => ['init_base']},"Install the account module, configure basic taxes, journal and bank") do |task|
  task.cucumber_opts = ["-t","@init_account","features"]
end

Cucumber::Rake::Task.new({:init_sale => ['init_account']},"Install the sale module and create pricelists") do |task|
  task.cucumber_opts = ["-t","@init_sale","features"]
end

Cucumber::Rake::Task.new({:init_purchase => ['init_account']},"Install the purchase module ") do |task|
  task.cucumber_opts = ["-t","@init_purchase","features"]
end

Cucumber::Rake::Task.new({:init_magento => ['init_sale','init_purchase']},"Install the required module for magento, create Magento instance and load mapping") do |task|
  task.cucumber_opts = ["-t","@init_magento","features"]
end





