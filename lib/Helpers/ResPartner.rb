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
  # Add useful methode on partner handling
  ##############################################################################
  ResPartner.class_eval do
    $utils.log.debug("Extending  #{self.class} #{self.name}")
    ##########################################################################
    # Return the first encountred supplier with at least one address
    # Input :
    #  -
    # Return
    #  - The found ResPartner as a instance of the class¨
    # Usage Example:
    # part = ResPartner.get_supplier({:name => 'toto', :type=>'supplier'})
    def self.get_valid_partner(options={})
      unless options
        options={}
      end
      domain = options[:domain] || []
      field = []
      if options.is_a? Integer
        partner = ResPartner.find(options)
        $utils.set_var('current_partner', partner)
        return partner
      end
      if not options[:new]
        domain = options[:domain] || []
        domain << ['address', '!=', false]
        field = []
        options.each do |key, value|
          if key == :name
            domain.push ['name', 'ilike', value]
          elsif key == :type
            domain.push [value, '=', true]
          elsif key == :fields
            field = value
          elsif key != :domain && key != :same
            domain.push [key.to_s, '=', value]
          end
        end
        partner = ResPartner.find(:first, :domain => domain, :fields => field)
        if partner
          $utils.set_var('current_partner', partner)
          return partner
        end
      end
      createoptions = {:name => options[:name] || 'partnerscenario', :user_id => $utils.ooor.config[:user_id]}
      options.each do |key, value|
        if key == :type
          createoptions[value] = true
        elsif key != :domain && key!= :fields
          createoptions[key] = value
        end
      end
      address = ResPartnerAddress.new(:name => createoptions[:name] || 'partnerscenario', :email => createoptions[:email])
      address.save
      createoptions[:address] = [[6, 0, [address.id]]]
      partner = ResPartner.new(createoptions)
      partner.save
      $utils.set_var('current_partner', partner)
      return partner
    end
  end
rescue Exception => e
  $utils.log.fatal("ERROR : #{e.to_s}")
end
