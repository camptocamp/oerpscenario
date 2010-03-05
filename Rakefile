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
require "cucumber/rake/task"

# Cucumber::Rake::Task.new(:run) do |task|
#   task.cucumber_opts = ["-t","@#{ENV["TAG"] || "all" }","features"]
# end

# Launch the @compile tag in order to check it
Cucumber::Rake::Task.new(:compile) do |task|
  task.cucumber_opts = ["-t","@compile","features"]
end

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

# Launch the @quality tag, run the base_module_quality
# module tests on all installed module
Cucumber::Rake::Task.new(:account) do |task|
  task.cucumber_opts = ["-t","@init","-t","@account","features"]
end