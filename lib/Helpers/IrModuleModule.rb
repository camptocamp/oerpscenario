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
  if Object.const_defined? 'IrModuleModule'
    ###############################################################################
    # Add useful methode on ir.module,module handling
    ##############################################################################
    IrModuleModule.class_eval do
      $utils.log.debug("Extending  #{self.class} #{self.name}")
      ##########################################################################
      # Run the upgrade wizard on all modules
      # Input :
      #  - 
      # Return
      #  - True
      # Usage Example:
      # res = IrModuleModule.update_needed_modules()
      # Deprecated
      def self.update_needed_modules()
        $utils.log.debug("DEBUG : update_needed_modules is deprecated")
        # Call the wizard on whatever module
        wizard = IrModuleModule.find(:first).old_wizard_step('module.upgrade.simple')
        # Run all state of the wizard
        step_dict = wizard.datas.merge({})
        res=wizard.init(step_dict)

        step_dict=res.datas.merge(step_dict)
        res=wizard.next(step_dict)

        step_dict=res.datas.merge(step_dict)
        res=wizard.start(step_dict)

        step_dict=res.datas.merge(step_dict)
        res=wizard.end(step_dict)
        $utils.ooor.load_models(false)
        if res
          return true
        else
          raise "!!! --- HELPER ERROR : update_needed_modules was unable to upgrade needed modules.."
        end
      end

      ##########################################################################
      # Run the quality check wizard on all requested modules
      # Input :
      #  - modules : A [] of valid IrModuleModule instance
      # Return
      #  - [] of Created ModuleQualityCheck instances
      # Usage Example:
      # result = IrModuleModule.run_base_quality_test(modules)
      if Object.const_defined? 'ModuleQualityCheck'
        def self.run_base_quality_test(modules)
          # Take the id of already recorded tests result
          # because we are unable to retrieve their ids from wizard
          # cause it has only one step 'init'
          already_stored_test_ids=[]
          ModuleQualityCheck.find(:all).each do |stored_result|
            already_stored_test_ids.push stored_result.id
          end
          modules.each do |m|
            # Call the wizard on module
            wizard = m.old_wizard_step('create_quality_check_wiz')
          end

          # Find all recorded tests, and substract old created ones
          all_stored_test_ids=[]
          ModuleQualityCheck.find(:all).each do |stored_result|
            all_stored_test_ids.push stored_result.id
          end
          new_ids=all_stored_test_ids-already_stored_test_ids
          res= ModuleQualityCheck.find(new_ids)

          if res
            return res
          else
            raise "!!! --- HELPER ERROR : run_base_quality_test was unable to upgrade needed modules.."
          end
        end
      else
        def self.run_base_quality_test(modules)
          $utils.log.info("INFO : Function not available")
        end
      end

      ##########################################################################
      # Run the upgrade wizard on all installed module, after the demo checkbox
      # had beend ticked and the state set to 'to upgrade' on the base module.
      # Does nothing if module are already with demo data
      # Input :
      #  -
      # Return
      #  - True
      # Usage Example:
      # res = IrModuleModule.load_demo_data_on_installed_modules()
      def self.load_demo_data_on_installed_modules()
        # find installed modules
        modules=IrModuleModule.find(:all, :domain => [['state', '=', 'installed']], :fields => ['id, demo, update', 'state'])
        update=false
        res=true
        modules.each do |m|
          if not m.demo
            m.demo=true
            update=true
            m.save
            m = nil
          end
        end
        # Find module base and set it to to upgrade if there is some module to update
        if update
          m=IrModuleModule.find(:first, :domain => [['name', '=', 'base']], :fields => ['id, demo, update, state'])
          m.state='to upgrade'
          m.save
          m = nil
        end

        if res
          return true
        else
          raise "!!! --- HELPER ERROR : load_demo_data_on_installed_modules was unable to upgrade needed modules.."
        end
        res = IrModuleModule.update_needed_modules()
      end


      ##########################################################################
      # Get recursively the whole list of modules dependencies
      # for a list of modules.
      # Do not add the module if it already exists in the input list
      # Input :
      #  - modules : A [] of valid IrModuleModule instances with dependencies_id attribute
      # Return
      #  -  [] of dependencies
      # Usage Example:
      # dependency_modules = get_dependencies(modules)
      def self.get_dependencies(modules)
        dependency_modules = []
        modules.select { |m| m.dependencies_id }.each do |mod|
          mod.dependencies_id.each do |dep|
            dep_module = IrModuleModule.find(:first,
                                             :domain => [['name', '=', dep.name]],
                                             :fields => ['id', 'state', 'dependencies_id'])
            if dep_module.nil?
              raise RuntimeError, "#{dep.name} not found"
            end
            dependency_modules << dep_module unless modules.map { |m| m.id }.include? dep_module.id
          end
        end
        dependency_modules.concat(get_dependencies(dependency_modules)) if dependency_modules.count > 0
        dependency_modules
      end

      ##########################################################################
      # Run the upgrade wizard in order to install the required
      # modules. Upgrade installed modules as well.
      # Input :
      #  - modules : A [] of valid IrModuleModule instance
      # Return
      #  - True
      # Usage Example:
      # res = IrModuleModule.install_modules(modules)
      def self.install_modules(modules, dependencies=false)
        res = true
        if dependencies
          dependency_modules = get_dependencies(modules)
          modules.concat(dependency_modules) if dependency_modules
        end
        modules_toinstall_ids = []
        modules_toupgrade_ids = []
        # If not installed, do it. Otherwise update it
        modules.each do |m|
          if m.state == 'uninstalled'
            m.state = 'to install'
            m.save
            modules_toinstall_ids << m.id
          elsif m.state == 'installed'
            m.state = 'to upgrade'
            m.save
            modules_toupgrade_ids << m.id
          elsif m.state == 'to install'
            modules_toinstall_ids << m.id
          elsif m.state == 'to upgrade'
            modules_toupgrade_ids << m.id
          end
        end
        #First installed required modules, then upgrade the others
        upgrade = BaseModuleUpgrade.create()
        upgrade.upgrade_module()
        # IrModuleModule.button_install(modules_toinstall_ids)
        # IrModuleModule.button_upgrade(modules_toupgrade_ids)

        if res
          return true
        else
          raise "!!! --- HELPER ERROR : install_modules was unable to install needed modules.."
        end
        $utils.ooor.load_models() # reload in order to have model Classes for modules installed
      end

    end

  else
    $utils.log.debug("IrModuleModule helper not initialized")
  end
rescue Exception => e
  $utils.log.fatal("ERROR : #{e.to_s}")
end
