#!/usr/bin/awk -f
BEGIN {
    openquest=0; itemcnt=0;
    openmc=0; opentf=1; openfb=0;
}
function outputquestion() {
    if (opentf) {
	if (ansnum==1) 
	    printf("\ttrue");
	else 
	    printf("\tfalse");
    } 
    if (openmc) {
	for (i=1;i<=itemcnt;i++) {
	    if (i==ansnum) 
		printf("\t%s\tcorrect",ans[i]);
	    else 
		printf("\t%s\tincorrect",ans[i]);
	}
    }
    if (openfb) printf("\t%s",ans[1]);
}
{
    if ($0 ~ /1 +True\/False/ ) opentf=1;
    if ($0 ~ /2 +Multiple-Choice/ ) { outputquestion(); itemcnt=0; opentf=0; openmc=1;  }
    if ($0 ~ /3 +Fill-in-the-Blank/ ) { outputquestion(); itemcnt=0; openmc=0; openfb=1; }
    if ($0 ~ /4 +Short Answer/ ) { outputquestion(); itemcnt=0; openfb=0; }
}
((openmc || opentf || openfb) && ($1 !~ /^[0-9]+.[0-9+]/)) {
    if ($1 ~ /[0-9]+\)/) {
	if (itemcnt) {
	    outputquestion();
	    itemcnt=0;
	}
	if (openquest) {
	    print "";
	}  
        openquest=1; startans=0;
			   
	if (openmc) { 
	    printf("MC\t%s",$2); 
	}
	if (opentf) { 
	    printf("TF\t%s",$2); 
	}
	if (openfb) {
	    printf("FIB\t%s",$2); 
	}
	if (openmc || opentf || openfb) {
	    for (i=3;i<=NF;i++) {
		printf(" %s",$i);
	    }
	}
    } else if (openquest) {
	if ($1 ~ /^[A-E]+\)/) {
	    startans=1;
	    itemcnt++;
	    ans[itemcnt]=$2;
	    for (i=3;i<=NF;i++) {
		ans[itemcnt]=ans[itemcnt] " " $i;
	    }
	} else if ($1=="Answer:" || $1=="Diff:" || $1=="Section") {
	    if ($1=="Answer:") {
		if (opentf) {
		    ans[1]="A) True";  ans[2]="B) False";
		    itemcnt=2;
		}
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
		    gsub("Answer:","",ans[1]);
		}
	    }
	} else {
   	    if (itemcnt) 
		ans[itemcnt]=ans[itemcnt] " " $0;
	    else 
		printf(" %s", $0);
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