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
Given /^a valid (\w+) pricelist in (\w+) exists$/ do |type,currency|
  # Take the currency
  currency_id = ResCurrency.find(:first, :domain=>[['name','=',currency]], :fields=>['id']).id
  # Look for the asked pricelist
  pricelist = ProductPricelist.find(:first, :domain=>[['type','=',type],['currency_id','=',currency_id]], :fields=>['id'])
  if not pricelist
    # A valid pricelist of the right type should exist to run this step
    pricelist = ProductPricelist.find(:first, :domain=>[['type','=',type]])
    pricelist.should be_true
    copied_pricelist = pricelist.copy
    copied_pricelist.currency_id=currency_id
    copied_pricelist.name = 'OERPScenario '+type+' in '+currency
    copied_pricelist.save
    copied_pricelist = nil
  end
  
end

Given /^there is a product category named "([^"]*)"$/ do |name| #"
    categ = ProductCategory.find(:first, :domain=> [['name','=', name]])
    unless categ
        categ = ProductCategory.new({:name => name})
    end
    categ.save
    categ.should be_true
end

Given /^there is a product named "([^"]*)" with the following attributes :$/ do |name, table|#"
    pclass = nil
    @product = ProductProduct.find(:first, :domain =>[['name','=', name]])
    unless @product
        @product = ProductProduct.new()
    end
    table.hashes.each do |data|
        eval("@product.#{data['key']}=#{data['value']}")
    end
    @product.should be_true
    @product.save
end

Given /^product is in category "([^"]*)"$/ do |name|#"
    categ = ProductCategory.find(:first, :domain=> [['name','=', name]])
    categ.should be_true
    @product.categ_id = categ.id
    @product.save
end

Given /^the supplier of the product is "([^"]*)"$/ do |arg1|
  partner = ResPartner.find(:first, :domain => [['name','=',arg1]], :fields => ['id','name'])
  partner.should_not be_nil
  @supplier = ProductSupplierinfo.new()
  @supplier.product_id = @product.id
  @supplier.name = partner.id
  @supplier.min_qty = 0.0
  @supplier.should be_true
  @supplier.save
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

Given /^I set on supplier line on all product using supplier "([^"]*)"$/ do |supplier_id| #"
  supp = ResPartner.find_by_oid(supplier_id)
  supp.should_not be_nil, 
    "can not find specified supplier"
  ProductTemplate.find(:all, :fields=>['id', 'seller_ids']).each do | prod |
    info = ProductSupplierinfo.find_by_product_id(prod.id)
    unless info
      info = ProductSupplierinfo.new
    end
    info.product_name = prod.name
    info.product_id = prod.id
    info.name = supp.id
    info.min_qty = 1
    info.save
  end
end

