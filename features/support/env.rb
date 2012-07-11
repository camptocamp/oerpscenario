###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Author Nicolas Bessi 2009
#    Contribs Joel Grand-Guillaume 2009
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
require 'cucumber/openerp'
require "logger"

def helpers_absolute_path
  File.expand_path("../../Helpers/*", File.dirname(__FILE__))
end

def load_helpers
  # TODO generic method to load each helper
  # actually each ruby file contains the same
  # code : test if class exists, run a class_eval it will probabley be a gem
   Dir[helpers_absolute_path].each { |file| load file }
end
