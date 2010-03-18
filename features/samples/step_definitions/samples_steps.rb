###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Author Nicolas Bessi 2009 
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

# ##############################################################################
# Scenario: Sample Create a partner and test some basic stuffs
# ##############################################################################
Given /^I want to show you how to use OERPScenario$/ do
  # Empty to pass (no need for an action)
end

# ##############################################################################
When /^I create a partner named (\w+)$/ do |name|
  # Create a new partner using Ooor, and store it in a
  # global var for the current feature
  @partner = ResPartner.new(:name => name)
  @partner.create
  # Controle it has been a success
  @partner.should be_true
end

# ##############################################################################
Then /^I should be able to find it by his id$/ do
  # Find the partner by id
  result=ResPartner.find(@partner.id)
  # Test we get something
  result.should be_true
  # Store it into @partner to have it for the next step
  @partner=result
end

# ##############################################################################
Then /^the name should be (\w+)$/ do |name|
  # Test the name is correct
  @partner.name.should == name
end


# ##############################################################################
# Scenario: Sample using the memorizer
# ##############################################################################
Given /^I am still in the same features and not the same scenario$/ do
  # Empty to pass (no need for an action)
end

# ##############################################################################
When /^I call the @partner variable I should not retrieve the partner$/ do
  # Check it contain nothing
  @partner.should be_false
end

# ##############################################################################
Given /^I take the first found partner to set @partner variable$/ do
  @partner=ResPartner.find(:first)
  @partner.should be_true
end

# ##############################################################################
Given /^I store it into the memorizer as (\w+) in order to retrieve it in another scenario$/ do |var_name|
  # Memorize the partner in order
  # to retrieve it again when needed in another
  # scenario or feature
  $utils.set_var(var_name,@partner)
end

# ##############################################################################
Given /^I call back the memorizer to retieve the (\w+) variable$/ do |var_name|
  @Memorized_partner=$utils.get_var(var_name.strip).should be_true
end

# ##############################################################################
Then /^I should have the same partner as contained into @partner variable$/ do
  @Memorized_partner.id.should == @partner.id
end

# ##############################################################################
# Scenario: Sample using ResPartner Helper
# ##############################################################################
Given /^I want to show you how to use the Helpers$/ do

end

# ##############################################################################
When /^you need to look for a supplier partner with at least one contact$/ do

end

# ##############################################################################
Then /^you can use one of the ResPartner helper called get_valid_partner$/ do
  # Use the ResPartner Helper to get a partner of a certain type
  # and with at least one address
  @partner=ResPartner.get_valid_partner({:type=>'supplier'})
  @partner.should be_true
end

# ##############################################################################
Then /^get the corresponding partner very easily$/ do
  # Check it's a supplier
  @partner.supplier.should be_true
  # Check it has a contact
  @partner.address.count.should > 0
end




# ##############################################################################
# Scenario: Sample using object method like validate an invoice
# ##############################################################################
Given /^I have recorded a supplier invoice of (.*) (\w+) called (\w+) using Helpers$/ do |amount, currency, name|
  # Take first supplier partner with at least one address
  @partner=ResPartner.get_valid_partner({:type=>'supplier'})
  @partner.should be_true
  # Create an invoice with a line = amount
  @invoice=AccountInvoice.create_invoice_with_currency(name, @partner, 
    {:currency_code=>currency, :amount=>amount.to_f, :type=>'in_invoice'})
  @invoice.should be_true
end

# ##############################################################################
When /^I validate the invoice using the validate button$/ do
  # Call the 'invoice_open' method from account.invoice openobject
  @invoice.wkf_action('invoice_open')
end

# ##############################################################################
Then /^I should get the invoice (\w+)$/ do |state|
  # Take the invoice and check the state
  @invoice.should be_true
  @invoice.state.should == state
end


# ##############################################################################
# Scenario: Sample to create and rename a partner
# ##############################################################################
Given /^I have created a partner named "([^\"]*)" with the following addresses:$/ do |name, table|
  # table is a Cucumber::Ast::Table
  @partner = ResPartner.new(
    :name => name)
  @partner.create
  @partner.should be_true
  table.hashes.each do |adress|
    add = ResPartnerAddress.new(:name => adress[:name],:partner_id => @partner.id)
    add.create
  end
  @partner = ResPartner.find(@partner.id)
  @partner.address.count.should == table.hashes.count
end

# ##############################################################################
Then /^.*expect.* partner (\w+) to be "?([^"]+)"?$/ do |field,value|
    @partner.send(field).to_s.should == value
end

# ##############################################################################
When /^I change the partner name to "([^\"]*)"$/ do |name|
  @partner.name = name
  @partner.save
end

# ##############################################################################
Then /^the partner name to be "([^\"]*)"$/ do |name|
  @partner.reload
  @partner.name.should == name
end
