OpenERP Scenario in Python.
###########################

Integration of OpenERP scenario with Python, Behave and the Anybox buildout recipe:
`http://pypi.python.org/pypi/anybox.recipe.openerp <http://pypi.python.org/pypi/anybox.recipe.openerp>`_

Installation:
Refer to Anybox recipe documentation to create your instance.
Then you can add the following lines to your buildout config file::

  [python]
  recipe = zc.recipe.egg
  interpreter = python
  extra-paths = ${buildout:directory}/parts/server
  
  eggs = behave
         ERPpeek
         mock
         unittest2
         MarkupSafe
         Pillow
         PyXML
         babel
         feedparser
         gdata
         lxml
         mako
         psycopg2
         pychart
         pydot
         pyparsing
         python-dateutil
         python-ldap
         python-openid
         pytz
         pywebdav
         pyyaml
         reportlab
         simplejson
         vatnumber
         vobject
         werkzeug
         xlwt
         docutils

Usage
#####
Checkout the branch of Python scenario.
Then move to the root of your instance where the bin folder is located::

  bin/behave

should be available. To run some scenario launch the following command::

  bin/behave -k --tags=mytag ../path_to_python_scenario/features/ path_to_my_custom_scenario/features

The -k option will only show executed scenario --tags will launch specific scenario.
For more information, please refer to behave documentation:
`http://packages.python.org/behave/ <http://packages.python.org/behave/>`_

If you want to use **pdb** you have to set --no-capture option when launching
behave. You also need to set the BEHAVE_DEBUG_ON_ERROR environment variable to
"yes" to drop to the debugger on error. This is not always what you want: for
eexample in Continuous Integration systems you might want to fail early.

Anatomy of a custom scenario folder
###################################

If you want to create your own custom scenario for your project,
you should use the guidelines below. The folder should be organized as follows::

  OERPScenario/
  ├── data
  │   ├── account_chart.csv
  │   └── logo.png
  └── features
      ├── setup
      │   ├── 01_installation.feature
      │   └── 02_installation_after_import.feature
      ├── addons
      ├── steps
      ├── stories
      └── upgrade

* data: contains non code related data for your scenarios.
* features: mandatory folder, contains all features.
* setup: contains features required to set up all required data to run your tests.
* addons: contains addons specific tests, small independent scenarios.
* stories: contains user/workflow tests that are related.
* upgrade: scenario to update an instance.
* steps: contains Python code implementing the Gherkin phrases
