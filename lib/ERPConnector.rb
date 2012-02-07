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
require 'pp'
require 'cucumber'
require 'xmlrpc/client'
require 'logger'

XMLRPC::Config::ENABLE_NIL_PARSER =true
XMLRPC::Config::ENABLE_NIL_CREATE =true
XMLRPC::Config::ENABLE_BIGINT=true


# This class map OpenERP XMLRPC logins and common stuff
class ScenarioUtils
    attr_accessor :ooor, :config, :log
    def initialize
        @uid = false
        @ooor = false
        # Genereic dict to store tested object
        @memorizer = {}
        @config = {}
        @log = Logger.new(STDOUT)
        
    end
    
    # Define a memorizer to store object handled by the test
    # Useful to store an invoice in a var which name = invoice name !
    def set_var (name,value)
      @memorizer[name]=value
    end  
    def get_var (name)
      return @memorizer[name]
    end
    def clean_var (name)
      @memorizer.delete(name)
    end
    def clean_all_var
      @memorizer=[]
    end
    
    #read the base.conf file to set all the parameter to begin an xml rpc session with openerp
    #you can override any of the parameters
    def setConnexionfromConf(para={}, *args)
        conf_path = 'base.conf' 
        if ENV['CONF']
            conf_path = ENV['CONF']
        end
        my_config = ParseConfig.new(conf_path)
        @config[:port] = my_config.get_value('port')
        @config[:user] =  my_config.get_value('user')
        @config[:dbname] =  my_config.get_value('database')
        @config[:pwd] =  my_config.get_value('password') 
        @config[:host] =  my_config.get_value('host')
        @config[:log_level] = Logger::ERROR
        @config.merge(para)

        if @ooor
            self.login({:user=>@config[:user], :pwd=>@config[:pwd]})
        else
            begin
                 @ooor=Ooor.new(
                                {
                                :url => "http://#{ @config[:host]}:#{@config[:port]}/xmlrpc",
                                :database => @config[:dbname], 
                                :username =>  @config[:user], 
                                :password => @config[:pwd], 
                                :log_level=>  @config[:log_level]
                                }
                            )
                 Dir["lib/Helpers/*.rb"].each {|file| require file }
            #We catch RuntimeError because ooor doesn't give the error name. we deduce in that case that the database doesn't exist and we have to create it.
            rescue RuntimeError
                puts 'No database'
                self.createdatabasefromConf(@config)
            end
        end
    end 
    
    def ready?
        if not @ooor
          return false
        else
          return @ooor.all_loaded_models.size >0
        end
    end
    
    def login(para={}, *args)
        my_config = ParseConfig.new('base.conf')
        log_para = {}
        log_para[:user]  = my_config.get_value('user')
        log_para[:pwd] =  my_config.get_value('password')
        log_para.merge(para)
        return  @ooor.global_login(log_para[:user], log_para[:pwd])
    end
    
    def createdatabasefromConf(config)
        puts 'Creation of a new database'
        @config = config
        begin
            @ooor = Ooor.new(:url => "http://#{ @config[:host]}:#{@config[:port]}/xmlrpc")
            @ooor.create(@config[:pwd], @config[:dbname], false, 'en_US', @config[:pwd])
        rescue RuntimeError
            raise 'cannot create database'
        end
    end
end
