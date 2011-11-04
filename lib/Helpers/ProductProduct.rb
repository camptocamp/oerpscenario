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
    ProductProduct.class_eval do 
        puts "Extending  #{self.class} #{self.name}"
        # Add useful methode on product handling
        def self.get_valid_product(options={})
            unless options
                options = {}
            end
            domain = options[:domain] || []
            field = []
            options.each do |key, value|
                if key == :product_id
                    return ProductProduct.find(product_id, :fields => field)
                elsif key == :name
                    domain.push ['name', 'ilike', value]
                elsif key == :type
                    domain.push [value ,'=', true]      
                elsif key == :fields
                    field = value
                elsif key != domain && key != :supplier
                    domain.push [key.to_s,'=', value]
                end
            end
            if options[:qty_available]
                res = false
            else
                res = ProductProduct.find(:first, :domain => domain, :fields => field)
            end
            if res
                return res
            else
                createoptions = {:name => 'scenarioproduct'}
                options.each do |key, value|
                    if key == :type
                        createoptions[value] = true
                    elsif key != :domain && key!= :fields && key != :supplierinfo
                        createoptions[key] = value                 
                    end
                end
                new_product = ProductProduct.new(createoptions)
                new_product.save
                if options[:supplierinfo]
                    @supplier = ResPartner.get_valid_partner(options[:supplierinfo][:supplier])
                    user_id = $utils.ooor.config[:user_id]
                    user = ResUsers.find(:id => user_id)
                    supplierinfo_options = {:name => @supplier.id, :product_name => new_product.name, :min_qty =>1, :qty => 1, :product_id => new_product.id, :company_id => user.company_id.id}
                    options[:supplierinfo].each do |key, value|
                        if key != :supplier
                            supplierinfo_options[key] = value                 
                        end
                    end
                    new_supplierinfo = ProductSupplierinfo.new(supplierinfo_options)
                    new_supplierinfo.save
                end
                if options[:qty_available]
                    wizard = StockChangeProductQty.new(:product_id => new_product.id, :new_quantity => options[:qty_available], :location_id => 20)
                    wizard.save
                    wizard.change_product_qty(context={:active_id => new_product.id})
                end
                return new_product
            end 
        end
    end
rescue Exception => e
    puts e.to_s
end
