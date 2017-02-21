function init {
    # initialize variables
    TESTCOUNT=0
    TESTPASS=0

    PROGRAM="$1"
    PROGRAM_NAME=$(basename $PROGRAM)

    # "message" is set by "check" function on failure
    # and printed in summary
    message=""

    # print initial state to the screen
    echo -n "Start date:  "
    date

    STARTDIR=`pwd`
    echo -n "PWD  $STARTDIR"
    echo

    # "t" - name of the test directory
    # - where we write test output and compute repeatable versions
    #   of the output to compare with expected output
    t=test-out-$PROGRAM_NAME

    # start reporting
    echo
    echo "This script tests $PROGRAM"
    echo

    # clean out old diff files
    clean
}

function clean {
    rm -f ./$t/*out
    rm -f ./$t/*comp
}

# optional check - most of my tests don't need this
function user_check {
    req_user=$1
    # only one user can run this test script and have it work
    # - due to file permissions, etc.
    user=`whoami`
    if [ "$user" != "$req_user" ]
    then
        echo
        echo "  Error: You must only run this script as user \"$req_user\", not \"$user\"."
        echo
        exit 1
    fi
}

function test_init {
    # do several common tasks required by all tests
    test="$1"
    let TESTCOUNT=$TESTCOUNT+1

    echo `date +%T` - $1
    $1
}

function check {
    # Here are the common tasks which happen after the test is run.

    # grab input
    mytest=$1
    result_desired=$2
    myresult=$3

    # result info
    if [ "$result_desired" = "true" ]
    then
        # expecting 'true' = 0
        cmp=-ne
        fail_text="false"
    else
        # expecting 'false' != 0
        cmp=-eq
        fail_text="true"
    fi

    # check the return value
    if [ $myresult $cmp 0 ]
    then
        message="$message\n'$test' - $PROGRAM unexpectedly returned $fail_text"
        return
    fi

    # "clean_output" is a call back function - it needs to be present in the test itself
    # - clean the output of the test for easy comparison to "expected" file
    clean_output $t/$mytest.out $t/$mytest.comp

    # compare test output
    if diff --ignore-all-space --ignore-blank-lines --brief $t/$mytest.expected $t/$mytest.comp
    then
        # should only reach here if return value and diff both pass
        let TESTPASS=$TESTPASS+1
        # in case of diff failure, "diff" gives adequate message
    fi
}


function summary {
    echo
    echo -e "$message"
    echo
    echo "-- Test summary"
    printf "Tests passed: %2d\n" $TESTPASS
    printf "Total tests:  %2d\n" $TESTCOUNT
    echo
    echo -n "End date:  "
    date
    exit
}

# run single test
function single_test {
    echo "Checking input $1 is a bash function (tests are functions)"
    msg=`type $1 | grep "is a function" | wc -l`
    if [ "$msg" -gt 0  ]
    then
        test_init $1
    else
        echo Function $1 not found.
	echo Here is a list of functions, including tests:
	echo
	grep ^function $0
    fi
    summary
}

