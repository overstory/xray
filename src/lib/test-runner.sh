#!/bin/bash
URL=http://localhost:8889/src/lib/test-runner.xqy
START=$(date +%s)
DIR=
MODULES=
TESTS=
CRED=$(tput setaf 1)
CGREEN=$(tput setaf 2) 
CDEFAULT=$(tput sgr0)       
STATUS=0

while getopts 'u:m:t:d:h' OPTION
do
    case $OPTION in
        u) URL="$OPTARG";;
        m) MODULES="$OPTARG";;
        t) TESTS="$OPTARG";;
        d) DIR="$OPTARG";;
        *)
            echo "usage: [-u test runner url] [-m module name pattern] [-t test name pattern] [-d test directory]"
            exit 1;;
    esac
done

RESPONSE=$(curl --silent "$URL?format=text&modules=$MODULES&tests=$TESTS&dir=$DIR")

while read -r LINE; do
    case $LINE in
        Module*) echo -ne $CDEFAULT;;
        *PASSED) echo -ne $CGREEN;;
        *FAILED) STATUS=1; echo -ne $CRED;;
        Finished*) echo -ne $CDEFAULT;;
    esac
    echo $LINE
done <<< "$RESPONSE"

DIFF=$(( $(date +%s) - $START ))
echo -ne $CDEFAULT
#echo -e "Time: $DIFF seconds"

exit $STATUS