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
      if Object.const_defined?'AccountInvoice':
  # Add useful methode on invoice handling
  ##############################################################################
  AccountInvoice.class_eval do 
      puts "Extending  #{self.class} #{self.name}"
      ##########################################################################
      # Create an invoice with given informations
      # Add a line if amount <> false, the account could be provided or not
      # Input :
      #  - name : Name of the invoice
      #  - partner : A valid ResPartner instance
      #  - option {
      #    currency_code (Default : EUR) : An ISO code for currency
      #    date (Default : false) : A date in this text format : 1 jan 2009
      #    amount (Default : false) : An amount for the invoice => this will create a line 
      #    account (Default : false) : An valide AccountAccount
      #    type (Default : out_invoice) : the invoice type
      #  }
      # Return
      #  - The created AccountInvoice as a instance of the class¨
      # Usage Example:
      # part = ResPartner.find(:first)
      # puts part.id
      # inv = AccountInvoice.create_cust_invoice_with_currency('my name',part,{currency_code =>'CHF'})
      def self.create_invoice_with_currency(name, partner, options={}, *args)
          o = {:type=>'out_invoice', :currency_code=>'EUR', :date=>false, :amount=>false, :account=>false}.merge(options)
           if o[:date] :
                date_invoice = Date.parse(str=o[:date]).to_s
            else
                date_invoice = Date.today.to_s
            end
          
          toreturn = AccountInvoice.new()
          
          unless partner.class  == ResPartner :
              raise "!!! --- HELPER ERROR :create_cust_invoice_with_currency received a #{partner.class.to_s} instead of ResPartner" 
          end 
          # Set partner
          if (partner.address.length >0) :
              toreturn.partner_id = partner.id
          else
              raise "!!! --- HELPER ERROR :create_cust_invoice_with_currency received a partner : #{partner.name} without adresses"
          end
          toreturn.on_change('onchange_partner_id', :partner_id ,1, o[:type], partner.id, date_invoice, false, false)
          
          # Set name & date
          toreturn.name = name
          toreturn.date_invoice=date_invoice

          # Set type of invoice
          toreturn.type = o[:type]
          curr =  ResCurrency.find(:first, :domain=>[['code','=',o[:currency_code]]])
          # Set currency
          if curr : 
              toreturn.currency_id = curr.id
          else
              raise "!!! --- HELPER ERROR :#{o[:currency_code]} currency not found"
          end
          
          # Set amount and line if asked for
          toreturn.create

          # toreturn.type = o[:type]
          # toreturn.save
          if o[:amount] :
              
              if ['in_invoice', 'in_refund'].include? o[:type] :
                  toreturn.check_total = o[:amount]
              end
              if o[:account] :
                  unless account.class  == AccountAccount :
                      raise "!!! --- HELPER ERROR :create_cust_invoice_with_currency received a #{o[:account].class.to_s} instead of AccountAccount" 
                  end
                  account_id = o[:account].id
              else
                  # If no account, take on of type 'other' and a non-reconciliable account
                  account_id = AccountAccount.find(:first, :domain=>[['type','=','other'],['reconcile','=',false]]).id
                  # Create a line = amount for the created invoice
                  line=AccountInvoiceLine.new(
                    :account_id => account_id,
                    :quantity => 1,
                    :name => name+' line',
                    :price_unit => o[:amount],
                    :invoice_id => toreturn.id
                  )
                  line.create
              end
          end
          toreturn.save 
          return toreturn
      end
  end
else 
    puts "WARNING : Account Helpers can't be initialized -> account module isn't installed !!!"
end
rescue Exception => e
  puts e.to_s
end
