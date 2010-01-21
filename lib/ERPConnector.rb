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
require 'rubygems'
require 'ooor'
require 'parseconfig'

# This class map OpenERP XMLRPC logins and common stuff
class ScenarioUtils
    
    def initialize
        @port = false
        @user = false
        @dbname = false
        @pwd = false
        @host = false
        @uid = false
        @ooor = false
    end
    #read the base.conf file to set all the parameter to begin an xml rpc session with openerp
    #you can override any of the parameters
    def setConnexionfromConf(user=false, password=false, database=false, host=false, port=false, log_level=Logger::ERROR)
        my_config = ParseConfig.new('base.conf')
        @port = my_config.get_value('port')
        @user =  my_config.get_value('user')
        @dbname =  my_config.get_value('database')
        @pwd =  my_config.get_value('password') 
        @host =  my_config.get_value('host')
        if user :
            @user = user
        end
        if password :
            @pwd = password
        end
        if database :
            @dbname = database
        end
        if host :
            @host = host
        end
        if port :
            @port = port
        end
        puts 'Connnecting >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'
        if @ooor :
            self.login(@user, @pwd)
        else
             @ooor=Ooor.new({:url => "http://#{@host}:#{@port}/xmlrpc", :database => @dbname, :username => @user, :password => @pwd, :log_level=>log_level})
             Dir["lib/Helpers/*.rb"].each {|file| require file }
        end
    end 
    
    def ready?
        if not @ooor:
          return false
        else
          return @ooor.all_loaded_models.size >0
        end
    end
    
    def login(user,pass)
        return  @ooor.global_login(user, pass)
    end
    
      
end