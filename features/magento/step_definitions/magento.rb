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



