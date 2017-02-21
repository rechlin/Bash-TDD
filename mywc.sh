#!/bin/bash

if [ $# -eq 0 ]
then
    echo "Please supply the name of the file or files to count words in"
    exit 1
elif [ $1 = '--db' ]
then
    # this isn't enough info to access mysql and get data back
    shift
    mysql $1

else
    wc $*
fi
