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

# # @invoice = false
# Before do
#     # Initiate vars used to stored object used trought the tests
#     @partner = false
#     @address = false
#     @account = false
#     @prod = false
#     @currency = false
#     @company = false
#     @wizard  = false
#     @journal = false
#     @statement = false
# end
# 

##############################################################################
#           Scenario: make_and_validate_payments_with_bank_statement
##############################################################################
Given /^I create a new bank statement called (\w+) with a (\w+) account journal$/ do |statement_name,currency|
  @statement=AccountBankStatement.create_statement_with_currency({:currency_code => currency,:name => statement_name})
  @statement.should be_true
end
When /^I create a new bank statement with a (\w+) account journal$/ do |currency|
  @statement=AccountBankStatement.create_statement_with_currency({:currency_code => currency})
  @statement.should be_true
end

##############################################################################
And /^import on the (.*) the invoice called (\w+)$/ do |date,name|
  # @invoice=AccountInvoice.find(:first,:domain=>[['name','=',name]])
  @invoice.should be_true
  @statement.import_invoice([@invoice],{:date=>date})
end

##############################################################################
And /^I import on the (.*), the following invoice : (.*)$/ do |date,invoices_name|
    invoices=[]
    invoices_name.split(',').each do |inv_name|
        invoices.push AccountInvoice.find(:first,:domain=>[['name','=',inv_name]])
    end
    @statement.import_invoice(invoices,{:date=>date})
end

##############################################################################
And /^confirm the statement $/ do
  # @statement.wkf_action('button_confirm')
  @statement.call('button_confirm',[@statement.id])
end


##############################################################################
And /^confirm the statement and see it confirmed$/ do
  # @statement.wkf_action('button_confirm')
  @statement.call('button_confirm',[@statement.id])
  @statement=AccountBankStatement.find(@statement.id)
  @statement.state.should == 'confirm'
end
##############################################################################

Given /^I take the bank statement called (\w+)$/ do |bankStatement_name|
  @statement=AccountBankStatement.find(:first,:domain=>[['name','=',bankStatement_name]])
  @statement.should be_true
end


##############################################################################
Then /^I should see an draft bank statement$/ do
    @statement.state.should == 'draft'
end

##############################################################################
When /^push the confirm button of the statement it should raise a warning because one invoice is already reconciled$/ do
  begin
      @statement.call('button_confirm',[@statement.id])
  rescue Exception => e
    # Does nothing here, everything is normal if I get an error !
    # The bank statement shouldn't be validated if an invoice is already reconciled !
  end
end

##############################################################################
When /^no entries should be created by the bank statement$/ do
  accountmovelines=AccountMoveLine.find(:all,:domain=>[['statement_id','=',@statement.id]])
  accountmovelines.should == []
end


