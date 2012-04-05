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
  if Object.const_defined? 'ResCurrency'
    ResCurrency.class_eval do
      $helperlogger.debug("Extending  #{self.class} #{self.name}")

      def self.get_valid_currency(options={})
        if options != nil && options[:currency_name]
          currency = ResCurrency.find(:first, :domain => [['name', '=', options[:currency_name]]], :fields => ['id'])
        else
          user_id = $utils.ooor.config[:user_id]
          user = ResUsers.find(:id => user_id)
          currency = ResCurrency.find(user.company_id.currency_id.id, :fields => ['id'])
        end
        currency
      end
    end
  else
    $helperlogger.debug("ResCurrency helper not initialized")
  end
rescue Exception => e
  $helperlogger.fatal("ERROR : #{e.to_s}")
end



