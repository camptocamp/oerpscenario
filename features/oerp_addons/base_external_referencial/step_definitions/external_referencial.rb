###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Author Joel Grand-Guillaume 2012
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

# External Referentials

Given /^an instance with absolute id "([^\"]*)" should exist$/ do |absolute_id|
  @instance = ExternalReferential.find(absolute_id) || ExternalReferential.new
end
Then /^I set the following attributes on the instance:$/ do |table|
  # table is a |key|'value'|
  table.hashes.each do |data|
      @instance.send "#{data['key'].to_sym}=", eval(data['value'])
  end
end
And /^I set the instance referential type on "([^"]*)"$/ do |referential_type|
  ref_type = ExternalReferentialType.find(referential_type)
  ref_type.should_not be_nil
  @instance.type_id = ref_type.id
end
And /^I set the instance default language on "([^"]*)"$/ do |lang_code|
  lang = ResLang.find(:first, :domain => [['code', '=', lang_code]])
  lang.should_not be_nil
  @instance.default_lang_id = lang.id
end
And /^I set the instance default product category on "([^"]*)"$/ do |product_category|
  # We set it to 1, because Ooor doesn't currently support sparse field, so I can't
  # read this ressource : undefined method `new' for nil:NilClass (NoMethodError)
  @instance.default_pro_cat = 1
  # category = ProductCategory.find(product_category)
  # category.should_not be_nil
  # @instance.default_pro_cat = category.id
end

Then /^I set the instance default product category on category with name "([^"]*)"$/ do |product_category|
  # We set it to 1, because Ooor doesn't currently support sparse field, so I can't
  # read this ressource : undefined method `new' for nil:NilClass (NoMethodError)
  @instance.default_pro_cat = 1
  # category = ProductCategory.find(:first, :domain => [['name', '=', product_category]])
  # category.should_not be_nil
  # @instance.default_pro_cat = category.id
end

And /^I set an absolute id "([^"]*)" on the instance$/ do |absolute_id|
  @instance.ir_model_data_id = absolute_id.split('.')
end
Then /^I save the instance$/ do
  @instance.save
end
Then /^an instance with absolute id "([^\"]*)" exists$/ do |absolute_id|
  @instance = ExternalReferential.find(absolute_id)
  @instance.should_not be_nil
end


# Shops
Given /^a shop with name "([^"]*)" exists$/ do |shop_name|
  @shop = SaleShop.find(:first, :domain => [['name', '=', shop_name]])
  @shop.should_not be_nil
end
Then /^I set the warehouse of the shop on "([^"]*)"$/ do |warehouse_absolute_id|
  warehouse = StockWarehouse.find(warehouse_absolute_id)
  warehouse.should_not be_nil
  @shop.warehouse_id = warehouse.id
end
When /^I set the root category of the shop on category with name "([^"]*)"$/ do |product_category|
  category= ProductCategory.find(:first, :domain => [['name', '=', product_category]])
  category.should_not be_nil
  @shop.magento_root_category = category.id
  @shop.root_category_id = category.id
end
When /^I set the price list of the shop on reference "([^"]*)"$/ do |pricelist_ref|
  pl = ProductPricelist.find(pricelist_ref)
  pl.should_not be_nil
  @shop.pricelist_id = pl.id
end
When /^I set the following attributes on the shop:$/ do |table|
  # table is a | allow_magento_order_status_push | false |
  table.hashes.each do |data|
      @shop.send "#{data['key'].to_sym}=", eval(data['value'])
  end
end
When /^I save the shop$/ do
  @shop.save
end



# Magento Instance Actions
Then /^I reload the referential mapping templates \(1 - Reload Referential Mapping Templates\)$/ do
  ExternalReferential.refresh_mapping([@instance.id]).should be_true
end
Then /^I synchronize the referential settings \(2 - Synchronize Referential Settings\)$/ do
  ExternalReferential.core_sync([@instance.id]).should be_true
end
Then /^I import the attribute sets \(3 - Import Product Attribute Sets\)$/ do
  ExternalReferential.sync_attrib_sets([@instance.id]).should be_true
end
Then /^I import the attribute groups \(4 - Import Attribute Groups\)$/ do
  ExternalReferential.sync_attrib_groups([@instance.id]).should be_true
end
Then /^I import the attributes \(5 - Import Product Attributes\)$/ do
  ExternalReferential.sync_attribs([@instance.id]).should be_true
end
Then /^I import the customer groups \(1 - Import Customer Groups \(Partner Categories\)\)$/ do
  ExternalReferential.sync_customer_groups([@instance.id]).should be_true
end
Then /^I import the product categories \(2 - Import Product Categories\)$/ do
  ExternalReferential.sync_categs([@instance.id]).should be_true
end
Then /^I import the products \(6 - Import Products\)$/ do
  ExternalReferential.sync_products([@instance.id]).should be_true
end
Then /^I import the product images \(7 - Import Images\)$/ do
  ExternalReferential.sync_images([@instance.id]).should be_true
end
When /^I import the product links \(8 - Import Product Links\)$/ do
  ExternalReferential.sync_product_links([@instance.id]).should be_true
end
Then /^I import the partners$/ do
  ExternalReferential.sync_partner([@instance.id]).should be_true
end
