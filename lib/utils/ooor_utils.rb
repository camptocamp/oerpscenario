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

module OoorUtils

  def ooor
    @ooor ||= init_ooor
  end

  def init_ooor
    OoorProxy.new(log)
  end

  def ready?
    !ooor.nil? && ooor.all_loaded_models.size == 0
  end

  def login(params={})
    ooor.login(config.merge(params))
  end

  def create_ooor_connection(params={})
    ooor.open_connection(config.merge(params))
    load_helpers
  end

  def create_database_with_ooor(params={})
    ooor.create_database(config.merge(params))
    load_helpers
  end

  def setConnexionfromConf(params={})
    log.warn('Deprecated: ScenarioUtils#setConnexionfromConf. Use ScenarioUtils#create_ooor_connection')
    create_ooor_connection(params)
  end

  def createdatabasefromConf(params={})
    log.warn('Deprecated: ScenarioUtils#createdatabasefromConf. Use ScenarioUtils#create_database_with_ooor')
    create_database_with_ooor(params)
  end
end


class OoorProxy < BasicObject
  # Delegate to OOOR except the OERPScenario methods to manage the connections

    attr_reader :log

    def initialize(log)
      @log = log
    end

    def xmlrpc_url(params)
      "http://#{params[:host]}:#{params[:port]}/xmlrpc"
    end
    private :xmlrpc_url

    def login(params)
      @ooor.global_login(params[:user], params[:pwd])
    end

    def init_ooor_connection(params)
      ::Ooor.new({:url => xmlrpc_url(params),
                  :database => params[:dbname],
                  :username => params[:user],
                  :password => params[:pwd],
                  :log_level => params[:log_level]})
    end
    private :init_ooor_connection

    #read the base.conf file to set all the parameter to begin an xml rpc session with openerp
    #you can override any of the parameters
    def open_connection(params)
      if @ooor
        login(params)
      else
        begin
          @ooor = init_ooor_connection(params)
        rescue RuntimeError #We catch RuntimeError because ooor doesn't give the error name.
                            #we deduce in that case that the database doesn't exist and we have to create it.
          log.warn("No database, try to create it")
          create_database_with_ooor(params)
        end
      end
      self
    end

    def create_database(params)
      log.info("Creating a new database")
      begin
        @ooor = Ooor.new(:url => xmlrpc_url(params))
        @ooor.create(ooor_config[:pwd], params[:dbname], false, 'en_US', params[:pwd])
        @ooor.load_models(false)
      rescue RuntimeError
        log.fatal("ERROR : Cannot create database")
        raise 'Cannot create database'
      end
      self
    end

    def method_missing(name, *args, &block)
      @ooor.send(name, *args, &block)
    end
    protected :method_missing

end