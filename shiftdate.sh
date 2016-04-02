#!/bin/bash
if [ $# -lt 2 ];
then
    echo Format:
    echo   $0 file_to_process number_of_days_to_shift
    exit -1
fi
INSTALL_DIR=$(dirname "${0}")
tmpfile=$(mktemp /tmp/abc-script.XXXXXX)
python ${INSTALL_DIR}/shiftdate.py $1 $2 > $tmpfile
mv $tmpfile $1

