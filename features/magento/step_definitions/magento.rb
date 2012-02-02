###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Author Guewen Baconnier 2011
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
  @magento_instance = ExternalReferential.find(absolute_id) || ExternalReferential.new
end
Then /^I set the following attributes on the instance:$/ do |table|
  # table is a |key|'value'|
  table.hashes.each do |data|
      @magento_instance.send "#{data['key'].to_sym}=", eval(data['value'])
  end
end
And /^I set the instance referential type on "([^"]*)"$/ do |referential_type|
  ref_type = ExternalReferentialType.find(referential_type)
  ref_type.should_not be_nil
  @magento_instance.type_id = ref_type.id
end
And /^I set the instance default language on "([^"]*)"$/ do |lang_code|
  lang = ResLang.find(:first, :domain => [['code', '=', lang_code]])
  lang.should_not be_nil
  @magento_instance.default_lang_id = lang.id
end
And /^I set the instance default product category on "([^"]*)"$/ do |product_category|
  category = ProductCategory.find(product_category)
  category.should_not be_nil
  @magento_instance.default_pro_cat = category.id
end
Then /^I set the instance default product category on category with name "([^"]*)"$/ do |product_category|
  category = ProductCategory.find(:first, :domain => [['name', '=', product_category]])
  category.should_not be_nil
  @magento_instance.default_pro_cat = category.id
end
And /^I set an absolute id "([^"]*)" on the instance$/ do |absolute_id|
  @magento_instance.ir_model_data_id = absolute_id.split('.')
end
Then /^I save the instance$/ do
  @magento_instance.save
end
Then /^an instance with absolute id "([^\"]*)" exists$/ do |absolute_id|
  @magento_instance = ExternalReferential.find(absolute_id)
  @magento_instance.should_not be_nil
end


# Store views
Given /^a store view with code "([^"]*)" exists$/ do |store_code|
  @store_view = MagerpStoreviews.find(:first, :domain => [['code', '=', store_code]])
  @store_view.should_not be_nil
end
Then /^I set the store view language on "([^"]*)"$/ do |lang_code|
  lang = ResLang.find(:first, :domain => [['code', '=', lang_code]])
  lang.should_not be_nil
  @store_view.lang_id = lang.id
end
Then /^I save the store view$/ do
  @store_view.save
end


# Shops
Given /^a shop with name "([^"]*)" exists$/ do |shop_name|
  @mag_shop = SaleShop.find(:first, :domain => [['name', '=', shop_name]])
  @mag_shop.should_not be_nil
end
Then /^I set the warehouse of the shop on "([^"]*)"$/ do |warehouse_absolute_id|
  warehouse = StockWarehouse.find(warehouse_absolute_id)
  warehouse.should_not be_nil
  @mag_shop.warehouse_id = warehouse.id
end
When /^I set the root category of the shop on category with name "([^"]*)"$/ do |product_category|
  category= ProductCategory.find(:first, :domain => [['name', '=', product_category]])
  category.should_not be_nil
  @mag_shop.magento_root_category = category.id
  @mag_shop.root_category_id = category.id
end
When /^I set the price list of the shop on reference "([^"]*)"$/ do |pricelist_ref|
  pl = ProductPricelist.find(pricelist_ref)
  pl.should_not be_nil
  @mag_shop.pricelist_id = pl.id
end
When /^I set the following attributes on the shop:$/ do |table|
  # table is a | allow_magento_order_status_push | false |
  table.hashes.each do |data|
      @mag_shop.send "#{data['key'].to_sym}=", eval(data['value'])
  end
end
When /^I save the shop$/ do
  @mag_shop.save
end


# Magento Instance Actions
Then /^I reload the referential mapping templates$/ do
  ExternalReferential.refresh_mapping([@magento_instance.id]).should be_true
end
Then /^I synchronize the referential settings$/ do
  ExternalReferential.core_sync([@magento_instance.id]).should be_true
end
Then /^I import the attribute sets$/ do
  ExternalReferential.sync_attrib_sets([@magento_instance.id]).should be_true
end
Then /^I import the attribute groups$/ do
  ExternalReferential.sync_attrib_groups([@magento_instance.id]).should be_true
end
Then /^I import the attributes$/ do
  ExternalReferential.sync_attribs([@magento_instance.id]).should be_true
end
Then /^I import the customer groups$/ do
  ExternalReferential.sync_customer_groups([@magento_instance.id]).should be_true
end
Then /^I import the product categories$/ do
  ExternalReferential.sync_categs([@magento_instance.id]).should be_true
end
Then /^I import the products$/ do
  ExternalReferential.sync_products([@magento_instance.id]).should be_true
end
Then /^I import the product images$/ do
  ExternalReferential.sync_images([@magento_instance.id]).should be_true
end
When /^I import the product links$/ do
  ExternalReferential.sync_product_links([@magento_instance.id]).should be_true
end
Then /^I import the partners$/ do
  ExternalReferential.sync_partner([@magento_instance.id]).should be_true
end

