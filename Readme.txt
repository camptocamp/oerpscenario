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

We strongly recommande the use of RVM

(Install the core)

Gem install gem install cucumber-openerpscenario

(Optionnal for pdf output)
- Prawn
- Pawn format
- Rake (optional)


Get the latest scenario:
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

Run commands:
CONF=... cucumber features path_to_an_addon_scenarios_folder path_to_an_other_one
or
Make your rake file (Documented on cucumber Wiki)

