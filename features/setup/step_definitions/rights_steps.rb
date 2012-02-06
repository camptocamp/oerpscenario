###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Author Guewen Baconnier
#    Copyright Camptocamp SA 2011
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

# Users

Given /^we select all users$/ do
  @users = ResUsers.find(:all, :domain => [['login', '!=', 'admin']])
end

Given /^we select admin user$/ do
  @users = ResUsers.find(:all, :domain => [['login', '=', 'admin']])
end

Then /^we add their current company in the allowed companies$/ do
  @users.each do |user|
    user.company_ids = [user.company_id.id]
  end
end

When /^we select users below:$/ do |users_table|
  # table is a | login |
  user_logins = users_table.hashes.map { |row| row['login'] }
  @users = ResUsers.find(:all, :domain => [['login', 'in', user_logins]])
  @users.count.should == user_logins.count
end

Then /^we set the allowed companies below to the users:$/ do |companies_table|
  # table is a | name |
  company_names = companies_table.hashes.map { |row| row['name'] }
  @companies = ResCompany.find(:all, :domain => [['name', 'in', company_names]], :fields => ['id'])
  @companies.count.should == company_names.count
  company_ids = @companies.map { |company| company.id}
  @users.each do |user|
    user.company_ids = company_ids
    user.save
  end
end

def user_save(user)
  user.attributes.delete('new_password')  #cannot save if field is in the user
  user.save
end

def assign_groups(user, groups)
  group_ids = groups.map {|g| g.id}
  current_groups = user.groups_id.map {|g| g.id}
  user.groups_id = (current_groups + group_ids).uniq
  user_save(user)
end

Then /^we assign to the users the groups below:$/ do |groups_table|
  # table is a | group_name |
  group_names = groups_table.hashes.map { |row| row['group_name'] }
  groups = ResGroups.find(:all, :domain => [['name', 'in', group_names]])
  groups.count.should == group_names.count
  @users.each do | user |
    assign_groups(user, groups)
  end
end

Then /^we assign all groups to the users$/ do
  groups = ResGroups.find(:all)
  @users.each do | user |
    assign_groups(user, groups)
  end
end

Then /^we activate the extended view on the users$/ do
  @users.each do |user|
    user.view = 'extended'
    user_save(user)
  end
end
