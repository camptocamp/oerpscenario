#Author Nicolas Bessi 2009 
#copyright Camptocamp SA

require 'xmlrpc/client'
require 'rubygems'
require 'active_record'
require 'parseconfig'
# This class map OpenERP XMLRPC actions
class OERPRPCConnector
    
    def initialize
        @port = false
        @common_server = false
        @object_server = false
        @user = false
        @dbname = false
        @pwd = false
        @host = false
        @uid = false
        @current_model = false
    end
    #read the base.conf file to set all the parameter to begin an xml rpc session with openerp
    #you can override the user and the password
    def setConnexionfromConf(user=false, password=false)
        my_config = ParseConfig.new('base.conf')
        @port = my_config.get_value('port')
        @user =  my_config.get_value('user')
        @dbname =  my_config.get_value('database')
        @pwd =  my_config.get_value('password') 
        @host =  my_config.get_value('host')
        @common_server = XMLRPC::Client.new(@host, "/xmlrpc/common", @port)
        @object_server = XMLRPC::Client.new(@host, "/xmlrpc/object", @port)
        if user :
            @user = user
        end
        if password :
            @pwd = password
        end
    end
     #set a xml rpc connexion to OpenERP
    #you can override the user and the password
    def setConnexion(user, password, host, port, database )
       
        @port = port
        @user = user
        @dbname = database
        @pwd = password 
        @host = host
        @common_server = XMLRPC::Client.new(@host, "/xmlrpc/common", @port)
        @object_server = XMLRPC::Client.new(@host, "/xmlrpc/object", @port)
    end 
    #login based on the proprerty this will return the uid and set the uid property
    def login()
        res = @common_server.call("login", @dbname, @user, @pwd)
        if res :
            @uid = res
        end
        return res
    end

    def execute(*args)
        @object_server.call('execute',@dbname, @uid, @pwd, *args)
    end
    
    #map openerp copy function
    def copy(ids, inputmodel=false)
        if not inputmodel :
            inputmodel = @current_model
        end
        res = @object_server.call('execute', @dbname, @uid, @pwd, inputmodel, 'copy', ids)
        return res
    end
    
    #map openerp search function
    def search(inputmodel=false, args=[])
        if not inputmodel :
            inputmodel = @current_model
        end
        res = @object_server.call('execute', @dbname, @uid, @pwd, inputmodel, 'search', args)
        return res
    end
    
    #map openerp wriet function
    def write(id, inputmodel=false, vals={})
           if not inputmodel :
               inputmodel = @current_model
           end
           res = @object_server.call('execute', @dbname, @uid, @pwd, inputmodel, 'write', ids, args)
           return res
       end
       
    #map openerp read function
    def read(inputmodel, ids,  fields=[])
        if not inputmodel :
            inputmodel = @current_model
        end
        res = @object_server.call('execute', @dbname, @uid, @pwd, inputmodel, 'read', ids, fields)
        return res
    end
    def create(inputmodel, vals={})
        if not inputmodel :
            inputmodel = @current_model
        end
        res = @object_server.call('execute', @dbname, @uid, @pwd, inputmodel, 'create', vals)
        return res
    end
    
    def unlink(inputmodel, ids)
        if not inputmodel :
            inputmodel = @current_model
        end
        res = @object_server.call('execute', @dbname, @uid, @pwd, inputmodel, 'unlink', ids)
        return res
    end
end

## just an idea of devloppement  to directely connect to databse
class OERPDBConnector
    def initialize
        @port = port
        @user = user
        @dbname = database
        @pwd = password 
        @host = host  
    end

    def setConnexion(user, password, host, database, dbport, port=5432 )
        @port = port
        @user = user
        @dbname = database
        @pwd = password 
        @host = host
        ActiveRecord::Base.establish_connection(:adapter => 'postgresql',
        :host => @host,
        :username => @user,
        :database =>  @dbname,
        :password => @pwd,
        :port =>  @port)
    end

end