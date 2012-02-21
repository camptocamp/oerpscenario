###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Author Nicolas Bessi 2009
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

module MemoizerUtils

  # Define a memorizer to store object handled by the test
  # Useful to store an invoice in a var which name = invoice name !
  def set_var(name, value)
    memoizer[name] = value
  end

  def get_var(name)
    memoizer[name]
  end

  def clean_var(name)
    memoizer.delete(name)
  end

  def clean_all_var
    memoizer.clear
  end

  def memoizer
    @memoizer ||= {}
  end
  private :memoizer

end