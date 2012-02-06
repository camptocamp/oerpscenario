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

When /^I set the incoming mail new record on model "([^"]*)"$/ do  |model_name|
  model = IrModel.find(:first, :domain => [['name', '=', model_name]])
  model.should_not be_nil
  @item.object_id = model.id
end

When /^I test and confirm the fetchmail server with reference "([^"]*)"$/ do |mail_server_ref|
  server = FetchmailServer.find(mail_server_ref)
  server.should_not be_nil
  FetchmailServer.button_confirm_login([server.id])
end