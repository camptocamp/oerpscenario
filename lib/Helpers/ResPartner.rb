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

begin
    # Add useful methode on partner handling
    ##############################################################################
    ResPartner.class_eval do 
        puts "Extending  #{self.class} #{self.name}"
        ##########################################################################
        # Return the first encountred supplier with at least one address
        # Input :
        #  - 
        # Return
        #  - The found ResPartner as a instance of the class¨
        # Usage Example:
        # part = ResPartner.get_supplier({:name => 'toto', :type=>'supplier'})
        def self.get_valid_partner(options={})
            domain = options[:domain] || []
            field = []
            options.each do |key, value|
                if key == :name
                    domain.push ['name', 'ilike', value]
                elsif key == :type
                    domain.push [value ,'=', true]      
                elsif key == :fields
                    field = value
                elsif key != domain 
                    domain.push [key.to_s,'=', value]
                end
            end
            res = ResPartner.find(:all, :domain => domain, :fields => field)
            if res.size == 0
                raise "!!! --- HELPER ERROR :get_supplier don't found a #{type} named #{name}" 
            end
            result=false
            res.each do |part|
                #we do not do part.address.length >0 for performance optimizations reasons
                if ResPartnerAddress.find(:first, :domain => [['partner_id', '=', part.id]], :fields => ['id']) 
                    result=part
                    break
                end
            end
            if result
                return result
            else
                raise "!!! --- HELPER ERROR :get_supplier found #{type} named #{name}, but without adresses"
            end
        end
    end
rescue Exception => e
    puts e.to_s
end
