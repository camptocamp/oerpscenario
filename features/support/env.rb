###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Author Nicolas Bessi 2009
#    Contribs Joel Grand-Guillaume 2009 
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
$VERBOSE = nil
$LOAD_PATH << '.'
require 'lib/ERPConnector'
require 'rubygems'
require 'ooor'
require 'tmpdir'

# Create a login if not initialized in feathures
unless $utils
    $utils = ScenarioUtils.new
    #  Avaiable INFO, WARN, ERROR, DEBUG
    $utils.log.level = Logger::WARN
end
begin
    unless $utils.ready?
        $utils.log.info("Attempt to connect")
        $utils.create_ooor_connexion
    end
rescue Exception => e
    $utils.log.warn("#{e.to_s}")
    $utils.log.info("Force reconnect")
    $utils.create_ooor_connexion
end



# Use a temporary directory
# we to do use mktempdir else in case of crash we will have a lot a temp folder
$tmpdir = File.join(Dir.tmpdir, 'oerps_folder')
begin
  Dir.mkdir($tmpdir)
rescue Exception=>e
  $utils.log.warn("WARNING : Can't create tmpdir #{e.to_s}")
end

# "after all"
at_exit do
    begin
      FileUtils.remove_entry_secure $tmpdir
    rescue Exception => e
      $utils.log.debug("DEBUG : Some tags does not create tmp dir")
    end
end
