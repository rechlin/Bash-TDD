#!/usr/bin/env bash

source libtest.sh

init ../your-script

# callback function required by the test lib
# modify for your needs.
# this function is used to "clean" data with dates and other info that \
# is different in each run
function clean_output {
    in=$1
    out=$2

    # replace Qual ID's and LSF ID's with 6 hashes
    # replace dates with ##-##-##
    # replace times with ##:##
    # replace username with "user        "
    cat $1 | \
    sed -r -e 's/[[:digit:]]{7,}/#######/' \
           -e 's/[[:digit:]]{1,2}-[[:digit:]]{1,2}-[[:digit:]]{1,2}/##-##-##/' \
           -e 's/[[:digit:]]{1,2}:[[:digit:]]{1,2}/##:##/g' \
           -e 's/[[:digit:]]{1,2}h [[:digit:]]{1,2}m/##h ##m/' \
           -e "s/^$USER.+/user/"  > $2
    return
}


# --- end of common info required in every test script

# --- test functions

function no_param {
    $PROGRAM > $t/$test.out 2>&1
    result_val=$?

    check $test false $result_val
}

function mock_db {
    # Here we create mock access to the database.
    # The script is a shell script that uses "mysql".
    # The function is defined where the script is run,
    # in a subshell, ie in brackets (), so as not to pullute
    # the main script environment with the function.
    # This might not be necessary inside a function, but I didn't
    # take time to test it.
    (
    function mysql {
        # mock database
        # - tab separated output, just like mysql gives
        echo -e "1234567\tPENDING\totheruser"
    }
    export -f mysql

    $PROGRAM 1001 >$t/$test.out 2>&1
    )
    result_val=$?

    check $test true $result_val
}


# --- the rest is info that is also required in every script

# ---  run only one test if passed on command line
[ $# -gt 0 ] && single_test "$@"

# run the tests
test_init no_param
test_init mock_db

# wrap up
summary
