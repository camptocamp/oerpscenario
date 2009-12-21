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
include Ooor


# Add useful methode on ir.module,module handling
##############################################################################
IrModuleModule.class_eval do 
  ##########################################################################
  # Run the upgrade wizard on all requested module
  # Input :
  #  - 
  # Return
  #  - True
  # Usage Example:
  # res = IrModuleModule.update_needed_modules()
  def self.update_needed_modules()
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

    if res :
      return true
    else
      raise "!!! --- HELPER ERROR : update_needed_modules was unable to upgrade needed modules.."
    end
  end

  ##########################################################################
  # Run the upgrade wizard on all installed module, after the demo checkbox
  # had beend ticked and the state set to 'to upgrade' on the base module.
  # Input :
  #  -
  # Return
  #  - True
  # Usage Example:
  # res = IrModuleModule.load_demo_data_on_installed_modules()
  def self.load_demo_data_on_installed_modules()
    # find installed modules
    modules=IrModuleModule.find(:all,:domain=>[['state','=','installed']])
    # set demo true
    modules.each do |m|
      m.demo=true
      m.save
      # Find module base and set it to to upgrade
      m=IrModuleModule.find(:first,:domain=>[['name','=','base']])
      m.state='to upgrade'
      m.save
    end
    res = IrModuleModule.update_needed_modules()
    if res :
      return true
    else
      raise "!!! --- HELPER ERROR : load_demo_data_on_installed_modules was unable to upgrade needed modules.."
    end
  end

end

