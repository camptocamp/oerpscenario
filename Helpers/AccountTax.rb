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
require 'rubygems'
require 'ooor'
require 'pp'


begin
  if Object.const_defined? 'AccountTax'
    # Add useful methode on taxes handling
    ##############################################################################
    AccountTax.class_eval do
      @log = Logger.new('AccountTax')
      @log.debug("Extending  #{self.class} #{self.name}")
      ##########################################################################
      # Create a tax and tax code with given informations
      # Input :
      #  - name : Name of the tax
      #  - option {
      # :type=>'percent',
      # :amount=>0.196,
      # :type_tax_use=>'sale',
      # # For refund
      # :ref_base_sign=>-1.0,
      # :ref_tax_sign=>-1.0,
      # # For VAT declaration
      # :base_sign=>1.0,
      # :tax_sign=>1.0,
      #  }
      # Return
      #  - The created AccountTax as a instance of the class¨
      # Usage Example:
      # tax = AccountTax.create_tax_and_code('my name',{:type=>'percent',:amount=>rate,:type_tax_use=>'purchase',})
      def self.create_tax_and_code(name, options={}, *args)
        # require 'ruby-debug'
        #           debugger
        # Set default values
        o = {
            :type => 'percent',
            :amount => 0.196,
            :type_tax_use => 'sale',
            # For refund
            :ref_base_sign => -1.0,
            :ref_tax_sign => -1.0,
            # For VAT declaration
            :base_sign => 1.0,
            :tax_sign => 1.0,
        }.merge(options)

        toreturn = AccountTax.new(o)
        toreturn.name = name
        toreturn.type = o[:type]
        toreturn.amount = o[:amount]
        toreturn.type_tax_use = o[:type_tax_use]
        toreturn.ref_base_sign = o[:ref_base_sign]
        toreturn.ref_tax_sign = o[:ref_tax_sign]
        toreturn.base_sign = o[:base_sign]
        toreturn.tax_sign = o[:tax_sign]

        toreturn.create
        return toreturn
      end
    end
  else
    @log.debug("AccountTax helper not initialized")
  end
rescue Exception => e
  puts("ERROR : #{e.to_s}")
end
