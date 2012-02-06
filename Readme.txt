###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Author Joel Grand-Guillaume 2012
#    Copyright Camptocamp SA, Akretion
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

USAGE & GUIDLINES:
==================
=================

Every main addons folder (in oerp_addons) should have an init.feature that will build the basic
config for this module. 

In this feature, we should place a tag with a name like : @init_NAME_OF_MODULE. This will allow us to launch 
OERPScenario with only tag @init_base to install a DB.

In the rakefile, we should code the sequence of tag to launch for a certaiin purpose (like : @init_base, 
@init_account, @init_magentoerpconnect)

Examples:

 * l10n_ch will define and install the chart of account
 * base will create a DB and configure the main company


Available Tags :
=================
=================

@init_base: 






Folder Hierachie:
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



