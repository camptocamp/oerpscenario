# -*- coding: utf-8 -*-
# © 2016 Camptocamp SA
# License AGPL-3.0 or later (http://www.gnu.org/licenses/agpl.html).

from openerp import api, models


class PadCommon(models.Model):
    _inherit = 'pad.common'

    @api.multi
    def copy(self, default=None):
        """ Don't generate Pad url when copying to the PAD will be create
        by JS when rendering the field with the original content.
        """
        pad = super(PadCommon, self.with_context(
            no_pad_url=True
        )).copy(default=default)

        return pad

    @api.model
    def _set_pad_value(self, vals):
        """ Don't touch to real field content if url was not generated.
        """
        if not self.env.context.get('no_pad_url'):
            super(PadCommon, self)._set_pad_value(vals)

    @api.model
    def pad_generate_url(self):
        """ If asked in context, don't generate PAD url.
        """
        if self.env.context.get('no_pad_url'):
            return {}

        return super(PadCommon, self).pad_generate_url()
