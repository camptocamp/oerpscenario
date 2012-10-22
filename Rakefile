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

conf_file = ''
conf_file = 'CONF=' + ENV['CONF'] || '' if ENV['CONF']

##############################################################################
#  Sample
##############################################################################

Cucumber::Rake::Task.new(:demo, "Launch the installation of demo data on installed modules") do |task|
  task.cucumber_opts = %W(--tags=@demo features #{conf_file})
end

Cucumber::Rake::Task.new(:test_magento, "Launch Magento synchronization tests : attributes sets, attributes, product,.. (run rake init_magento first)") do |task|
  task.cucumber_opts = %W(--tags=@test_magento features #{conf_file})
end


##############################################################################
#  Useful tags : with dependencies on others (same as OpenERP)
##############################################################################
Cucumber::Rake::Task.new(:compile, "Launch the test with tag @compile, just to verify all libs are well installed") do |task|
  task.cucumber_opts = %W(--tags=@compile features #{conf_file})
end

Cucumber::Rake::Task.new(:init_base, "Install the base module, languages ans configure the company infos (header, logo,..)") do |task|
  task.cucumber_opts = %W(--tags=@init_base features #{conf_file})
end
task :init_base => :compile

Cucumber::Rake::Task.new(:init_account, "Install the account module, configure basic taxes, journal and bank") do |task|
  task.cucumber_opts = %W(--tags=@init_account features #{conf_file})
end
task :init_account => :init_base

Cucumber::Rake::Task.new(:init_sale, "Install the sale module and create pricelists") do |task|
  task.cucumber_opts = %W(--tags=@init_sale features #{conf_file})
end
task :init_sale => :init_account

Cucumber::Rake::Task.new(:init_purchase, "Install the purchase module ") do |task|
  task.cucumber_opts = %W(--tags=@init_purchase features #{conf_file})
end
task :init_purchase => :init_account

Cucumber::Rake::Task.new(:init_magento, "Install the required module for magento, create Magento instance and load mapping") do |task|
  task.cucumber_opts = %W(--tags=@init_magento features #{conf_file})
end

Cucumber::Rake::Task.new(:base_finance, "Install the required module for finance, and perform standard data configuration") do |task|
  task.cucumber_opts = %W(--tags=@base_finance features #{conf_file})
end

Cucumber::Rake::Task.new(:credit_control, "Run the credit control tests") do |task|
  task.cucumber_opts = %W(--tags=@credit_control features #{conf_file})
end

Cucumber::Rake::Task.new(:voucher_test, "Perform test on voucher") do |task|
  task.cucumber_opts = %W(--tags=@113wo features #{conf_file})
end

task :init_magento => :init_sale
task :init_magento => :init_purchase

##############################################################################
#  Test For accounting in multicurrency
##############################################################################
namespace :accounting_multicurrency do
  Cucumber::Rake::Task.new(:init_param, "Install the base module and configure base vate") do |task|
    task.cucumber_opts = %W(--tags=@param features #{conf_file})
  end
end
