------------------------------------------------------
|                     OERPScenario                   |
------------------------------------------------------
Authors : Nicolas Bessi & Joel Grand-Guillaume 2009 
Copyright Camptocamp SA
------------------------------------------------------


Find infos about OERPScenario here : https://launchpad.net/oerpsenario

Find infos about Cucumber library here : http://cukes.info/

Find infos about Ooor here : http://github.com/rvalyi/ooor

GUIDE LINES 
-----------

Be kind to follow the given instructions when writting tests scenario :) !

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


