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
      $helperlogger.debug("Extending  #{self.class} #{self.name}")
      # Add useful methode on sale order handling

      def self.to_ary
        return [name]
      end

      def confirm
        wkf_action('order_confirm')
      end
    end
  else
    $helperlogger.debug("ProductProduct helper not initialized")
  end
rescue Exception => e
  $helperlogger.fatal("ERROR : #{e.to_s}")
end
