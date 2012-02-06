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
end

##############################################################################
#           Scenario: make_and_validate_payments_with_pay_invoice_wizard
##############################################################################

##############################################################################
# Given /^I call the Pay invoice wizard$/ do
#   @wizard = @invoice.old_wizard_step('account.invoice.pay') #tip: you can inspect the wizard fields, arch and datas
#   @wizard.should be_true
# end

##############################################################################
# And /^I partially pay (.*) (\w+)\.\- on the (.*)$/ do |amount,currency,date_p|
#   date_p=Date.parse(str=date_p).to_s
#   # Look for the right currency journal
#   @journal = AccountJournal.find(:first, :domain=>[['currency','=',ResCurrency.find(:first, :domain=>[['code','=',currency]]).id]])
#   @journal.should be_true
#   # Set the wizard with given values
#   step_dict = @wizard.datas.merge({:amount=>amount.to_f, :journal_id=>@journal.id, :name=>'OERPScenario test', :date=>date_p})
#   @wizard.reconcile(step_dict)
# end

##############################################################################
# Then /^I completely pay the residual amount in (\w+) on the (.*)$/ do |currency,date_p|
#   date_p=Date.parse(str=date_p).to_s
#   # Look for the right currency journal
#   @journal = AccountJournal.find(:first, :domain=>[['currency','=',ResCurrency.find(:first, :domain=>[['code','=',currency]]).id]])
#   @journal.should be_true
#   step_dict = @wizard.datas.merge({:journal_id=>@journal.id, :name=>'OERPScenario test', :date=>date_p,:writeoff_acc_id => @journal.default_debit_account_id.id, :writeoff_journal_id=>@journal.id})
#   # puts step_dict
#   @wizard.reconcile(step_dict)
#   
   #  Old way to deal with wizard:
   # 
   # # Set the wizard with given values
   # step_dict = @wizard.datas.merge({:journal_id=>@journal.id, :name=>'OERPScenario test', :date=>date_p})
   # # Ask for writeoff check and update values
   # res=@wizard.writeoff_check(step_dict)
   # step_dict=res.datas.merge(step_dict)
   # # Ask for reconcile and get comment if write-off occure
   # res=@wizard.addendum(step_dict)
   # step_dict=res.datas.merge(step_dict)
   # # set the writeoff account = same account than the jouranl default debit one (doesn't really matters for this test)
   # step_dict = step_dict.merge({:writeoff_acc_id => @journal.default_debit_account_id.id, :writeoff_journal_id=>@journal.id})
   # # Finally reconile the invoice
   # @wizard.reconcile(step_dict)
# end

##############################################################################
# Then /^I should see a residual amount of (.*) (\w+)\.\-$/ do |amount,currency|
#   @invoice.residual.should == amount.to_f 
# end


