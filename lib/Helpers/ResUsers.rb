###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Author Nicolas Bessi & Joel Grand-Guillaume 2009 
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
require 'pp'
require 'rubygems'
require 'ooor'

begin
    # Add useful methode on partner handling
    ##############################################################################
    ResUsers.class_eval do 
        $utils.log.debug("Extending  #{self.class} #{self.name}")

        def self.add_role(user_login, group_array)
            if group_array != :all
                if group_array.empty?
                    announce("no group given")
                    return
                end
            end

            user = ResUsers.find(:first, :domain => [['login','=',user_login]])
            unless user
                raise 'no user found'
            end
            roles = user.roles_id
            if roles 
                roles.map! {|x| x=x.id}
            else
                roles = []
            end
            if group_array == :all
                ResRoles.find(:all, :fields => ['id'] ).each do |g|
                    roles.push g.id
                end
            else
                group_array.each do |role|
                    g = ResRoles.find(:first, :domain=> [['name','=', role ]], :fields => ['id'])
                    if g 
                        roles.push g.id
                    end
                end
            end
            user.roles_id = roles
            user.save

        end

        def self.add_group(user_login, group_array, ignor_non_exsiting=false)
            if group_array.empty?
                announce("no group given")
            else
                user = ResUsers.find(:first, :domain => [['login','=',user_login]])
                unless user
                    if ignor_non_exsiting 
                        announce("no user found for #{user_login}") 
                        return
                    else 
                        raise "no user found for #{user_login}" 
                    end
                end
                groups = user.groups_id
                if groups 
                    groups.map! {|x| x=x.id}
                else
                    groups = []
                end
                group_array.each do |group|
                    g = ResGroups.find(:first, :domain=> [['name','=', group ]])
                    if g 
                        groups.push g.id
                    end
                end
                user.groups_id = groups
                user.save
            end
        end


        def self.add_access(acessname, group, o_model, perm = {})
            if IrModelAccess.find(:first, :domain=>[['name','=',acessname]],:fields=>['id'])
                $log.error "Access #{acessname} allready exist".red
            else
                permissions = {:read => false, :write =>false, :create => false, :unlink => false}.merge(perm)
                model_id = IrModel.find(:first, :domain=> [['model','=',o_model]],:fields=>['id']).id
                group_id = ResGroups.find(:first, :domain=>[['name','=',group]],:fields=>['id']).id
                access = IrModelAccess.new
                access.name = acessname
                access.model_id = model_id
                access.group_id = group_id
                permissions.each do |key, val|
                    eval("access.perm_#{key.to_s} = #{val}")
                end
                access.create()
            end
        end
    end
rescue Exception => e
    $utils.log.fatal("ERROR : #{e.to_s}")
end