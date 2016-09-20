# Bash-TDD
A simple library for testing code using Bash. Can be used to test Bash or other languages.

To test your bash scripts, or to use Bash to test other scripts, you need a way to create tests quickly and easily. I have created a library to support testing in bash. I have used this technique to test Bash, Python, and Perl scripts.

One of the example tests uses a Mock Module technique. Simply put, the test creates a Bash function called “mysql” and exports it. The function returns a useful test example that could be returned by the database in question. This technique relies on knowing what your script expects from “mysql”: in other words, this is for white box testing, not black box.

Basically, the goal of the test scripts is to run some tests on your application/script and report:

- What tests were run
- What tests failed
- A summary:
-- Failure notes with names of output files for convenience
-- How many tests failed
-- How many tests were run 

The test name is used several times in this process, so I abstracted it into a variable. For instance, I use it to report what test is running, and when summarizing failure results.

The goal of creating the library was to abstract away all the lines in the script that I repeated for every test. This makes the tests readable and simple tests very fast to create.


