WIP!

Currently this works with openobject-mirliton.

The way I have been running things so far:

1. follow the setup instructions of openobject-mirliton_

.. _openobjec-mirliton: https://github.com/florentx/openobject-mirliton

2. symlink the oerpscenario branch in the demo/ directory
3. run ``bin/behave oerpscenario/features -t @tag`` (nice additional
   command line options: ``--stop`` and ``-v``)




Standalone mode
---------------

known dependencies:

* behave
* erppeek
* unittest2 (pas certain de l'importance de la dépendance)
* mock (idem)


Portage notes
-------------

check https://github.com/florentx/openobject-mirliton/blob/buildout/features/README.rst

XXX write useful stuff
