#!/bin/bash
if [ -d html ]
then
    for i in html/*.xml
    do
	j=${i:5}
	k=${i/.xml/}
	echo '<html url_name="'$k'"/>'
    done
fi
if [ -d video ]
then
    for i in video/*.xml
    do
	j=${i:6}
	k=${i/.xml/}
	echo '<video url_name="'$k'"/>'
    done
fi
if [ -d problem ]
then
    for i in problem/*.xml
    do
	j=${i:8}
	k=${j/.xml/}
	echo '<problem url_name="'$k'"/>'
    done
fi
