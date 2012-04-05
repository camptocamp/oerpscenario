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
require 'rubygems'
require 'ooor'
require 'pp'


begin
  if Object.const_defined? 'AccountVoucher'

    # Add useful methode on voucher handling
    ##############################################################################
    AccountVoucher.class_eval do
      @log = Logger.new('AccountVoucher')
      @log.debug("Extending  #{self.class} #{self.name}")

      def self.create_voucher(options={})
        if options[:invoice_id]
          invoice = AccountInvoice.find(options[:invoice_id])
          journal = AccountJournal.find(:first, :domain => [['type', '=', 'cash']])
          toreturn = AccountVoucher.new(:currency_id => invoice.currency_id.id, :partner_id => invoice.partner_id.id, :account_id => journal.default_debit_account_id.id, :journal_id => journal.id, :type => 'receipt', :amount => invoice.amount_total)
          toreturn.save
          line = AccountVoucherLine.new(:voucher_id => toreturn.id, :type => 'cr', :account_id => invoice.account_id.id, :amount => invoice.amount_total, :name => invoice.origin)
          line.save
          return toreturn
        end
      end
    end
  else
    @log.debug("AccountVoucher helper not initialized")
  end
rescue Exception => e
  puts("ERROR : #{e.to_s}")
end
