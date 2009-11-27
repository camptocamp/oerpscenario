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
    # part = ResPartner.browse_first_supplier()
    def self.browse_first_supplier()         
        res=ResPartner.find(:all,:domain=>[ ['supplier','=',true] ])
        if res :
            raise "browse_first_supplier don't found a supplier" 
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
             raise "browse_first_supplier found suppliers, but without adresses"
        end
    end
end

