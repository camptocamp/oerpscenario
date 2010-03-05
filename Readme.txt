###############################################################################
                                OERPScenario                   
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

HOW AND WHY
##############################################################################

This project is based on cucumber http://cukes.info/ library. We use also the Ooor 
mapper from RValyi that allows you to do the basic actions like: read, search, 
write, execute, unlink, create, 

We have choosen to use those library for those main reasons:

-It's separated from OpenERP. We do not want to have a scenario tools integrated
 with the ERP. In order to avoid ERP bug repercution in the system

-It allows business specialists to write test without having any technical skills,
 and allows the devloppers to semantikly implements the tests
 
-It allow you to code new tests scenarios very quickly

-It allows to internationalise tests (translation and so on)

-The active record connector will allow us to do database validation 
 and why not, one day, corrections on the fly.

-It is modular, so you can create separate features and steps files that will
 allow you to create customer specific tests.

-It is fully integrated to rails, that means in a near futur, we'll be able to 
 create a web site where users will input the server parameters and see results 
 in live. (This is why we release it under GPLv3.0 AFFERO Licence)

-Ruby and Ooor Rocks


TRY IT : SETUP AND INSTALLATION !
##############################################################################

Install libraries and dependencies 
----------------------------------

- Ruby & Rubygems
- Cucumber (V. 0.5.1) 0.6.3
- Rspec
- Parseconfig
- Ooor (V. 1.2.8+)
- Rake (optional)
- htmlentities

(Optionnal for pdf output)
- Prawn (V.0.6.3)
- Pawn format (V. 0.2.3)


Commands On Ubuntu 9.10
-----------------------
sudo apt-get install ruby irb ri rdoc rubygems
sudo gem install cucumber -v0.5.1
sudo gem install rspec
sudo gem install parseconfig
sudo gem install ooor --source http://gemcutter.org
sudo apt-get install libopenssl-ruby
sudo gem install rake
sudo gem install htmlentities

(Optionnal for pdf output)
sudo gem install prawn --version 0.6.3
sudo gem install prawn-format --version 0.2.3

Finally add '/var/lib/gems/1.8/bin' to your PATH (Thanks to C. Almeida for the infos):

export PATH=$PATH:/var/lib/gems/1.8/bin

Get the sources
------------------

Trunk:
bzr branch lp:oerpscenario

For stable:
bzr branch lp:oerpscenario/stable oerpscenario_stable

Configure it
------------------

Create the parameter file "base.conf" according to your settings in the oerpscenario_stable folder
(look at sample_base.conf):

port = 8069
user = admin
database = mydatabase
password = toto
host = localhost

!!! Watch out !!! 

In our samples (both base.conf and _basic.feature), the admin user has the password set to 'admin'. 
You have here two things to differenciate:

1. The password into the base.conf, for connexion purpose
2. The password use by one of the scenario (_basic.feature) to run the test case as a specific user

For the second one, the textual description of the scenario is parsed by the cucumber library to
give the right password to run the test. This means the test case try to login with a given password. 
In order to change that, you need to edit the description of each concerned scenario 
and change it according to your settings. Here an example:

Background: login
  Given I am loged as USERNAME user with password MY_NEW_PASSWORD used

This will also allow you to change the logged user to test the security on object, workflows,...

USING THE TESTS SUITES SCENARIO 
##############################################################################

First, ensure you have installed at least the profile_accounting on your OpenERP instance to test.

We use the test scenario using tags. You can find different types of tags, like:
 - @account     : This tag represent all tests scenario related to the account module of OpenERP
 - @addons      : This tag represent all tests scenario related to the addons branch of OpenERP
 - @invoicing   : This tag represent all tests scenario related to the invoicing process of OpenERP
 - @bugNUMBER   : This tag test the tests cases related to a Launchpad bug number

Launch the test suite with :

cd oerpscenario
cucumber features --tag=@init --tag=@account

Where "init" and "account" are the desired tests scenario. You can add also an output format
like :

cucumber features --tag=@invoicing --tag=@account --format=html >/tmp/result.html&&open  /tmp/result.html

Usually, we recommand to launch the test suite with the name of the module to be tested. Have a look
here for more infos about tag usage : http://wiki.github.com/aslakhellesoy/cucumber/tags

Optionnal rake command (require to install rake gem):

rake compile     => To test the compilation of the tests suite
rake demo        => To install demo data on installed module (same as : cucumber features --tag=@demo)
rake quality     => To launch base_module_quality tests on all installed module

Other will come...



MORE INFOS 
##############################################################################

Find code and infos about OERPScenario here : https://launchpad.net/oerpscenario

Find infos about Cucumber library here : http://cukes.info/

Find infos about Ooor here : http://github.com/rvalyi/ooor


GUIDE LINES TO CONTRIBUTE
##############################################################################

Be kind to follow the given instructions when writting tests scenario :) !

Write a new test scenario:
--------------------------

TODO

Tag:
----

The tag need to be set carefully because it's the way we use the test scenario suite. Add tage for:
 - Branch name, like @addons, @extra-addons
 - Module name, like @account, @stock
 - Scenario name, like @invoicing, @reconciliation
 - For Wizards add @wizard

A scenario represent a whole test case, using different module and features. Because all tests are already explained / descried through
the Gherkin syntax, you don't really need to provide any docs on them.

Folder structure and file name:
-------------------------------

doc/                                   => Auto-generated doc
|                                 
features/                              => Tests Scenarios folders
|                                 
-- _basic                              => Basic features and the _pre_steps for every _pre.features
|
-- account/                            => One folder per module, give the folder the same name than in OpenERP
|
------ _pre.feature                    => Initialization definition, in order to run the folder's tests scenarios according to given settings
|
------ invoice.feature                 => Tests scenario using Gherkin syntax concerning invoice.py file into OpenERP, give the same filename
...
------ step_definitions/               => Related Ruby functions to run the tests
|
---------- invoice.rb                  => Ruby function for the coresponding .feature file (here for invoice.feature)
|
------ wizard/                         => Wizard tests definitions
|
---------- pay_invoice.feature         => Tests scenario using Gherkin syntax concerning pay invoice wizard into OpenERP, give the same filename
|
---------- step_definitions            => Related Ruby functions to run the wizard tests
|
---------------- wizard_pay_invoice.rb => Ruby function for the coresponding .feature file (here for pay_invoice.feature)
|
-- account_payment
|
-- ...
|
-- support/
|
------ env.rb                          => Make first login and require Helpers
|
lib/                                   => Function and Class library
|
-- ERPConnector.rb                     => OERPScenario definition, setup Ooor according to conf file
|
-- Helpers/                            => All helpers to improve the tests scenarios writting
|
------ AccountInvoice.rb               => Helper concerning AccountInvoice object, use Ruby object as filename


