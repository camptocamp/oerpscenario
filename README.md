[![Build Status](https://magnum.travis-ci.com/camptocamp/swisslux_odoo.svg?token=s5esK5Nsrt4gBBYh6tSx&branch=master)](https://magnum.travis-ci.com/camptocamp/swisslux_odoo)
#Swisslux Odoo

Private and customer specific branches for Swisslux.

## Installation:

Steps:

1. Clone the github repository

        git clone git@github.com:camptocamp/swisslux_odoo.git

1. Got in the folder and bootstrap with the development profile

        ./bootstrap.sh profiles/dev.cfg

1. Build

        ./bin/buildout

:warning: do not use the other configuration files if you do not know what you
are doing

## Setup Scenario

Install:

    $ bin/oerpscenario -t swisslux -t setup

## Travis testing

This repository is tested against Travis.
The Pull Requests must conform to
[pep8](http://legacy.python.org/dev/peps/pep-0008/).
The lint command used is:

    flake8 specific-parts/specific-addons --exclude=__init__.py
