#Author Joël Grand-Guillaume
#copyright 2009 Camptocamp SA
require 'pp'
require 'rubygems'
require 'ooor'
include Ooor


# Add useful methode on partner handling
ResPartner.class_eval do 
    # Return the first encountred supplier with at least one address
    # Input :
    #  - 
    # Return
    #  - The found ResPartner as a instance of the class¨
    # Usage Example:
    # part = ResPartner.get_supplier({:name => 'toto', :type=>'supplier'})
    def self.get_valid_partner(options={})
        o = {:name => false, :type=> false}.merge(options)
        name = o[:name]
        type = o[:type]
        domain = []
        if name :
            domain.push ['name', 'ilike', name]
        end  
        if type :
            domain.push [type ,'=', true]      
        end
        res = ResPartner.find(:all, :domain => domain )
        unless res :
            raise "!!! --- HELPER ERROR :get_supplier don't found a #{type} named #{name}" 
        end
        result=false
        res.each do |part|
            if (part.address.length >0) :
                result=part
                break
             end
        end
        if result :
            return result
        else
             raise "!!! --- HELPER ERROR :get_supplier found #{type} named #{name}, but without adresses"
        end
    end
end

