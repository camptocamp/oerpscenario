# -*- coding: utf-8 -*-
# © 2016 Cyril Gaudin (Camptocamp)
# License AGPL-3.0 or later (http://www.gnu.org/licenses/agpl.html).


def migrate(cr, version):

    # Suppression de toutes les ref en doublons.
    cr.execute(
        "UPDATE res_partner SET ref=null WHERE ref IN ( "
        "SELECT ref FROM res_partner WHERE NULLIF(ref, '') IS NOT NULL "
        "GROUP BY ref HAVING count(*) > 1"
        ")"
    )

    # Pour les partner inactif, on mets une ref bidon
    cr.execute("UPDATE res_partner SET ref=id::text WHERE not active")
