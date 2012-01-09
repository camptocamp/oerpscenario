# -*- encoding: utf-8 -*-
###############################################################################
#                                                                             #
#   Helper for OERPScenario and InspectOOOR, OpenERP Functional Tests         #
#   Copyright (C) 2011 Akretion Sébastien BEAU <sebastien.beau@akretion.com>  #
#                                                                             #
#   This program is free software: you can redistribute it and/or modify      #
#   it under the terms of the GNU Affero General Public License as            #
#   published by the Free Software Foundation, either version 3 of the        #
#   License, or (at your option) any later version.                           #
#                                                                             #
#   This program is distributed in the hope that it will be useful,           #
#   but WITHOUT ANY WARRANTY; without even the implied warranty of            #
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the             #
#   GNU Affero General Public License for more details.                       #
#                                                                             #
#   You should have received a copy of the GNU Affero General Public License  #
#   along with this program.  If not, see <http://www.gnu.org/licenses/>.     #
#                                                                             #
###############################################################################


begin
    PurchaseOrder.class_eval do
        puts "Extending  #{self.class} #{self.name}"

        def confirm
            wkf_action('purchase_confirm')
        end

        def self.to_ary
            return [name]
        end

        def self.get_last_purchase_order_with_product(product_id)
            puts 'product_id'
            p product_id
            line = PurchaseOrderLine.find(:first, :domain=>[['product_id', '=', product_id]])
            puts 'line'
            p line
            
            if line
                return line.order_id
            end
            return false
            
        end
    end
rescue Exception => e
    puts e.to_s
end


