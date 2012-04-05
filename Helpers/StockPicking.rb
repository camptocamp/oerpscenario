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
  if Object.const_defined? 'StockPicking'
    StockPicking.class_eval do
      @log = Logger.new('StockPicking')
      @log.debug("Extending  #{self.class} #{self.name}")
      # Add useful methode on stock picking handling

      def self.to_ary
        return [name]
      end

      def validate_picking()
        res = {'delivery_date' => (DateTime.now).strftime(fmt="%Y-%m-%d %H:%M:%S")}
        stock_moves = move_lines
        stock_moves.each do |move_line|
          res["move#{move_line.id}"] = {'prodlot_id' => move_line.prodlot_id && move_line.prodlot_id.id || false, 'product_id' => move_line.product_id.id, 'product_uom' => move_line.product_uom.id, 'product_qty' => move_line.product_qty}
        end
        StockPicking.do_partial([id], res)
      end
    end
  else
    @log.debug("StockPicking helper not initialized")
  end
rescue Exception => e
  @log.fatal("ERROR : #{e.to_s}")
end
