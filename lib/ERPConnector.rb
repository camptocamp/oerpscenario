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
$VERBOSE = nil
require 'rubygems'
require 'core_ext/basic_object'
require 'ooor'
require 'parseconfig'
require 'pp'
require 'cucumber'
require 'xmlrpc/client'
require 'logger'
require 'utils/memoizer_utils'
require 'utils/ooor_utils'
require 'utils/sequel_utils'

XMLRPC::Config::ENABLE_NIL_PARSER = true if not XMLRPC::Config::ENABLE_NIL_PARSER
XMLRPC::Config::ENABLE_NIL_CREATE = true if not XMLRPC::Config::ENABLE_NIL_CREATE
XMLRPC::Config::ENABLE_BIGINT = true if not XMLRPC::Config::ENABLE_BIGINT


# This class map OpenERP XMLRPC logins and common stuff
class ScenarioUtils
  include MemoizerUtils
  include OoorUtils
  include SequelUtils

  attr_accessor :log

  def initialize
    @uid = false
    @log = Logger.new(STDOUT)
  end

  def config
    @config ||= get_config
  end

  def config_path
    ENV['CONF'] || 'base.conf'
  end
  private :config_path

  def get_config
    my_config = ParseConfig.new(config_path)

    {# ooor options
     :port => my_config.get_value('port'),
     :user => my_config.get_value('user'),
     :dbname => my_config.get_value('database'),
     :pwd => my_config.get_value('password'),
     :host => my_config.get_value('host'),
     :log_level => Logger::ERROR,

     # sequel options
     :db_host => my_config.get_value('db_host'),
     :db_port => my_config.get_value('db_port'),
     :db_user => my_config.get_value('db_user'),
     :db_password => my_config.get_value('db_password')}
  end
  private :get_config

  def load_helpers
    Dir["lib/Helpers/*.rb"].each { |file| require file }
  end
  private :load_helpers

end