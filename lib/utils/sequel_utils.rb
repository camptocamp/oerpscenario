###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Author Guewen Baconnier
#    Copyright Camptocamp SA 2012
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

module SequelUtils
  attr_reader :sequel

  def sequel(params={})
    @sequel ||= init_sequel(params)
  end

  def init_sequel(params={})
    if SEQUEL_ACTIVE
      sequel_params = config.merge(params)
      @sequel = SequelProxy.new(sequel_params, log)
    else
      msg = 'Please install the sequel and pg gems in order to use $utils.sequel.'
      log.fatal(msg)
      raise msg
    end
  end
  private :init_sequel
end

if SEQUEL_ACTIVE
  require 'sequel'

  class SequelProxy < BasicObject
    # Delegate to Sequel except the OERPScenario methods to manage the connections

    attr_reader :log

    def initialize(params, log)
      @log = log
      @db = ::Sequel.postgres(:host=>params[:db_host],
                              :database=>params[:dbname],
                              :user=>params[:db_user],
                              :password=>params[:db_password],
                              :port => params[:db_port] || 5432)
    end

    protected

    def method_missing(name, *args, &block)
      @db.send(name, *args, &block)
    end

  end
end