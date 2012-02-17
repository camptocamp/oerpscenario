# -*- encoding: utf-8 -*-
#################################################################################
#                                                                               #
#    OERPScenario, OpenERP Functional Tests                                     #
#    Copyright (C) 2011 Akretion Benoît Guillot <benoit.guillot@akretion.com>   #
#    Copyright (C) 2012 Camptocamp Joel Grand-Guillaume                         #
#                                                                               #
#    This program is free software: you can redistribute it and/or modify       #
#    it under the terms of the GNU General Public License as published by       #
#    the Free Software Foundation, either version 3 Afero of the License, or    #
#    (at your option) any later version.                                        #
#                                                                               #
#    This program is distributed in the hope that it will be useful,            #
#    but WITHOUT ANY WARRANTY; without even the implied warranty of             #
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the              #
#    GNU General Public License for more details.                               #
#                                                                               #
#    You should have received a copy of the GNU General Public License          #
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.      #
#                                                                               #
#################################################################################
When /^I press the force_assign button$/ do
  @delivery_order.force_assign()
end

When /^I press the Process button$/ do
  @delivery_order.action_process()
  @delivery_order.validate_picking()
end

Then /^I should see the delivery order (.*)$/ do |state|
    @delivery_order = StockPicking.find(@delivery_order.id)
  if state == 'Ready To Process'
    @delivery_order.state.should == 'assigned'
  elsif state == 'Done'
    @delivery_order.state.should == 'done'
  end
end


Given /^we create under "([^"]*)" the stock location "([^"]*)" with$/ do |parent, location, table|
  @parent_id = StockLocation.find(:first, :domain=>[['name','=',parent]], :fields => ['id','name'])
  @parent_id.should be_true
  @new_location = StockLocation.find(:first, :domain=>[['name','=',location]], :fields => ['id','name'])
  unless @new_location
      @new_location = StockLocation.new()
  end
  table.hashes.each do |data|
      eval("@new_location.#{data['key']}=#{data['value']}")
  end
  @new_location.name = location
  @new_location.location_id = @parent_id.id
  @new_location.save
  @new_location.should be_true
  @parent_id = nil
  @new_location = nil
end

Given /^I affect the company "([^"]*)" to the location "([^"]*)"$/ do |company, location|
  @location = StockLocation.find(:first, :domain=>[['name','=',location]], :fields => ['id'])
  @location.should be_true
  @company = ResCompany.find(:first, :domain=>[['name','=',company]], :fields => ['id'])
  @company.should be_true
  @location.company_id = @company.id
  @location.save
end

Given /^we move the stock location "([^"]*)" under "([^"]*)" and update it with$/ do |location, parent, table|
  @parent = StockLocation.find(:first, :domain=>[['name','=',parent]], :fields => ['id'])
  @parent.should be_true
  @location = StockLocation.find(:first, :domain=>[['name','=',location]], :fields => ['id'])
  unless @location
      @location = StockLocation.new()
  end
  table.hashes.each do |data|
      eval("@location.#{data['key']}=#{data['value']}")
  end
  @location.name = location
  @location.location_id = @parent.id
  @location.save
  @location.should be_true
  @location = nil
  @parent = nil
end

Given /^we create a warehouse called "([^"]*)" with the following attribute$/ do |warehouse, table|
  @warehouse = StockWarehouse.find(:first, :domain=>[['name','=',warehouse]], :fields => ['id'])
  unless @warehouse
      @warehouse = StockWarehouse.new()
  end
  table.hashes.each do |data|
      loc_id = StockLocation.find(:first, :domain=>[['name','=',eval("#{data['value']}")]], :fields => ['id'])
      loc_id.should_not be_nil, 
        "location #{data['value']} not found"
      eval("@warehouse.#{data['key']} = #{loc_id.id}")
  end
  @warehouse.name = warehouse
  @warehouse.save
  @warehouse.should be_true
end


Given /^the related partner of the warehouse "([^"]*)" is "([^"]*)"$/ do |warehouse,partner|
  @warehouse = StockWarehouse.find(:first, :domain=>[['name','=',warehouse]], :fields => ['id'])
  @warehouse.should be_true
  @partner = ResPartnerAddress.find(:first, :domain=>[['name','=',partner]], :fields => ['id'])
  @partner.should be_true
  @warehouse.partner_address_id = @partner.id
  @warehouse.save
end

Given /^I affect the company "([^"]*)" to the warhouse "([^"]*)"$/ do |company, warehouse|
  @warehouse = StockWarehouse.find(:first, :domain=>[['name','=',warehouse]], :fields => ['id'])
  @warehouse.should be_true
  @company = ResCompany.find(:first, :domain=>[['name','=',company]], :fields => ['id'])
  @company.should be_true
  @warehouse.company_id = @company.id
  @warehouse.save
end

Given /^the "([^"]*)" of the partner named "([^"]*)" is "([^"]*)"$/ do |stock_property, partner, location|
  @partner = ResPartner.find(:first, :domain=>[['name','=',partner]], :fields => ['id'])
  @partner.should be_true
  loc_id = StockLocation.find(:first, :domain=>[['name','=',location]], :fields => ['id'])
  loc_id.should be_true
  eval("@partner.#{stock_property}=#{loc_id.id}")
  @partner.save
end

Given /^I renamed (warehouse|location) named "([^"]*)" to "([^"]*)"$/ do |type, old_name, new_name|
  if type == 'warehouse':
    obj = StockWarehouse
  else
    obj = StockLocation
  end
  entitiy = obj.find(:first, :domain=>[['name', '=', old_name]], :fields=>['id', 'name'])
  if entitiy
    entitiy.name = new_name
    entitiy.save
  else
    puts "No #{type} named #{old_name} found"
  end
end
