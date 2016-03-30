# -*- coding: utf8 -*-
from openerp.tests import TransactionCase


class TestProduct(TransactionCase):

    def test_name_search(self):
        product_model = self.env['product.product']

        product_model.create({'name': 'Unittest P1',  'e_nr': 'fake_enr1'})
        product_model.create({'name': 'P2', 'e_nr': 'fake_enr2'})

        self.assertEqual(1, len(product_model.name_search('unittest')))
        self.assertEqual(2, len(product_model.name_search('fake')))

        # Test with limit=None to highlight name_search little bug
        product_model.name_search('unittest_enr', limit=None)
