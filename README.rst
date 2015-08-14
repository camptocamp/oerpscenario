OERPScenario - Business Driven Development (BDD) for OpenERP/Odoo
#################################################################

OERPScenario is a tool to allows Business Driven Development (BDD). It allows
non-technical people to write real business cases, that will be tested among
OpenERP to ensure no regressions.

OERPScenario will allow us to detect regressions from one version to another by
running a test suites composed by scenario on a specified OpenERP server
(directly on the customer replication instance, or just on the last stable
release).

We also include in this brand new version written in Python and based on
Erppeek (http://erppeek.readthedocs.org/en/latest/) a complete DSL that allow
you to write tests at the speed of thought.

This means a business specialist can write something like the following: ::

    Scenario: SO013 CREATION
        Given I need a "sale.order" with name: SO013 and oid: scenario.anglosaxon_SO013
        And having:
        | name                | value                    |
        | date_order          | %Y-03-15                 |
        | name                | SO013                    |
        | partner_id          | by name: Simpson         |
        | pricelist_id        | by id: 1                 |
        | partner_invoice_id  | by name: Simpson         |
        | partner_order_id    | by name: Simpson         |
        | partner_shipping_id | by name: Simpson         |
        | shop_id             | by name: a shop          |
        | company_id          | by oid base.main_company |
        Given I need a "sale.order.line" with oid: scenario.anglosaxon_SO013_line1
        And having:
        | name            | value                             |
        | name            | SO013_line1                       |
        | product_id      | by code: 2003                     |
        | price_unit      | 450                               |
        | product_uom_qty | 1.0                               |
        | product_uom     | by name: PCE                      |
        | order_id        | by oid: scenario.anglosaxon_SO013 |

OERPscenario will allows you to connect to a remote or local instance using XML RPC.
For faster result or when working with huge data OERPScenario is able to embeed an Odoo/OpenERP service. This is possible if Odoo/OpenERP is available in syspath. Using the Anybox buildout recipe in conunction with OERPScenario is a good way to achieve this
`http://pypi.python.org/pypi/anybox.recipe.openerp <http://pypi.python.org/pypi/anybox.recipe.openerp>`_

Installation:
#############

``pip install openerpscenario``

Usage
#####
Checkout you own scenario branche.
Then run the following command ::

  openerp_scenario  Scenario/OERPScenario.local/ -t backend -k --server-config etc/openerp.cfg

This will run an enchanced version of behave. The -k option will only show executed scenario --t will launch specific scenario.


For more information, please refer to behave documentation:
`http://packages.python.org/behave/ <http://packages.python.org/behave/>`_

If you want to use **pdb** you have to set --no-capture option when launching ``openerp_scenario``.

Anatomy of a custom scenario folder
###################################

If you want to create your own custom scenario for your project,
you should use the guidelines below. The folder should be organized as follows::

  OERPScenario.local/
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
