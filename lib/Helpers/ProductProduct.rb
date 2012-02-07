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

begin
    ProductProduct.class_eval do 
        $utils.log.debug("Extending  #{self.class} #{self.name}")
        # Add useful methode on product handling

          def self.to_ary
            return [name]
          end

        def self.get_valid_product(options={})
            unless options
                options = {}
            end
            if options.is_a? Integer
                return ProductProduct.find(options)
            end
            product = false
            # To avoid error when a supplier info or an orderpoint is needed a new product is always created
            if not (options[:new] || options[:supplierinfo] || options[:ordepoint])
                domain = options[:domain] || []
                field = []
                options.each do |key, value|
                    if key == :product_id
                        return ProductProduct.find(value, :fields => field)
                    elsif key == :name
                        domain.push ['name', 'ilike', value]
                    elsif key == :type
                        domain.push [value ,'=', true]      
                    elsif key == :fields
                        field = value
                    elsif key != domain
                        domain.push [key.to_s,'=', value]
                    end
                end
                product = find(:first, :domain => domain, :fields => field)
            end
            unless product
                createoptions = {:name => 'scenarioproduct'}
                options.each do |key, value|
                    if not [:domain, :fields, :new, :supplierinfo, :orderpoint].include?(key)
                        createoptions[key] = value                 
                    end
                end
                product = ProductProduct.new(createoptions)
                product.save
                if options[:supplierinfo]
                    @supplier = ResPartner.get_valid_partner(options[:supplierinfo][:supplier])
                    user_id = $utils.ooor.config[:user_id]
                    user = ResUsers.find(:id => user_id)
                    supplierinfo_options = {
                        :name => @supplier.id,
                        :product_name => product.name,
                        :min_qty =>1,
                        :qty => 1,
                        :product_id => product.id,
                        :company_id => user.company_id.id,
                        }
                    options[:supplierinfo].each do |key, value|
                        if key != :supplier
                            supplierinfo_options[key] = value                 
                        end
                    end
                    new_supplierinfo = ProductSupplierinfo.new(supplierinfo_options)
                    new_supplierinfo.save
                end
                if options[:orderpoint]
                    default_stock_location_id = StockLocation.search([['name', '=', 'Stock']])[0]
                    default_warehouse_id = StockWarehouse.search()[0]
                    user_id = $utils.ooor.config[:user_id]
                    user = ResUsers.find(:id => user_id)
                    orderpoint_options = {
                        :product_id => product.id,
                        :location_id=> default_stock_location_id,
                        :warehouse_id=> default_warehouse_id,
                        :company_id => user.company_id.id,
                        :product_max_qty=>0,
                        :product_uom=>product.uom_id.id,
                        }
                    options[:orderpoint].each do |key, value|
                        orderpoint_options[key] = value                 
                    end
                    new_orderpoint = StockWarehouseOrderpoint.new(orderpoint_options)
                    new_orderpoint.save
                end
            end
            if options[:qty_available]
                location_id = StockLocation.search(:name=>'Stock')[0]
                wizard = StockChangeProductQty.new(
                            :product_id => product.id,
                            :new_quantity => options[:qty_available],
                            :location_id => location_id
                        )
                wizard.save
                wizard.change_product_qty(context={:active_id => product.id})
            end
            return product
        end
    end
rescue Exception => e
    $utils.log.fatal("ERROR : #{e.to_s}")
end
