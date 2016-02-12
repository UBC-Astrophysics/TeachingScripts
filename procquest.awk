#!/usr/bin/awk -f
BEGIN {
    openquest=0; itemcnt=0;
    openmc=0; opentf=1; openfb=0;
}
function outputquestion() {
    for (i=1;i<=itemcnt;i++) {
	if (i==ansnum) 
	    printf("\n*%s\n",ans[i]);
	else 
	    print ans[i];
    }
}
{
    if ($0 ~ /1 +True\/False/ ) opentf=1;
    if ($0 ~ /2 +Multiple-Choice/ ) { opentf=0; openmc=1; }
    if ($0 ~ /3 +Fill-in-the-Blank/ ) { openmc=0; openfb=1; }
    if ($0 ~ /4 +Short Answer/ ) { openfb=0; }
}
(openmc || opentf || openfb) {
    if ($1 ~ /[0-9]+\)/) {
	if (itemcnt) {
	    outputquestion();
	    itemcnt=0;
	}
	if (openquest) {
	    print "";
	}  
	if (openfb) print "Type: F";
        openquest=1;

	for (i=1;i<=NF;i++) {
	    printf("%s ",$i);
	}
	printf("\n");
    } else if (openquest) {
	if (opentf) {
	    ans[1]="A) True";  ans[2]="B) False";
	    itemcnt=2;
	}
	if ($1 ~ /^[A-E]+\)/) {
	    itemcnt++;
	    ans[itemcnt]=$1;
	    for (i=2;i<=NF;i++) {
		ans[itemcnt]=ans[itemcnt] " " $i;
	    }
	} else if ($1=="Answer:" || $1=="Diff:" || $1=="Section") {
	    if ($1=="Answer:") {
		if (openmc || opentf) {
		    if ($2=="A" || $2=="TRUE") 
			ansnum=1;
		    else if ($2=="B" || $2=="FALSE")
			ansnum=2;
		    else if ($2=="C")
			ansnum=3;
		    else if ($2=="D")
			ansnum=4;
		    else if ($2=="E")
			ansnum=5;
		} else if (openfb) {
		    itemcnt=1;
		    ans[1]=$0;
		    gsub("Answer:","A)",ans[1]);
		}
	    }
	} else {
	    if (itemcnt) 
		ans[itemcnt]=ans[itemcnt] " " $0;
	    else 
	}
    }
}
END {
    if (itemcnt) {
	outputquestion();
	openitem=0;
    }
if (openquest) {
    print "";
}
}