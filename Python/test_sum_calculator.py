import unittest
from sum import calculate_sum

class TestSumCalculator(unittest.TestCase):

    def test_empty_list(self):
        self.assertEqual(calculate_sum([]), 0)

    def test_positive_numbers(self):
        self.assertEqual(calculate_sum([1, 2, 3, 4]), 10)

    def test_negative_numbers(self):
        self.assertEqual(calculate_sum([-1, -2, -3]), -6)

    def test_mixed_numbers(self):
        self.assertEqual(calculate_sum([10, -5, 3]), 8)

    def test_single_element(self):
        self.assertEqual(calculate_sum([42]), 42)

if __name__ == '__main__':
    unittest.main()