# -*- encoding: utf-8 -*-
#################################################################################
#                                                                               #
#    OERPScenario, OpenERP Functional Tests                                     #
#    Copyright (C) 2011 Akretion Benoît Guillot <benoit.guillot@akretion.com>   #
#                                                                               #
#    This program is free software: you can redistribute it and/or modify       #
#    it under the terms of the GNU General Public License as published by       #
#    the Free Software Foundation, either version 3 Afero of the License, or    #
#    (at your option) any later version.                                        #
#                                                                               #
#    This program is distributed in the hope that it will be useful,            #
#    but WITHOUT ANY WARRANTY; without even the implied warranty of             #
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the              #
#    GNU General Public License for more details.                               #
#                                                                               #
#    You should have received a copy of the GNU General Public License          #
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.      #
#                                                                               #
#################################################################################
require 'pp'
require 'rubygems'
require 'ooor'

begin
  if Object.const_defined? 'SaleOrderLine'
    SaleOrderLine.class_eval do
      @log = Logger.new('SaleOrderLine')
      @log.debug("Extending  #{self.class} #{self.name}")

      def self.get_sale_order_line(options, so)
        unless options
          options = [{:price_unit => 50}]
        end
        sale_order_lines = []
        options.each do |sale_order_line|
          @product=ProductProduct.get_valid_product(@openerp, sale_order_line[:product])
          line = SaleOrderLine.new(:product_id => @product.id)
          line.on_change('product_id_change', :product_id, @product.id, so.pricelist_id, @product.id, qty=0,
                         uom=false, qty_uos=0, uos=false, name='', partner_id=so.partner_id.id, lang=false, update_tax=true, date_order=so.date_order, packaging=false, fiscal_position=false, flag=false)
          line.price_unit = sale_order_line[:price_unit].to_f
          line.product_uom = 1
          sale_order_lines << line
        end
        return sale_order_lines
      end


################################ CUSTOM HELPER ####################################################
#Custom helper for the module delivery_delays
      def self.delivery_delays_get_sale_order_line(options, so)
        sale_order_lines = []
        onchange_order_lines = []
        options.each do |sale_order_line|
          @product=ProductProduct.get_valid_product(@openerp, sale_order_line[:product])
          line = SaleOrderLine.new(:product_id => @product.id)
          line.on_change('product_id_change', :product_id, @product.id, so.pricelist_id, @product.id, qty=sale_order_line[:product_uom_qty] || 1.0,
                         uom=false, qty_uos=0, uos=false, name='', partner_id=so.partner_id.id, lang=false, update_tax=true, date_order=so.date_order, packaging=false, fiscal_position=false, flag=false, context=false, order_lines=onchange_order_lines)
          line.price_unit = sale_order_line[:price_unit].to_f
          line.product_uom = 1
          line.product_uom_qty = sale_order_line[:product_uom_qty] || 1.0
          onchange_order_lines <<[0, 0, {:product_id => @product.id, :name => @product.name, :product_uom_qty => sale_order_line[:product_uom_qty] || 1.0}]
          sale_order_lines << line
        end
        return sale_order_lines
      end
    end
  else
    @log.debug("SaleOrderLine helper not initialized")
  end
rescue Exception => e
  @log.fatal("ERROR : #{e.to_s}")
end
