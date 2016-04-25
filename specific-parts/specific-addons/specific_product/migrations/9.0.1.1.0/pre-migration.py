# -*- coding: utf-8 -*-
# © 2016 Cyril Gaudin (Camptocamp)
# License AGPL-3.0 or later (http://www.gnu.org/licenses/agpl.html).


def migrate(cr, version):

    # Suppression de tous les codes ENR en doublons.
    cr.execute(
        "UPDATE product_template SET e_nr=null WHERE e_nr IN ( "
        "SELECT e_nr FROM product_template WHERE NULLIF(e_nr, '') IS NOT NULL "
        "GROUP BY e_nr HAVING count(*) > 1"
        ")"
    )
