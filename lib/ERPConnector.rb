#Author Nicolas Bessi 2009 
#copyright Camptocamp SA
require 'rubygems'
require 'ooor'
include Ooor
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
        Ooor.reload!({:url => "http://#{@host}:#{@port}/xmlrpc", :database => @dbname, :username => @user, :password => @pwd, :log_level=>log_level})
    end 
    
    def ready?
        return Ooor.loaded?
    end
    
    def login(user,pass)
        return Ooor.global_login(user, pass)
    end
      
end