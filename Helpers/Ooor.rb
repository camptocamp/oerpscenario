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
  Ooor.class_eval do
    $helperlogger.debug("Extending  #{self.class} #{self.name}")
    # Add useful methode on ooor handling

    def self.to_ary
      return [name]
    end

    def self.new_database(options)
      @ooor = self.new(:url => options[:url])
      @ooor.create(options[:db_password], options[:database], options[:demo_data], options[:lang], options[:password])
    end
  end
rescue Exception => e
  puts("ERROR : #{e.to_s}")
end
