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
  if Object.const_defined? 'SaleOrder'
    SaleOrder.class_eval do
      $utils.log.debug("Extending  #{self.class} #{self.name}")
      # Add useful methode on sale order handling

      def self.to_ary
        return [name]
      end

      def confirm
        wkf_action('order_confirm')
      end

      def self.create_sale_order(options={}, function_line='get_sale_order_line')
        # Take a partner with appropriate attributes and at least one address
        createoptions = {}
        options.each do |key, value|
          if not [:partner, :currency, :creation_date, :order_lines].include?(key)
            if key == :date
              createoptions[:date_order] = Date.parse(str=value).to_s
            elsif createoptions[key] = value
            end
          end
        end
        @partner=ResPartner.get_valid_partner(options[:partner])
        if options[:currency].is_a? Integer
          currency_id = options[:currency]
        else
          currency_id = ResCurrency.get_valid_currency(options[:currency]).id
        end
        # Create a so with partner
        so = SaleOrder.new(createoptions)
        so.on_change('onchange_partner_id', :partner_id, @partner.id, @partner.id)
        so.pricelist_id=ProductPricelist.find(:first, :domain => [['currency_id', '=', currency_id]], :fields => ['id']).id
        so.order_line = SaleOrderLine.send(function_line, options[:order_lines], so)
        so.create
        if options[:creation_date]
          so.create_date = Date.parse(str=options[:creation_date]).to_s
        end
        so.save
        so.write(createoptions)
        @saleorder=so
        return @saleorder
      end
    end
  else
    $utils.log.debug("SaleOrder helper not initialized")
  end
rescue Exception => e
  $utils.log.fatal("ERROR : #{e.to_s}")
end
