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

@invoice = false
Before do
    # Initiate vars used to stored object used trought the tests
    @partner = false
    @address = false
    @account = false
    @prod = false
    @currency = false
    @company = false
    @wizard  = false
    @journal = false
    @statement = false
end


##############################################################################
#           Scenario: make_and_validate_payments_with_bank_statement
##############################################################################

When /^I create a new bank statement with a (\w+) account journal$/ do |currency|
  @statement=AccountBankStatement.create_statement_with_currency({:currency_code => currency})
  @statement.should be_true
end

##############################################################################
And /^import on the (.*) the invoice called (\w+)$/ do |date,name|
  @invoice=AccountInvoice.find(:first,:domain=>[['name','=',name]])
  @statement.import_invoice([@invoice],{:date=>date})
end

##############################################################################
And /^confirm the statement and see it confirmed$/ do
  # @statement.wkf_action('button_confirm')
  @statement.call('button_confirm',[@statement.id])
  @statement=AccountBankStatement.find(@statement.id)
  @statement.state.should == 'confirm'
end

##############################################################################
# Then /^I should see on the invoice (\w+) a residual amount of (.*)\.\-$/ do |name,amount|
#   @invoice=AccountInvoice.find(:first,:domain=>[['name','=',name]],:order_by=>'id desc')
#   @invoice.should be_true
#   require 'ruby-debug'
#   debugger
#   @invoice.residual.should == amount
# end


