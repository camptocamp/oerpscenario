###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Author Joel Grand-Guillaume 2012
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


INSTALLATION
==================
==================

Install libraries and dependencies 
----------------------------------

- Ruby (1.8) & Rubygems
- Cucumber (V. 1.1.4)
- Rspec
- Parseconfig
- Ooor (V. 1.2.8+)
- Rake (optional)
- htmlentities

(Optionnal for pdf output)
- Prawn
- Pawn format


Commands On Ubuntu 10.04
-----------------------
sudo apt-get install ruby1.8-dev irb ri rdoc rubygems
sudo gem install cucumber -1.1.4
sudo gem install rspec
sudo gem install parseconfig
sudo gem install ooor --source http://gemcutter.org
sudo apt-get install libopenssl-ruby
sudo gem install rake
sudo gem install htmlentities
sudo gem install ooor_finders

(Optionnal for pdf output)
sudo gem install prawn
sudo gem install prawn-format

Finally add '/var/lib/gems/1.8/bin' to your PATH (Thanks to C. Almeida for the infos):

export PATH=$PATH:/var/lib/gems/1.8/bin

Get the sources
------------------

Trunk:
bzr branch lp:oerpscenario

Configure it
------------------

Create the parameter file "base.conf" according to your settings in the folder
(look at sample_base.conf):

port = 8069
user = admin
database = mydatabase
password = toto
host = localhost


USAGE & GUIDLINES:
==================
==================

Every main addons folder (in oerp_addons) should have an init.feature that will build the basic
config for this module. 

In this feature, we should place a tag with a name like : @init_NAME_OF_MODULE. This will allow us to launch 
OERPScenario with only tag @init_base to install a DB.

In the rakefile, we should code the sequence of tag to launch for a certaiin purpose (like : @init_base, 
@init_account, @init_magentoerpconnect)

Examples:

 * l10n_ch will define and install the chart of account
 * base will create a DB and configure the main company


Available Tags & Rake :
=======================
=======================

Launch "rake -T" to have all the list of available rake file...


Enable debug mode:
=================
=================

Look at the "env.rb" file into the support folder and change : utils.log.level = Logger::WARN

Folder Hierarchy:
=================
=================

Here is a list of the main folder with content:

oerp_addons: => One folder per OpenERP addons
------------

setup: => All step definitions for setuping a new database
------

sample: => Just sample of a new test folder
-------

support: => parsing of helpers and login to database define in .conf file + all system related stuffs (like the @compile tag used in the rakefile)
--------

datas: => Folder used to store the dump file for testing Magento and Prestshop while waiting for a full Vagrant-self-configured one ;)
------

