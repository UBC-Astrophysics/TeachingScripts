#!/bin/bash
if [ $# -lt 5 ];
then
    echo Format:
    echo
    echo txt2library.sh display_name org library_code problem_file problem_id
    echo 
    exit
fi

mkdir library
mkdir library/problem
mkdir library/policies
awk 'BEGIN { printf("{}"); }' > library/policies/assets.json
echo '<library xblock-family="xblock.v1" display_name="'$1'" org="'$2'" library="'$3'">' > library/library.xml
ln -s $4 library/problem/$5
cd library/problem
awk -f ~/Documents/classes/edX/txt2xml.awk $5
rm $5
cd ..
~/Documents/classes/edX/makelibrary.sh >> library.xml
echo '</library>' >> library.xml
cd ..
tar cfz library.$3.tar.gz library/
rm -r library/

