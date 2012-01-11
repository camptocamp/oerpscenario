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
Given /^I need a "([^"]*)" with reference "([^"]*)"$/ do |model, reference|
  oerp_model = Kernel.const_get(model)
  @item = oerp_model.find(reference)
  unless @item
    @item = oerp_model.new
    @item.ir_model_data_id = ['scenario', reference]
  end
end

def get_currency(currency_name)
  curr = ResCurrency.find(:first, :domain => [['name', '=', currency_name]])
  curr.should_not be_nil
  curr
end

When /^I update it with name "([^"]*)", field reference "([^"]*)" and currency "([^"]*)"$/ do |name, field, currency|
  @item.name = name
  @item.field = field
  @item.currency_id = get_currency(currency).id
  @item.save
end

When /^I set its currency to "([^"]*)"$/ do |currency_name|
  @item.currency_id = get_currency(currency_name).id
end

When /^I save it$/ do
  @item.save
end

Then /^I should have a "([^"]*)" with reference "([^"]*)"$/ do |model, reference|
  @item = Kernel.const_get(model).find(reference)
  @item.should_not be_nil
end

When /^I update it with values:$/ do |table|
  # table is a | name | 'UK Public Pricelist' |
  table.hashes.each do |data|
    @item.send "#{data['key'].to_sym}=", eval(data['value'])
  end
end

When /^I set its price list to reference "([^"]*)"$/ do |price_list_ref|
  pl = ProductPricelist.find(price_list_ref)
  pl.should_not be_nil
  @item.pricelist_id = pl.id
end
When /^I set its price list version to reference "([^"]*)"$/ do |pricelist_version_ref|
  plv = ProductPricelistVersion.find(pricelist_version_ref)
  plv.should_not be_nil
  @item.price_version_id = plv.id
end

When /^I set its base price to reference "([^"]*)"$/ do |pricetype_ref|
  pt = ProductPriceType.find(pricetype_ref)
  pt.should_not be_nil
  @item.base = pt.id
end