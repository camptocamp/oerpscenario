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


When /^I create monthly periods on the fiscal year with reference "([^"]*)"$/ do |fy_ref|
  fy = AccountFiscalyear.find(fy_ref)
  fy.should_not be_nil
  if fy.period_ids.empty?
    AccountFiscalyear.create_period([fy.id]).should be_true
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