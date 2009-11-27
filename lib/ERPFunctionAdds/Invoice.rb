#Author Joël Grand-Guillaume
#copyright 2009 Camptocamp SA
require 'rubygems'
require 'ooor'
include Ooor
require 'pp'

# Add useful methode on invoice handling
AccountInvoice.class_eval do 
    # Create an invoice with given informations
    # Add a line if amount <> false, the account could be provided or not
    # Input :
    #  - name : Name of the invoice
    #  - partner : A valid ResPartner instance
    #  - currency_code (Default : EUR) : An ISO code for currency
    #  - date (Default : false) : A date in this text format : 1 jan 2009
    #  - amount (Default : false) : An amount for the invoice => this will create a line 
    #  - account (Default : false) : An valide AccountAccount
    # Return
    #  - The created AccountInvoice as a instance of the class¨
    # Usage Example:
    # part = ResPartner.find(:first)
    # puts part.id
    # inv = AccountInvoice.create_cust_invoice_with_currency('my name',part,'CHF')
    def self.create_cust_invoice_with_currency(name, partner, currency_code='EUR', date=false, amount=false, account=false)
        toreturn = AccountInvoice.new
        # Set name
        toreturn.name=name
        if date :
            toreturn.date_invoice = Date.parse(str=date).to_s
        else
            toreturn.date_invoice = Date.today.to_s
        end
        # Set type
        toreturn.invoice_type = 'out_invoice'
        curr =  ResCurrency.find(:first, :domain=>[['code','=',currency_code]])
        # Set currency
        if curr : 
            toreturn.currency_id = curr.id
        else
            raise "#{currency_code} currency not found"
        end
        unless partner.class  == ResPartner :
            raise "create_cust_invoice_with_currency received a #{partner.class.to_s} instead of ResPartner" 
        end 
        # Set partner
        if (partner.address.length >0) :
            toreturn.partner_id = partner.id
        else
             raise "create_cust_invoice_with_currency received a partner : #{partner.name} without adresses"
        end
        toreturn.on_change('onchange_partner_id', 1, toreturn.invoice_type, partner.id, toreturn.date_invoice, false, false)
        # Set amount and line if asked for
        if amount:
          toreturn.check_total=amount
          invoice=toreturn.create
          if account:
             unless account.class  == AccountAccount :
                  raise "create_cust_invoice_with_currency received a #{account.class.to_s} instead of AccountAccount" 
              end
            account_id=account.id
          else:
            account_id=AccountAccount.find(:first, :domain=>[['type','=','other']]).id
          # Create a line = amount for the created invoice
          line=AccountInvoiceLine.new(
            :account_id => account_id,
            :quantity => 1,
            :price_unit => amount,
            :name => name+' line',
            :invoice_id => invoice.id
          )
          line.create
        return invoice
    end
end

