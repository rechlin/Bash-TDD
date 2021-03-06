# Bash-TDD
A simple library for testing code using Bash. Can be used to test scripts written in Bash or other languages.

To test your bash scripts, or to use Bash to test other scripts, you need a way to create tests quickly and easily. I have created a library to support testing in bash. I have used this technique to test Bash, Python, and Perl scripts.

# Design

Basically, the goal of the test scripts is to run some tests on your application/script and report:

* What tests were run
* What tests failed
* A summary:
  * Failure notes with names of output files for convenience
  * How many tests failed
  * How many tests were run 

The test run can be checked as follows:
* Compare the result of the test with expected pass or fail status.
* Compare text output with expected output stored in a file.
  * The text output is processed by a function called clean_output to remove dates and times.
  * This function is in your test file, not the library, because you probably need to fix it.

The first goal of creating the library was to abstract away all the lines in the script that I repeated for every test. This makes the tests readable and simple tests very fast to create.

One of the example tests uses a Mock Module technique. Simply put, the test creates a Bash function called “mysql” and exports it. Under test, when your script tries to run mysql, it runs the function instead. The function returns a useful test example that could be returned by the database in question. This technique relies on knowing what your script expects from “mysql”: in other words, this is for white box testing, not black box.

# Locations

The tests and the library are in a subfolder below the script under test.
The tests and library could be anywhere, such as in a test library folder below the top of your script.

The test output folders are in a subfolder of the test folder, named "test-out-" + script name.

# File Names

In the test output folders there are 3 files per test. Each file's main filename is the same as the name of the test.

The extensions are:
* .out
  * Raw output from running the test
* .comp
  * Comparison file, after it has been processed by `clean_output`
* .expected
  * Expected clean output

# Adding a new test

* Copy an existing test function.
* Change the name to be unique in the list of test functions and descriptive.
* Make other changes to your new test as required.
* Add the `test_init` line for that test, so it will run.

# Preparing expected output for a new test

Run your test, which we will call `foo_slump`, which will generate out and comp files:
* foo_slump.out
* foo_slump.comp

The script will fail with an error:
* `diff: test-out-mywc.sh/foo_slump.expected: No such file or directory`

Check that the contents of foo_slump.comp is correct. 
When it is correct after a run, copy it to foo_slump.expected.

Next time you run the script, the script should pass.
