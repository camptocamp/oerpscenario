###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Author Nicolas Bessi & Joel Grand-Guillaume 2009 
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

