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
include Ooor
require 'pp'

# Add useful methode on bank statement handling
##############################################################################
AccountBankStatement.class_eval do 
  ############################################################################
  # Import invoices into the given bank statements
  # Input :
  #  - invoices :  A valid dict of AccountInvoice instance
  #  - statement : A valid AccountBankStatement instance
  #  - options {
  #      date (Default today) : date used into the first screen of the wizard (date
  #                             imported in lines)
  #    }
  # Return
  #  - The AccountBankStatement as a instance of the class¨
  # Usage Example:
  # statement = AccountBankStatement.import_invoice(invoices,statement)
  #
  # TODO implement journals
  # TODO filter acc_move_line_ids to take the right one
  # TODO Remove self to use it from an instance of the class
  def import_invoice(invoices, options={},*args)
    o = {:date => false, :journals => []}.merge(options)
    if o[:date] :
        o[:date] = Date.parse(str=o[:date]).to_s
    else
        o[:date] = Date.today.to_s
    end
    
    # Parse the given journal ids if provided
    journal_ids=[]
    o[:journals].each do |journal|
      journal_ids.push journal.id
    end
    invoice_move_line_ids=[]
    inv_total=0.0
    self.balance_start=inv_total
    
    # # For each invoices, add the right account.move.line and compute total
    invoices.each do |inv|
      unless inv.class  == AccountInvoice :
        raise "!!! --- HELPER ERROR :import_invoice received a #{inv.class.to_s} instead of AccountInvoice" 
      end
      # Take the move ids from concerned invoice
      # TODO add journal support and (journal_ids.include? move_line.journal_id or journal_ids == []
      # TODO : Debug the problem of undefined method `[]' for nil:NilClass (NoMethodError)
      # pp inv.move_id.line_id
      #       inv.move_id.line_id.each do |move_line|
      #         
      #         # if move_line.reconcile_id == false
      #         if move_line.account_id.reconcile == true
      #           invoice_move_line_ids.push move_line.id
      #         end
      #       end
      inv.move_id.line_id.each do |move_line|
        if move_line.attributes['reconcile_id'] == false and move_line.account_id.reconcile == true
          invoice_move_line_ids.push move_line.id
          inv_total = inv_total + move_line.amount_currency
        end
      end
    end
    # Save the start and end values
    self.balance_end_real=inv_total
    self.save

    unless self.class  == AccountBankStatement :
      raise "!!! --- HELPER ERROR :import_invoice received a #{self.class.to_s} instead of AccountBankStatement" 
    end

    # Call the wizard
    wizard = self.old_wizard_step('populate_statement_from_inv')
    # Set the wizard with given values
    step_dict = wizard.datas.merge({:date=>o[:date]})
    step_dict=step_dict.merge({:journal_id=> [[[],[],journal_ids]]})
    # Search the invoices and update values
    res=wizard.go(step_dict)
    step_dict=res.datas.merge(step_dict)
    # Update the step_dict with invoice we want
    step_dict=step_dict.merge({:lines=> [[[],[],invoice_move_line_ids]]})
    # Ask to populate the statement with given invoice linked account move
    res=wizard.finish(step_dict)
    # step_dict = step_dict.merge({:writeoff_acc_id => @journal.default_debit_account_id.id, :writeoff_journal_id=>@journal.id})
    # return res
  end
  ############################################################################
  # Create an statement with given informations
  # Input :
  #  - options {
  #    journal : A valid AccountJournal instance
  #    currency_code (Default : EUR) : An ISO code for currency
  #    name (Default : computed by OpenERP sequence) : A valid name if you wanna set it
  #  }
  # Return
  #  - The created AccountBankStatement as a instance of the class¨
  # Usage Example:
  # statement = AccountBankStatement.create_statement_with_currency({currency_code =>'CHF'})
  def self.create_statement_with_currency(options={}, *args)
    o = {:currency_code=>'EUR', :journal=>false, :name=>false}.merge(options)
    if not o[:journal] :
      # Take the currency
      currency_id = ResCurrency.find(:first, :domain=>[['code','=',o[:currency_code]]]).id
      if currency_id : 
        # Look for the asked cash journal currency
        journal = AccountJournal.find(:first, :domain=>[['type','=','cash'],['currency','=',currency_id]])
      else
        raise "!!! --- HELPER ERROR : create_statement_with_currency #{o[:currency_code]} currency not found"
      end
    else
      journal = o[:journal]
    end
    toreturn = AccountBankStatement.new()
    toreturn.journal_id = journal.id
    toreturn.create
    if o[:name]:
      toreturn.name=o[:name]
      toreturn.save
    end
    return toreturn
  end
  
end