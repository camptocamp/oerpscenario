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
When /^I pay the invoice$/ do
  @voucher=AccountVoucher.create_voucher(:invoice_id => @invoice.id)
  @voucher.should be_true
  @voucher.wkf_action('proforma_voucher')
  @voucher = AccountVoucher.find(@voucher.id)
  @invoice = AccountInvoice.find(@invoice.id)
  @voucher.state.should == 'posted'
  account_id = @invoice.account_id.id
  move_ids1 = @voucher.move_ids
  move_id1 = false
  move_id2 = false
  move_ids1.each do |move_id|  
    if move_id.account_id.id == account_id        
        move_id1 = move_id.id
    end
  end
  move_ids2 = @invoice.move_id.line_id
  move_ids2.each do |move_id|
    if move_id.account_id.id == account_id
        move_id2 = move_id.id
    end
  end
  @reconcile = AccountMoveLine.reconcile([move_id1, move_id2])
  @reconcile.should be_true
  @saleorder = SaleOrder.find(@saleorder.id)
end

