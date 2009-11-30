------------------------------------------------------
|                     OERPScenario                   |
------------------------------------------------------
Authors : Nicolas Bessi & Joel Grand-Guillaume 2009 
Copyright Camptocamp SA
------------------------------------------------------
------------------------------------------------------

-----------
MORE INFOS 
-----------

Find infos about OERPScenario here : https://launchpad.net/oerpsenario

Find infos about Cucumber library here : http://cukes.info/

Find infos about Ooor here : http://github.com/rvalyi/ooor

-------------------------------
USING THE TESTS SUITES SCENARIO 
-------------------------------

We use the test scenario using tags. You can find different types of tags, like:
 - @account     : This tag represent all tests scenario related to the account module of OpenERP
 - @addons      : This tag represent all tests scenario related to the addons branch of OpenERP
 - @invoicing   : This tag represent all tests scenario related to the invoicing process of OpenERP

Launch the test suite with :

cucumber features --tag=@invoicing,@account

Where "invoicing" and "account" are the desired tests scenario.

-----------
GUIDE LINES 
-----------

Be kind to follow the given instructions when writting tests scenario :) !

Write a new test scenario:
--------------------------

Tag:
----

The tag need to be set carefully because it's the way we use the test scenario suite. Add tage for:
 - Branch name, like @addons, @extra-addons
 - Module name, like @account, @stock
 - Scenario name, like @invoicing

A scenario represent a whole test case, using different module and features. Because all tests are already explained / descried through
the Gherkin syntax, you don't really need to provide any docs on them.

Folder structure and file name:
-------------------------------

doc/                                   => Auto-generated doc
|                                 
features/                              => Tests Scenarios folders
|                                 
-- _basic                              => Basic features and scenario, like login etc..
|
-- account/                            => One folder per module, give the folder the same name than in OpenERP
|
------ _pre.feature                    => Background definition, in order to run the folder's tests scenarios according to given settings
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


