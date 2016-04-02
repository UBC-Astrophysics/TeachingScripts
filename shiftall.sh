#!/bin/bash
if [ $# -lt 2 ];
then
    echo Format:
    echo   $0 directory_to_process number_of_days_to_shift
    exit -1
fi
INSTALL_DIR=$(dirname "${0}")
find $1 -name '*.xml' -exec ${INSTALL_DIR}/shiftdate.sh \{\} $2 \; 
find $1 -name '*.html' -exec ${INSTALL_DIR}/shiftdate.sh \{\} $2 \; 
