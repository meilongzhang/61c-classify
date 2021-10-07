from unittest import TestCase
from framework import AssemblyTest, print_coverage

"""
Coverage tests for project 2 is meant to make sure you understand
how to test RISC-V code based on function descriptions.
Before you attempt to write these tests, it might be helpful to read
unittests.py and framework.py.
Like project 1, you can see your coverage score by submitting to gradescope.
The coverage will be determined by how many lines of code your tests run,
so remember to test for the exceptions!
"""

"""
abs_loss
# =======================================================
# FUNCTION: Get the absolute difference of 2 int vectors,
#   store in the result vector and compute the sum
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int*) is the pointer to the start of the result vector

# Returns:
#   a0 (int)  is the sum of the absolute loss
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 123.
# =======================================================
"""
class TestAbsLoss(TestCase):
    def test_simple(self):
        # load the test for abs_loss.s
        t = AssemblyTest(self, "abs_loss.s")
        # create array0 in the data section
        array0 = t.array([1,2,3,4,5])
        # load address of `array0` into register a0
        t.input_array("a0", array0)
        # create array1 in the data section
        array1 = t.array([-1, -2, 4, 2, 3])
        # load address of `array1` into register a1
        t.input_array("a1", array1)
        # set a2 to the length of the array
        t.input_scalar("a2", len(array1))
        # create a result array in the data section (fill values with -1)
        array2 = t.array([-1, -1, -1, -1, -1])
        # load address of `array2` into register a3
        t.input_array("a3", array2)
        # call the `abs_loss` function
        t.call("abs_loss")
        # check that the result array contains the correct output
        t.check_array(array2, [2, 4, 1, 2, 2])
        # check that the register a0 contains the correct output
        t.check_scalar("a0", 11)
        # generate the `assembly/TestAbsLoss_test_simple.s` file and run it through venus
        t.execute()
        
    def test_neg(self):
        # load the test for abs_loss.s
        t = AssemblyTest(self, "abs_loss.s")
        # create array0 in the data section
        array0 = t.array([-1,-2])
        # load address of `array0` into register a0
        t.input_array("a0", array0)
        # create array1 in the data section
        array1 = t.array([-6, -2])
        # load address of `array1` into register a1
        t.input_array("a1", array1)
        # set a2 to the length of the array
        t.input_scalar("a2", len(array1))
        # create a result array in the data section (fill values with -1)
        array2 = t.array([-1, -1])
        # load address of `array2` into register a3
        t.input_array("a3", array2)
        # call the `abs_loss` function
        t.call("abs_loss")
        # check that the result array contains the correct output
        t.check_array(array2, [5, 0])
        # check that the register a0 contains the correct output
        t.check_scalar("a0", 5)
        # generate the `assembly/TestAbsLoss_test_simple.s` file and run it through venus
        t.execute()
        
    def test_empty(self):
        # load the test for abs_loss.s
        t = AssemblyTest(self, "abs_loss.s")
        # create array0 in the data section
        array0 = t.array([])
        # load address of `array0` into register a0
        t.input_array("a0", array0)
        # create array1 in the data section
        array1 = t.array([])
        # load address of `array1` into register a1
        t.input_array("a1", array1)
        # set a2 to the length of the array
        t.input_scalar("a2", len(array1))
        # create a result array in the data section (fill values with -1)
        array2 = t.array([])
        # load address of `array2` into register a3
        t.input_array("a3", array2)
        # call the `abs_loss` function
        t.call("abs_loss")
        # generate the `assembly/TestAbsLoss_test_simple.s` file and run it through venus
        t.execute(code=123)
        
    @classmethod
    def tearDownClass(cls):
        print_coverage("abs_loss.s", verbose = False)


"""
squared_loss
# =======================================================
# FUNCTION: Get the squared difference of 2 int vectors,
#   store in the result vector and compute the sum
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int*) is the pointer to the start of the result vector

# Returns:
#   a0 (int)  is the sum of the squared loss
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 123.
# =======================================================
"""
class TestSquaredLoss(TestCase):

    def test_simple(self):
        # load the test for squared_loss.s
        t = AssemblyTest(self, "squared_loss.s")
        # create input arrays in the data section
        array1 = t.array([1, 3, 5])
        array2 = t.array([2, 4, 0])
        # load array addresses into argument registers
        t.input_array("a0", array1)
        t.input_array("a1", array2)
        # load array length into argument register
        t.input_scalar("a2", len(array1))
        # create a result array in the data section (fill values with -1)
        array3 = t.array([-1, -1, -1])
        # load result array address into argument register
        t.input_array("a3", array3)
        # call the `squared_loss` function
        t.call("squared_loss")
        # check that the result array contains the correct output
        t.check_array(array3, [1, 1, 25])
        # check that the register a0 contains the correct output
        t.check_scalar("a0", 27)
        # generate the `assembly/TestSquaredLoss_test_simple.s` file and run it through venus
        t.execute()
        
    def test_neg(self):
        # load the test for squared_loss.s
        t = AssemblyTest(self, "squared_loss.s")
        # create input arrays in the data section
        array1 = t.array([-1, -3, -5])
        array2 = t.array([-2, -4, 0])
        # load array addresses into argument registers
        t.input_array("a0", array1)
        t.input_array("a1", array2)
        # load array length into argument register
        t.input_scalar("a2", len(array1))
        # create a result array in the data section (fill values with -1)
        array3 = t.array([-1, -1, -1])
        # load result array address into argument register
        t.input_array("a3", array3)
        # call the `squared_loss` function
        t.call("squared_loss")
        # check that the result array contains the correct output
        t.check_array(array3, [1, 1, 25])
        # check that the register a0 contains the correct output
        t.check_scalar("a0", 27)
        # generate the `assembly/TestSquaredLoss_test_simple.s` file and run it through venus
        t.execute()

    def test_empty(self):
        # load the test for squared_loss.s
        t = AssemblyTest(self, "squared_loss.s")
        # create input arrays in the data section
        array1 = t.array([])
        array2 = t.array([])
        # load array addresses into argument registers
        t.input_array("a0", array1)
        t.input_array("a1", array2)
        # load array length into argument register
        t.input_scalar("a2", len(array1))
        # create a result array in the data section (fill values with -1)
        array3 = t.array([])
        # load result array address into argument register
        t.input_array("a3", array3)
        # call the `squared_loss` function
        t.call("squared_loss")
        # generate the `assembly/TestSquaredLoss_test_simple.s` file and run it through venus
        t.execute(code=123)

    @classmethod
    def tearDownClass(cls):
        print_coverage("squared_loss.s", verbose = False)

"""
zero_one_loss
# =======================================================
# FUNCTION: Generates a 0-1 classifer vector inplace in the result vector,
#  where result[i] = (v0[i] == v1[i])
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int*) is the pointer to the start of the result vector

# Returns:
#   NONE
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 123.
# =======================================================
"""
class TestZeroOneLoss(TestCase):
    def test_simple(self):
        # load the test for zero_one_loss.s
        t = AssemblyTest(self, "zero_one_loss.s")
        # create input arrays in the data section
        array1 = t.array([1, 2, 4, 3])
        array2 = t.array([2, 2, 3, 3])
        # load array addresses into argument registers
        t.input_array("a0", array1)
        t.input_array("a1", array2)
        # load array length into argument register
        t.input_scalar("a2", len(array1))
        # create a result array in the data section (fill values with -1)
        array3 = t.array([-1, -1, -1, -1])
        # load result array address into argument register
        t.input_array("a3", array3)
        # call the `zero_one_loss` function
        t.call("zero_one_loss")
        # check that the result array contains the correct output
        t.check_array(array3, [0, 1, 0, 1])
        # generate the `assembly/TestZeroOneLoss_test_simple.s` file and run it through venus
        t.execute()
        
    def test_neg(self):
        # load the test for zero_one_loss.s
        t = AssemblyTest(self, "zero_one_loss.s")
        # create input arrays in the data section
        array1 = t.array([-1, -2])
        array2 = t.array([-1, 2])
        # load array addresses into argument registers
        t.input_array("a0", array1)
        t.input_array("a1", array2)
        # load array length into argument register
        t.input_scalar("a2", len(array1))
        # create a result array in the data section (fill values with -1)
        array3 = t.array([-1, -1])
        # load result array address into argument register
        t.input_array("a3", array3)
        # call the `zero_one_loss` function
        t.call("zero_one_loss")
        # check that the result array contains the correct output
        t.check_array(array3, [1, 0])
        # generate the `assembly/TestZeroOneLoss_test_simple.s` file and run it through venus
        t.execute()
        
    def test_empty(self):
        # load the test for zero_one_loss.s
        t = AssemblyTest(self, "zero_one_loss.s")
        # create input arrays in the data section
        array1 = t.array([])
        array2 = t.array([])
        # load array addresses into argument registers
        t.input_array("a0", array1)
        t.input_array("a1", array2)
        # load array length into argument register
        t.input_scalar("a2", len(array1))
        # create a result array in the data section (fill values with -1)
        array3 = t.array([])
        # load result array address into argument register
        t.input_array("a3", array3)
        # call the `zero_one_loss` function
        t.call("zero_one_loss")
        # generate the `assembly/TestZeroOneLoss_test_simple.s` file and run it through venus
        t.execute(code=123)
    @classmethod
    def tearDownClass(cls):
        print_coverage("zero_one_loss.s", verbose = False)

"""
initialize_zero
# =======================================================
# FUNCTION: Initialize a zero vector with the given length
# Arguments:
#   a0 (int) size of the vector

# Returns:
#   a0 (int*)  is the pointer to the zero vector
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 123.
# - If malloc fails, this function terminats the program with exit code 122.
# =======================================================
"""
class TestInitializeZero(TestCase):
    def test_simple(self):
        t = AssemblyTest(self, "initialize_zero.s")

        # input the length of the desired array
        length = 5
        t.input_scalar("a0", length)
        # call the `initialize_zero` function
        t.call("initialize_zero")
        # check that the register a0 contains the correct array (hint: look at the check_array_pointer function in framework.py)
        t.check_array_pointer("a0", [0, 0, 0, 0, 0])
        t.execute()
        
    def test_zero(self):
        t = AssemblyTest(self, "initialize_zero.s")

        # input the length of the desired array
        length = 0
        t.input_scalar("a0", length)
        # call the `initialize_zero` function
        t.call("initialize_zero")
        # check that the register a0 contains the correct array (hint: look at the check_array_pointer function in framework.py)
        t.execute(code=123)
        
    def test_malloc(self):
        t = AssemblyTest(self, "initialize_zero.s")

        # input the length of the desired array
        length = 2**32 - 1
        t.input_scalar("a0", length)
        # call the `initialize_zero` function
        t.call("initialize_zero")
        t.execute(code=122)
        
    def test_neg(self):
        t = AssemblyTest(self, "initialize_zero.s")

        # input the length of the desired array
        length = -4
        t.input_scalar("a0", length)
        # call the `initialize_zero` function
        t.call("initialize_zero")
        # check that the register a0 contains the correct array (hint: look at the check_array_pointer function in framework.py)
        t.execute(code=123)

    @classmethod
    def tearDownClass(cls):
        print_coverage("initialize_zero.s", verbose = False)
