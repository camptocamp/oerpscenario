# -*- encoding: utf-8 -*-
#################################################################################
#                                                                               #
#    OERPScenario, OpenERP Functional Tests                                     #
#    Copyright (C) 2011 Akretion Benoît Guillot <benoit.guillot@akretion.com>   #
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
#Payment type configuration
Given /^I the payment type with the name "([^"]*)" exists$/ do |payment_type_name|
  @payment_type = BaseSalePaymentType.find(:first, :domain => [['name', '=', payment_type_name]])
  @payment_type.should_not be_nil
end

When /^I set the following options:$/ do |table|
  # table is a |key|'value'|
  table.hashes.each do |data|
    @payment_type.send "#{data['key'].to_sym}=", eval(data['value'])
  end
end

And /^I set the payment journal on "([^"]*)"$/ do |journal_code|
  journal = AccountJournal.find(:first, :domain => [['code', '=', journal_code]])
  journal.should_not be_nil
  @payment_type.journal_id = journal.id
end

Then /^I save the payment type$/ do
  @payment_type.save
end

#Magento Shop Actions
Then /^I import the sale orders \(Import Orders\)$/ do
  SaleShop.import_orders([@shop.id]).should be_true
  @saleorders = SaleOrder.find(:all)
  @saleorders.each do |so|
    name = so.name
    @openerp.set_var(name.strip,so)
  end
end
