###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Author Guewen Baconnier
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


##############################################################################
Given /^a purchase tax called '(.*)' with a rate of (.*) exists$/ do |name,rate|
  foundtax=AccountTax.find(:first,:domain=>[['name','=',name]], :fields=>['id'])
  if not foundtax
    # Set options for a purchase tax at 19.6%
    o = {
        :type=>'percent',
        :amount=>rate,
        :type_tax_use=>'purchase',
        # # For refund
        :ref_base_sign=>1.0,
        :ref_tax_sign=>1.0,
        # # For VAT declaration
        :base_sign=>-1.0,
        :tax_sign=>-1.0,
    }
    foundtax=AccountTax.create_tax_and_code(name,o)
  end
  foundtax.should be_true
  foundtax = nil
  
end

##############################################################################
Given /^a sale tax called '(.*)' with a rate of (.*) exists$/ do |name,rate|
  foundtax=AccountTax.find(:first,:domain=>[['name','=',name]], :fields=>['id'])
  if not foundtax
    # Set options for a purchase tax at 19.6%
    o = {
        :type=>'percent',
        :amount=>rate,
        :type_tax_use=>'sale',
        # For refund
        :ref_base_sign=>-1.0,
        :ref_tax_sign=>-1.0,
        # For VAT declaration
        :base_sign=>1.0,
        :tax_sign=>1.0,
    }
    foundtax=AccountTax.create_tax_and_code(name,o)
  end
  foundtax.should be_true
  foundtax = nil
end

##############################################################################
Given /^on all journal entries can be canceled$/ do
  journals = AccountJournal.find(:all, :fields=>["update_posted"])
  journals.each do |journal|
    journal.update_posted = true
    journal.save
    journal.update_posted.should be_true
  end
  journals = nil 
end

##############################################################################
# Look for an account in the asked currency, if doen't exist then create it
Given /^I have created a (\w+) account in (\w+)$/ do |type,currency|
  # Take the currency
  currency_id = ResCurrency.find(:first, :domain=>[['name','=',currency]], :fields=>["id"]).id
  # Look for the asked account
  user_type_id = AccountAccountType.find(:first, :domain => [['code', '=', type]], :fields =>["id"]).id
  account = AccountAccount.find(:first, :domain=>[['user_type','=',user_type_id],['currency_id','=',currency_id]])
  unless account
    account = AccountAccount.new({
      :name => type + ' ' + currency + ' Account',
      :code => type + ' ' + currency,
      :currency_id => currency_id,
      :type => 'liquidity',
      :user_type => AccountAccountType.find(:first, :domain => [['code', '=', type]], :fields =>["id"]).id,
    })
    account.create
    account = nil
  end
end

##############################################################################
# Look for a journal in the asked currency, if doen't exist then create it
Given /^a (\w+) journal in (\w+) exists$/ do |type,currency|
  # Take the currency
  currency_id = ResCurrency.find(:first, :domain=>[['name','=',currency]], :fields=>["id"]).id
  # Look for the asked journal
  journal = AccountJournal.find(:first, :domain=>[['type','=',type],['currency','=',currency_id]])
  user_type_id = AccountAccountType.find(:first, :domain => [['code', '=', type]], :fields =>["id"]).id
  unless journal
    journal = AccountJournal.new({
      :type => type,
      :name => type + ' ' + currency + ' Journal',
      :code => currency + ' C',
      # Take the first found view
      :view_id => AccountJournalView.find(:first, :fields=>["id"]).id,
      # Take the first sequence with 'Account Journal' code
      :sequence_id => IrSequence.find(:first, :domain =>[['code','=','Account Journal']], :fields=>["id"]).id,
      # Take the first 'other' account for both debit and credit
      :default_debit_account_id => AccountAccount.find(:first, :domain => [['user_type','=',user_type_id],['currency_id', '=', currency_id]],:fields=>["id"]).id,
      :default_credit_account_id => AccountAccount.find(:first, :domain => [['user_type','=',user_type_id],['currency_id', '=', currency_id]],:fields=>["id"]).id,
      :currency => currency_id,
    })
    journal.create
    journal = nil
  end
end


When /^I create monthly periods on the fiscal year with reference "([^"]*)"$/ do |fy_ref|
  fy = AccountFiscalyear.find(fy_ref)
  fy.should_not be_nil
  if fy.period_ids.empty?
    AccountFiscalyear.create_period([fy.id], {}, 1).should be_true
  end
end
Given /^I set the tax with code ([^"]*) to price include$/ do |vat_code|
  tax = AccountTax.find(:first, :domain => [['description', '=', vat_code]])
  tax.should_not be_nil
  tax.price_include = true
  tax.save
end
Then /^the VAT should be configured$/ do
end
