import unittest

# Unit tests enable testing for expected values against actual values.
# Expected == Actual ---> OK.
# Expected != Actual ---> FAIL.

# Create a test class which inherits from unittest.TestCase
# All functions contained within this subclass will be run
# as part of the unit test.
class Test(unittest.TestCase):
    def test_basic(self):
        self.assertTrue(True)
        
    def test_sum(self):
        sum = 0
        values = (1,2,3)
        for n in values:
            sum += n
        
        self.assertEqual(sum, 6)

# Run all unit test modules
unittest.main(argv = ['ignored', '-v'], exit = False)

# Test driven development incorporates:
# White/Clear box testing
# Black box or user testing
# Unit testing
# Debugging