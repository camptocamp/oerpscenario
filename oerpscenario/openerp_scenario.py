#! /usr/bin/env python
# -*- coding: utf-8 -*-
##############################################################################
#
#    Author: Nicolas Bessi
#    Copyright 2015 Camptocamp SA
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as
#    published by the Free Software Foundation, either version 3 of the
#    License, or (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU Affero General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
##############################################################################
import sys
import os
from behave import configuration
from behave import __main__

def main():
    # Adding custom options to behave
    configuration.parser.add_argument(
    '--server-config',
    help="Odoo/OpenERP server configuration file"
    )
    configuration.parser.add_argument(
    '--server-args',
    help="Odoo/OpenERP arguments to use. "
    "You should provide a string of agruments "
    "separated with a pipe: \n"
    "-c etc/openerp.cfg|--logfile=behave-stdout.log \n"
    "Only available if odoo/openerp is in sys path"
    )
    default_features = os.path.join(os.path.dirname(__file__), '..', 'features')
    args = tuple([default_features] + sys.argv[1:])
    # command that run behave
    __main__.main(args)

if __name__ == '__main__':
    main()
